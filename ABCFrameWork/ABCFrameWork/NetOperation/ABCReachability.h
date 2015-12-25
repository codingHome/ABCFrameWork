//
//  ABCReachability.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/25.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ABCNetStatus) {
    ABCNetStatusNone = 1,
    ABCNetStatusWwan,
    ABCNetStatusWifi,
};

extern NSString *kABCReachabilityChangedNotification;

@interface ABCReachability : NSObject

+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

- (ABCNetStatus)currentReachabilityStatus;

@end
