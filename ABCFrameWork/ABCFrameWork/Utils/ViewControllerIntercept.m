//
//  ViewControllerIntercept.m
//  MethodSwizzling
//
//  Created by Robert on 15/4/27.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ViewControllerIntercept.h"
#import "Aspects.h"
#import <UIKit/UIKit.h>

@implementation ViewControllerIntercept

+ (void)load {
    [super load];
    [ViewControllerIntercept sharedIntercept];
}

+ (instancetype)sharedIntercept {
    static dispatch_once_t onceToken;
    static ViewControllerIntercept *sharedIntercept;
    dispatch_once(&onceToken, ^{
        sharedIntercept = [[ViewControllerIntercept alloc] init];
    });
    return sharedIntercept;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self viewDidLoad:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
    }
    return self;
}

- (void)viewDidLoad:(UIViewController *)viewController {
    NSLog(@"[%@ loadView]", [viewController class]);
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    NSLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
}

@end
