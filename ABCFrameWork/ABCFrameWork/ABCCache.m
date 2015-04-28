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

- (void)getFormTableWithObject:(id)object {
    NSString *ClassName = [NSString stringWithCString:object_getClassName(object) encoding:NSUTF8StringEncoding];
    [self getObjectById:ClassName fromTable:ClassName];
}

@end
