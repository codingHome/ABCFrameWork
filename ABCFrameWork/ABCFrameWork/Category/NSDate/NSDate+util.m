//
//  NSDate+util.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/25.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "NSDate+util.h"

@implementation NSDate (util)

+ (NSDate *)formatDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *resultDate = [dateFormatter dateFromString:dateString];
    
    return resultDate;
}

@end
