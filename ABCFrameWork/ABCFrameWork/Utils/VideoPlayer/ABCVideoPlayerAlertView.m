//
//  ABCVideoPlayerAlertView.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ABCVideoPlayerAlertView.h"

@interface ABCVideoPlayerAlertView ()

@property (nonatomic, assign) ABCVideoAlertType type;

@end

@implementation ABCVideoPlayerAlertView

- (instancetype)initWithType:(ABCVideoAlertType)type {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.type = type;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.mas_equalTo(weakSelf);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf.imageView);
    }];
    
    [super updateConstraints];
}
@end
