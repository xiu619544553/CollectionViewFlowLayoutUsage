//
//  ViewController.m
//  WaterFallFlowLayout
//
//  Created by hanxiuhui on 2020/6/21.
//

#import "ViewController.h"
#import "TKWaterFallFlowLayout.h"
#import "TKCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>

static NSString *cellId = @"TKCollectionViewCell";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TKWaterFallFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *heightArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"瀑布流";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) wself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        sself.page = 1;
        [sself loadNewData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        sself.page += 1;
        [sself loadMoreData];
    }];
}

- (void)loadNewData {
    [_heightArray removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 10; i ++) {
            int height = arc4random_uniform(300);
            [self.heightArray addObject:height < 100 ? @100 : @(height)];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 10; i ++) {
            int height = arc4random_uniform(300);
            [self.heightArray addObject:height < 100 ? @100 : @(height)];
        }
        
        if (self.page == 5) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.collectionView reloadData];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _heightArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = UIColor.brownColor;
    cell.title = [NSString stringWithFormat:@"%@-%@", @(_page), [_heightArray objectAtIndex:indexPath.item]];
    return cell;
}

#pragma mark - TKWaterFallFlowLayout

- (CGFloat)layout:(TKWaterFallFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return [_heightArray objectAtIndex:index].doubleValue;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        TKWaterFallFlowLayout *flowLayout = [[TKWaterFallFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.columnCount = 3;
        flowLayout.columnSpacing = 5.f;
        flowLayout.rowSpacing = 5.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.f, 0.f, 0.f, 0.f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:TKCollectionViewCell.class forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (NSMutableArray<NSNumber *> *)heightArray {
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
@end
