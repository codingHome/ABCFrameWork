//
//  ABCCache.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCCache.h"

static NSString *DBName = @"Cache.db";

@implementation ABCCache

+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    static ABCCache *sharedCache;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ABCCache alloc] init];
    });
    return sharedCache;
}

-(instancetype)init{
    self = [super initDBWithName:DBName];
    if (self) {
        
    }
    return self;
}

- (void)putIntoTableWithObject:(id)object {
    NSString *ClassName = [NSString stringWithCString:object_getClassName(object) encoding:NSUTF8StringEncoding];
    [self createTableWithName:ClassName];
    [self putObject:object withId:ClassName intoTable:ClassName];
}

- (id)getFormTableWithTableName:(NSString *)name {
    return [self getObjectById:name fromTable:name];
}

@end
