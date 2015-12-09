//
//  ABCHub.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCHub.h"

@implementation ABCHub

+ (void)abc_show {
    [self setBackgroundColor:[UIColor blackColor]];
    [self setForegroundColor:[UIColor whiteColor]];
    [self show];
}

+ (void)abc_showWithStatus:(NSString*)string {
    [self setBackgroundColor:[UIColor blackColor]];
    [self setForegroundColor:[UIColor whiteColor]];
    [self showWithStatus:string];
}

@end
