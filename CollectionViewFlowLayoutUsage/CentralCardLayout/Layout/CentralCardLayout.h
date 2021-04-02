//
//  CentralCardLayout.h
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//  Copyright © 2021年 Apple. All rights reserved.
//  966

#import <UIKit/UIKit.h>

typedef void(^CenterIndexPathHandler)(NSIndexPath *indexPath);

// CentralCardHorizontalLayout
@interface CentralCardLayout : UICollectionViewFlowLayout

@property (nonatomic , strong) CenterIndexPathHandler centerBlock;

@property (nonatomic, assign) BOOL isZoom;


@end
