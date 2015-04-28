//
//  ABCCache.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "YTKKeyValueStore.h"

@interface ABCCache : YTKKeyValueStore

/**
 *  单例方法
 *
 *  @return 单例实例
 */
+ (instancetype)sharedCache;

/**
 *  将缓存对象存入数据库
 *
 *  @param object 被缓存对象
 */
- (void)putIntoTableWithObject:(id)object;

/**
 *  将缓存对象从数据库取出
 *
 *  @param name 表名
 *  @return 检索结果
 */
- (id)getFormTableWithTableName:(NSString *)name;

@end
