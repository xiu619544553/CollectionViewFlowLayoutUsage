//
//  TKCollectionViewCell.m
//  WaterFallFlowLayout
//
//  Created by hanxiuhui on 2020/6/21.
//

#import "TKCollectionViewCell.h"

@interface TKCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TKCollectionViewCell

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
