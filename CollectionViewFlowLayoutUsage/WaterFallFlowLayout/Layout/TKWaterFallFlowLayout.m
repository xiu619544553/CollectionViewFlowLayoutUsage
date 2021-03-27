//
//  TKWaterFallFlowLayout.m
//  WaterFallFlowLayout
//
//  Created by hanxiuhui on 2020/6/21.
//

#import "TKWaterFallFlowLayout.h"

@interface TKWaterFallFlowLayout ()

/// 存放所有的布局属性
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;

/// 存放所有列的当前高度
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeightArray;

/// 内容的高度
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation TKWaterFallFlowLayout

#pragma mark - LifeCycle Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
        _columnCount = 2;
        _columnSpacing = 10.f;
        _rowSpacing = 10.f;
        _sectionInset = UIEdgeInsetsZero;
        
        _attrsArray = [NSMutableArray array];
        _columnHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Override Methods

- (void)prepareLayout {
    [super prepareLayout];
    
    NSLog(@"%s", __func__);
    
    _contentHeight = 0.f;
    [_attrsArray removeAllObjects];
    [_columnHeightArray removeAllObjects];
    
    // 设置每一列的默认高度
    for (int i = 0; i < _columnCount; i ++) {
        [_columnHeightArray addObject:@(_sectionInset.top)];
    }
    
    // 为每一个 cell创建布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/// 返回位于指定索引路径处的 item的布局属性。子类必须重写此方法并使用它返回集合视图中项的布局信息。使用此方法仅为具有相应单元格的项提供布局信息。请勿将其用作辅助视图或装饰视图(头/尾视图)。
/// @param indexPath item 的索引路径
/// @return 一个布局属性对象，其中包含应用于 item的单元格的信息
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(_delegate, @"delegate is nil");
    
    // 获取布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // width、height
    CGFloat cellWidth = (CGRectGetWidth(self.collectionView.frame) - _sectionInset.left - _sectionInset.right - (_columnCount - 1) * _columnSpacing) / _columnCount;
    CGFloat cellHeight = [_delegate layout:self heightForItemAtIndex:indexPath.item itemWidth:cellWidth];
    
    // 找 y最小的列
    __block NSInteger minYColumn = 0;
    __block CGFloat minColumnHeight = _columnHeightArray.firstObject.doubleValue;
    [_columnHeightArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (minColumnHeight > obj.doubleValue) {
            minColumnHeight = obj.doubleValue;
            minYColumn = idx;
        }
    }];
    
    // frame
    CGFloat cellX = _sectionInset.left + minYColumn * (cellWidth + _columnSpacing);
    CGFloat cellY = minColumnHeight;
    if (cellY != _sectionInset.top) { cellY += _rowSpacing; }
    attr.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
    
    // 更新最短那一列的高度
    [_columnHeightArray replaceObjectAtIndex:minYColumn withObject:@(CGRectGetMaxY(attr.frame))];
    
    // 内容高度，即最大 y值
    CGFloat maxColumnHeight = [_columnHeightArray objectAtIndex:minYColumn].doubleValue;
    if (_contentHeight < maxColumnHeight) {
        _contentHeight = maxColumnHeight;
    }
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attrsArray;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, _contentHeight + _sectionInset.bottom);
}

@end
