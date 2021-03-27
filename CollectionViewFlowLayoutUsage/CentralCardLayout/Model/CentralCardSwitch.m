//
//  CentralCardSwitch.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//  Copyright © 2021年 Apple. All rights reserved.
//

#import "CentralCardSwitch.h"
#import "CentralCardLayout.h"
#import "CentralCardLayoutCollectionViewCell.h"

static NSString *cellId = @"CentralCardLayoutCollectionViewCell";

@interface CentralCardSwitch ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat dragStartX;

@property (nonatomic, assign) CGFloat dragEndX;

@property (nonatomic, assign) CGFloat dragAtIndex;

@end

@implementation CentralCardSwitch

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addCollectionView];
}

- (void)addCollectionView {
    //避免UINavigation对UIScrollView产生的偏移问题
    [self addSubview:[UIView new]];
    
    CentralCardLayout *flowLayout = [[CentralCardLayout alloc] init];
    __weak typeof(self)weakSelf = self;
    flowLayout.centerBlock = ^(NSIndexPath *indexPath) {
        [weakSelf updateSelectedIndex:indexPath];
    };
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CentralCardLayoutCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    self.collectionView.userInteractionEnabled = true;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)updateSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.row != _selectedIndex) {
        _selectedIndex = indexPath.row;
        [self performScrollDelegateMethod];
    }
}

#pragma mark -
#pragma mark Setter
- (void)setModels:(NSArray<CentralCardModel *> *)models {
    _models = models;
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark CollectionDelegate
//配置cell居中
- (void)fixCellToCenter {
    if (_selectedIndex != [self dragAtIndex]) {
        [self scrollToCenterAnimated:true];
        return;
    }
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(self.dragEndX -  self.dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenterAnimated:true];
}

//滚动到中间
- (void)scrollToCenterAnimated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!_pagingEnabled) {return;}
    self.dragStartX = scrollView.contentOffset.x;
    self.dragAtIndex = _selectedIndex;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self scrollToCenterAnimated:YES];
    [self performClickDelegateMethod];
}

#pragma mark -
#pragma mark CollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
    
    CentralCardLayoutCollectionViewCell* card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    card.model = self.models[indexPath.row];
    return  card;
}

#pragma mark -
#pragma mark 功能方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [self scrollToCenterAnimated:animated];
}

- (void)performClickDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidClickAtIndex:)]) {
        [_delegate cardSwitchDidClickAtIndex:_selectedIndex];
    }
}

- (void)performScrollDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidScrollToIndex:)]) {
        [_delegate cardSwitchDidScrollToIndex:_selectedIndex];
    }
}


@end
