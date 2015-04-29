//
//  ABCUserInfo.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCUserInfo : NSObject

/**
 *  单例方法
 *
 *  @return 实例变量
 */
+(instancetype)sharedUserInfo;

/**
 *  是否首次登陆
 */
@property (nonatomic, assign, readonly) BOOL isFirstLogin;

/**
 *  用户信息
 */
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

/**
 *  注册用户信息
 *
 *  @param userInfo 用户信息
 */
- (void)registUserInfo:(NSDictionary *)userInfo;

/**
 *  登出抹除数据
 */
- (void)logout;

@end
