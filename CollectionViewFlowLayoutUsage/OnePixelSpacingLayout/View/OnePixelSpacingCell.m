//
//  OnePixelSpacingCell.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/4/2.
//

#import "OnePixelSpacingCell.h"

@interface OnePixelSpacingCell ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation OnePixelSpacingCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

#pragma mark - setter

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textLabel.text = text;
}

#pragma mark - getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = UIColor.whiteColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:50.f];
    }
    return _textLabel;
}
@end
