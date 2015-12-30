//
//  ABCSearchBar.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "ABCSearchBar.h"

@implementation ABCSearchBar

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //移除背景
        [[[[[self subviews] objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [self setBackgroundColor:[UIColor colorWithRed:242/255.0 green:241/255.0 blue:249/255.0 alpha:1]];
        self.placeholder = @"Search";
        [self setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(0, 0)];
    }
    return self;
}

@end
