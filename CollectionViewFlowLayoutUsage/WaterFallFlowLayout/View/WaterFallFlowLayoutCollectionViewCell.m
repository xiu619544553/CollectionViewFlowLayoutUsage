//
//  WaterFallFlowLayoutCollectionViewCell.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//

#import "WaterFallFlowLayoutCollectionViewCell.h"

@interface WaterFallFlowLayoutCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation WaterFallFlowLayoutCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.center = self.contentView.center;
}

@end
