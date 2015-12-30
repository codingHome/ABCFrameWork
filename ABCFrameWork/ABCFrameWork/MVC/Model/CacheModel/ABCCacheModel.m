//
//  ABCCacheModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/25.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCCacheModel.h"

@implementation ABCCacheModel

- (NSInteger)intervalTime {
    return 3600 * 4;
}

- (void)insert {
    BOOL isExist = [getCacheDB() checkTableIsExist:[self description]];
    if (!isExist) {
        [getCacheDB() createTable:[self class]];
    }
    
    NSArray *array = [getCacheDB() queryObjectFromTable:[self class] conditions:[NSString stringWithFormat:@"md5_name = ?"] args:[NSArray arrayWithObject:self.md5_name] order:nil];
    if ([array count] > 0) {
        [getCacheDB() updateTable:[self class] object:[array firstObject]];
    }else {
        [getCacheDB() insertTable:[self class] object:self];
    }
}

+ (ABCCacheModel *)queryWithMd5:(NSString *)md5 {
    BOOL isExist = [getCacheDB() checkTableIsExist:[self description]];
    if (!isExist) {
        return nil;
    }
    
    NSArray *array = [getCacheDB() queryObjectFromTable:[self class] conditions:[NSString stringWithFormat:@"md5_name = ?"] args:[NSArray arrayWithObject:md5] order:nil];
    if ([array count] > 0) {
        return [array objectAtIndex:0];
    }
    return nil;
}

@end
