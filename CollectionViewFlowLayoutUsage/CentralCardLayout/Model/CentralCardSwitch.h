//
//  CentralCardSwitch.h
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//  Copyright © 2021年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CentralCardModel.h"

@protocol CardSwitchDelegate <NSObject>

@optional

/// 点击卡片代理方法
- (void)cardSwitchDidClickAtIndex:(NSInteger)index;

/// 滚动卡片代理方法
- (void)cardSwitchDidScrollToIndex:(NSInteger)index;

@end

@interface CentralCardSwitch : UIView

/// 当前选中位置
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

/// 设置数据源
@property (nonatomic, strong) NSArray <CentralCardModel *>*models;

/// 代理
@property (nonatomic, weak) id<CardSwitchDelegate>delegate;

/// 是否分页，默认为YES
@property (nonatomic, assign) BOOL pagingEnabled;

/// 手动滚动到某个卡片位置
- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;



@end
