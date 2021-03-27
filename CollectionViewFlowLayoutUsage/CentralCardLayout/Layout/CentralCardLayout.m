//
//  CentralCardLayout.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//  Copyright © 2021年 Apple. All rights reserved.
//

/*
 1）-(void)prepareLayout  设置layout的结构和初始需要的参数等
 2) -(CGSize) collectionViewContentSize 确定collectionView的所有内容的尺寸
 3）-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定
 4)在需要更新layout时，需要给当前layout发送
      1)-invalidateLayout， 该消息会立即返回，并且预约在下一个loop的时候刷新当前layout
      2)-prepareLayout，
      3)依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 */

#import "CentralCardLayout.h"

//居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = 0.7f;
static float CardHeightScale = 0.8f;

@implementation CentralCardLayout

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isZoom = NO;
    }
    return self;
}

#pragma mark - Override Methods

/// 设置 layout 的结构和初始需要的参数等
/// collection view 在布局无效(invalidated)之后和重新查询布局信息之前，集合视图再次调用 -prepareLayout
/// 子类在重载时必须调用 [super prepareLayout]
- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake([self insetY], [self insetX], [self insetY], [self insetX]);
    self.itemSize = CGSizeMake([self itemWidth], [self itemHeight]);
    self.minimumLineSpacing = 30;
}

#pragma mark - UICollectionView 调用这四个方法来确定布局信息

/// 实现 -layoutAttributesForElementsInRect: 为 supplementary 或 decoration视图返回布局属性，或以屏幕上需要的方式执行布局
/// 此外，所有的布局子类都应该实现-layoutAttributesForItemAtIndexPath:根据需要为特定的索引路径返回布局属性实例
/// 如果布局支持 任何supplementary 或 decoration类型，它还应该为这些类型实现相应的atIndexPath:方法
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获取cell的布局
    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    if (!self.isZoom) return attributesArr;
    
    // 设置缩放动画
    // 屏幕中线
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
    
    // 最大移动距离，计算范围是移动出屏幕前的距离
    CGFloat maxApart = (self.collectionView.bounds.size.width + [self itemWidth])/2.0f;
    
    // 刷新cell缩放
    for (UICollectionViewLayoutAttributes *attributes in attributesArr) {

        // 获取cell中心和屏幕中心的距离
        CGFloat apart = fabs(attributes.center.x - centerX);
        NSLog(@"cellCenterX=%@", @(attributes.center.x));

        // 移动进度 -1~0~1
        CGFloat progress = apart/maxApart;

        // 在屏幕外的cell不处理
        if (fabs(progress) > 1) {continue;}

        // 根据余弦函数，弧度在 -π/4 到 π/4,即 scale在 √2/2~1~√2/2 间变化
        CGFloat scale = fabs(cos(progress * M_PI/4));

        // 缩放大小
        attributes.transform = CGAffineTransformMakeScale(scale, scale);

        // 更新中间位
        if (apart <= [self itemWidth]/2.0f) {
            self.centerBlock(attributes.indexPath);
        }
    }
    
    return attributesArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

#pragma mark - 实时刷新布局

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark -
#pragma mark 配置方法
// 卡片宽度
- (CGFloat)itemWidth {
    return self.collectionView.bounds.size.width * CardWidthScale;
}

- (CGFloat)itemHeight {
    return self.collectionView.bounds.size.height * CardHeightScale;
}

// 设置左右缩进
- (CGFloat)insetX {
    CGFloat insetX = (self.collectionView.bounds.size.width - [self itemWidth])/2.0f;
    return insetX;
}

- (CGFloat)insetY {
    CGFloat insetY = (self.collectionView.bounds.size.height - [self itemHeight])/2.0f;
    return insetY;
}

@end
