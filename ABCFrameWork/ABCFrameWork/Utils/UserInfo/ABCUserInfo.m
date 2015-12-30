//
//  ABCUserInfo.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "ABCUserInfo.h"

static NSString *ABC_USER_INFO = @"ABC_USER_INFO";

@implementation ABCUserInfo

+(ABCUserInfo *)sharedUserInfo {
    static dispatch_once_t onceToken;
    static ABCUserInfo *sharedUserInfo;
    dispatch_once(&onceToken, ^{
        sharedUserInfo = [[ABCUserInfo alloc] init];
    });
    return sharedUserInfo;
}

- (BOOL)isFirstLogin {
    return [self userInfo] ? YES : NO;
}

- (void)registUserInfo:(NSDictionary *)userInfo {
    [[NSUserDefaults standardUserDefaults] setObject:userInfo
                                              forKey:ABC_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)userInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:ABC_USER_INFO];
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ABC_USER_INFO];
}

@end
