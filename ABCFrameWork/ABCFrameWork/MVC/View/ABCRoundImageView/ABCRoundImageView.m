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
    [layer setCornerRadius:self.frame.size.height/2.0];
    
    [layer setBorderWidth:0.1];
    [layer setBorderColor:[[UIColor clearColor] CGColor]];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.frame.size.height/2.0];
    
    [layer setBorderWidth:0.1];
    [layer setBorderColor:[[UIColor clearColor] CGColor]];
}

@end
