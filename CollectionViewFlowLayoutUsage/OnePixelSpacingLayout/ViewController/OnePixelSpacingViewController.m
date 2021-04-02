//
//  OnePixelSpacingViewController.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/4/2.
//

#import "OnePixelSpacingViewController.h"
#import "OnePixelSpacingCell.h"

static CGFloat minimumLineSpacing = 1.f;

@interface OnePixelSpacingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation OnePixelSpacingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OnePixelSpacingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(OnePixelSpacingCell.class)
                                                                          forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

#pragma mark - Private Methods

- (CGSize)cellSize {
    CGFloat cellWidth = [self fixSlitWith:[UIScreen mainScreen].bounds colCount:3 space:minimumLineSpacing];
    return CGSizeMake(cellWidth, cellWidth * 16.f / 9.f);
}

/// 计算cell的宽度
/// @param rect     父视图的大小
/// @param colCount 有几列
/// @param space    间距
- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    // 总共留出的距离
    CGFloat totalSpace = (colCount - 1) * space;
    
    // 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;
    
    // (1px=0.5pt,6Plus为3px=1pt)
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale;
    
    // 取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    CGFloat realItemWidth = floor(itemWidth) + fixValue;
    if (realItemWidth < itemWidth) { // 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    
    // 算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    CGFloat realWidth = colCount * realItemWidth + totalSpace;
    
    // 偏移距离
    CGFloat pointX = (realWidth - rect.size.width) / 2;
    
    // 向左偏移
    rect.origin.x = -pointX;
    rect.size.width = realWidth;
    
    // 每个cell的真实宽度
    return realItemWidth;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = [self cellSize];
        layout.sectionInset = UIEdgeInsetsMake(minimumLineSpacing, 0.f, minimumLineSpacing, 0.f);
        layout.minimumLineSpacing = minimumLineSpacing;
        layout.minimumInteritemSpacing = 1.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        [_collectionView registerClass:[OnePixelSpacingCell class]
            forCellWithReuseIdentifier:NSStringFromClass([OnePixelSpacingCell class])];
    }
    return _collectionView;
}

@end
