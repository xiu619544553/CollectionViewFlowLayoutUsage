//
//  TKWaterFallFlowLayout.h
//  WaterFallFlowLayout
//
//  Created by hanxiuhui on 2020/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TKWaterFallFlowLayout;

@protocol TKWaterFallFlowLayoutDelegate <NSObject>

@required

/// 询问代理，代理返回 cell的高度
/// @param layout 瀑布流布局
/// @param index 下标
/// @param itemWidth cell的宽
- (CGFloat)layout:(TKWaterFallFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@end


@interface TKWaterFallFlowLayout : UICollectionViewLayout

/// 有几列。默认值 2
@property (nonatomic, assign) NSUInteger columnCount;

/// 列间距。默认值 10.f
@property (nonatomic, assign) CGFloat columnSpacing;

/// 行间距。默认值 10.f
@property (nonatomic, assign) CGFloat rowSpacing;

/// collectionView的外边距。默认值 UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, weak) id<TKWaterFallFlowLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
