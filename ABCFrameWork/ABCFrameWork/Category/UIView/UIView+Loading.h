//
//  UIView+Loading.h
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCLoadingView.h"

@interface UIView (Loading)

@property (strong, nonatomic) ABCLoadingView *loadingView;

@property (assign, nonatomic, readonly) BOOL isLoading;

- (void)beginLoading;
- (void)endLoading;

@end
