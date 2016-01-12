//
//  ABCLoadingView.h
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCLoadingView : UIView

@property (assign, nonatomic, readonly) BOOL isLoading;

- (void)startAnimating;

- (void)stopAnimating;

@end
