//
//  Card.h
//  CardSwitchDemo
//
//  Created by hello on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//  被切换的卡片

#import <UIKit/UIKit.h>
#import "CentralCardModel.h"

@interface CentralCardLayoutCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CentralCardModel *model;

@end
