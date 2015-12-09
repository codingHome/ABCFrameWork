//
//  ABCDataBase.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCDataBase.h"

@implementation ABCDataBase

+ (instancetype)sharedDataBase {
    static ABCDataBase *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithPath:ABC_PATH_FORMAT(ABC_PATH_LIBRARY, @"data.db")];
    });
    return instance;
}

@end
