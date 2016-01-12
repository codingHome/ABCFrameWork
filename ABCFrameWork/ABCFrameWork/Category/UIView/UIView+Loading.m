//
//  UIView+Loading.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

static char LoadingViewKey;

@implementation UIView (Loading)

- (void)setLoadingView:(ABCLoadingView *)loadingView{
    [self willChangeValueForKey:@"LoadingViewKey"];
    objc_setAssociatedObject(self, &LoadingViewKey,
                             loadingView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingViewKey"];
}

- (ABCLoadingView *)loadingView{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

- (BOOL)isLoading{
    return self.loadingView? self.loadingView.isLoading: NO;
}

- (void)beginLoading{
    if (!self.loadingView) { //初始化LoadingView
        self.loadingView = [[ABCLoadingView alloc] init];
        [self addSubview:self.loadingView];
        
        WS(weakSelf);
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
        }];
    }
    
    
    [self.loadingView startAnimating];
}

- (void)endLoading{
    if (self.loadingView) {
        [self.loadingView stopAnimating];
    }
}

@end
