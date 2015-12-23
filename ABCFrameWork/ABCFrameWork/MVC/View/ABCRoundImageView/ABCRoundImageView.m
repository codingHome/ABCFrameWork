//
//  ABCRoundImageView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCRoundImageView.h"

@implementation ABCRoundImageView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5];
    
    [layer setBorderWidth:0.1];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5];
    
    [layer setBorderWidth:0.1];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
