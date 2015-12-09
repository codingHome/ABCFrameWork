//
//  ABCDataBase.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface ABCDataBase : FMDatabaseQueue

/**
 *  单例方法
 *
 *  @return 数据库对象
 */
+ (instancetype)sharedDataBase;

@end
