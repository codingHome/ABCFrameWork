//
//  ABCRoundButton.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCRoundButton.h"

@implementation ABCRoundButton

- (void)setBorderColor:(UIColor *)borderColor {
    CALayer * layer = [self layer];
    [layer setBorderColor:[borderColor CGColor]];
}

-(void)setCornerRadius:(NSUInteger)cornerRadius {
    CALayer * layer = [self layer];
    [layer setCornerRadius:cornerRadius];
}

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
