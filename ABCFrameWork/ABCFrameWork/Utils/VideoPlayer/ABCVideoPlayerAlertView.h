//
//  ABCVideoPlayerAlertView.h
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ABCVideoAlertType) {
    ABCVideoAlertTypeVolume,
    ABCVideoAlertTypeBrightness,
    ABCVideoAlertTypeProgress,
};

@interface ABCVideoPlayerAlertView : UIView

@property (nonatomic, assign) ABCVideoAlertType type;

@property (nonatomic, strong) UILabel           *titleLabel;

- (instancetype)initWithType:(ABCVideoAlertType)type;

@end
