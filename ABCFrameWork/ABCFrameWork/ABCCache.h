//
//  ABCCache.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

@interface ABCCache : YTKKeyValueStore

/**
 *  将缓存对象存入数据库
 *
 *  @param object 被缓存对象
 */
- (void)putIntoTableWithObject:(id)object;

/**
 *  将缓存对象从数据库取出
 *
 *  @param object 缓存对象
 */
- (void)getFormTableWithObject:(id)object;

@end
