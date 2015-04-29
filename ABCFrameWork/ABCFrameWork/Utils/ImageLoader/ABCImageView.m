//
//  ABCImageView.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCImageView.h"
#import "UIImageView+WebCache.h"

@implementation ABCImageView

- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)image {
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)image placeHolderImage:(NSString *)placeHolder {
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:placeHolder]];
    }
    return self;
}
@end
