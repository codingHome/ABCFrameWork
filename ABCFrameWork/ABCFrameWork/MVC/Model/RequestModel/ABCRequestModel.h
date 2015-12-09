//
//  ABCRequestModel.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCRequestModel : NSObject

/**
 *  获取对象属性和值
 *
 *  @return 属性字典
 */
- (NSDictionary *)instancePropertiesList;

/**
 *  获取类属性
 *
 *  @return 属性数组
 */
- (NSMutableArray *)classPropertyList;

/**
 *  根据对象属性值生成URL
 *
 *  @return 完整的请求地址
 */
- (NSString *)operationURL;

@end
