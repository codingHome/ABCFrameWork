//
//  ABCNetObserver.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ABCNetStatus) {
    ABCNetStatusWifi = 1,
    ABCNetStatusWWAN,
    ABCNetStatusNone
};

static NSString *kABCNetStatusChangeNotification = @"kABCNetStatusChangeNotification";

@interface ABCNetObserver : NSObject

/**
 *  单例方法
 *
 *  @return 实例变量
 */
+ (instancetype)sharedNetObserver;

/**
 *  当前网络状态
 */
@property (nonatomic, assign, readonly) ABCNetStatus status;

/**
 *  开始监听网络状态
 */
- (void)startNotifier;

/**
 *  帮助对象注册网络状态变化通知
 */
- (void)registNotification:(NSObject *)obj selector:(SEL)selector;

/**
 *  帮助对象注销网络状态变化通知
 *
 *  @param obj 注销通知对象
 */
- (void)removeNotification:(NSObject *)obj;

@end
