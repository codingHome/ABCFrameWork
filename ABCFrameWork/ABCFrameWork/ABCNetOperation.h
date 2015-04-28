//
//  ABCNetOperation.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OperationMethd){
    ABCNetOperationGetMethod = 1,
    ABCNetOperationPostMethod,
    ABCNetOperationPostDataMethod
};

@interface ABCNetOperation : NSObject

/**
 *  是否需要缓存
 */
@property (nonatomic, assign)BOOL cache;

/**
 *  是否显示菊花界面
 */
@property (nonatomic, assign)BOOL progressHUB;

/**
 *  请求方式
 */
@property (nonatomic, assign)OperationMethd method;

@end
