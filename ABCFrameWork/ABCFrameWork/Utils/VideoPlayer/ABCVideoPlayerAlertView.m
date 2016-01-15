//
//  ABCVideoPlayerAlertView.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ABCVideoPlayerAlertView.h"

static NSString * const ABCVideoAlertTypeVolumeImageName = @"video-player-close";

static NSString * const ABCVideoAlertTypeBrightnessImageName = @"video-player-fullscreen";

static NSString * const ABCVideoAlertTypeProgressImageName = @"video-player-pause";

static const NSUInteger ABCVideoAlertFontSize = 23;

@interface ABCVideoPlayerAlertView ()

@property (nonatomic, strong) UIImageView *imageView;

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
        _titleLabel.font = [UIFont boldSystemFontOfSize:ABCVideoAlertFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(void)setType:(ABCVideoAlertType)type {
    if (_type && _type == type) {
        return;
    }else {
        _type = type;
        switch (self.type) {
            case ABCVideoAlertTypeVolume:
                self.imageView.image = [UIImage imageNamed:ABCVideoAlertTypeVolumeImageName];
                break;
            case ABCVideoAlertTypeBrightness:
                self.imageView.image = [UIImage imageNamed:ABCVideoAlertTypeBrightnessImageName];
                break;
            case ABCVideoAlertTypeProgress:
                self.imageView.image = [UIImage imageNamed:ABCVideoAlertTypeProgressImageName];
                break;
            default:
                break;
        }
    }
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
