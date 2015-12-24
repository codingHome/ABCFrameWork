//
//  ABCNetObserver.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetObserver.h"
#import "Reachability.h"

NSString *const kABCNetStatusChangeNotification= @"kABCNetStatusChangeNotification";

@interface ABCNetObserver ()

@property (nonatomic, strong)Reachability *reach;

@end

@implementation ABCNetObserver

+ (ABCNetObserver *)sharedNetObserver {
    static dispatch_once_t onceToken;
    static ABCNetObserver *sharedNetObserver;
    dispatch_once(&onceToken, ^{
        sharedNetObserver = [[self alloc] init];
    });
    return sharedNetObserver;
}

- (id)init {
    if (self = [super init]) {
        _status = 0;
        _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    }
    return self;
}

- (void)startNotifier {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [_reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
    switch (_reach.currentReachabilityStatus) {
        case ReachableViaWiFi:
            _status = ABCNetStatusWifi;
            break;
        case ReachableViaWWAN:
            _status = ABCNetStatusWWAN;
            break;
        case NotReachable:
            _status = ABCNetStatusNone;
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kABCNetStatusChangeNotification object:self];
}

- (void)registNotification:(NSObject *)obj selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:obj
                                             selector:selector
                                                 name:kABCNetStatusChangeNotification
                                               object:self];
}

- (void)removeNotification:(NSObject *)obj {
    
    [[NSNotificationCenter defaultCenter] removeObserver:obj
                                                    name:kABCNetStatusChangeNotification
                                                  object:nil];
}
@end
