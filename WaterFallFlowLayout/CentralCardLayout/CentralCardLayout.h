//
//  CentralCardLayout.h
//  iOS_14_0_1
//
//  Created by hello on 2021/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CentralCardLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL scaled;
@property (nonatomic, assign) CGSize lastCollectionViewSize;

@end

NS_ASSUME_NONNULL_END
