//
//  ABCNetOperation.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCNetRequest.h"

typedef NS_ENUM(NSUInteger, OperationMethod){
    ABCNetOperationGetMethod = 1,
    ABCNetOperationPostMethod,
    ABCNetOperationPostDataMethod
};

@class ABCNetOperation;

@protocol  ABCNetOperationProtocol <NSObject>

@required

- (void)netOperationStarted:(ABCNetOperation*)operation;
- (void)netOperationSuccess:(id)result;
- (void)netOperationFail:(NSError*)error;

@end

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
@property (nonatomic, assign)OperationMethod method;

/**
 *  请求体
 */
@property (nonatomic, strong)RequestBodyBlock bodyBlock;

/**
 *  代理
 */
@property (nonatomic, assign)id<ABCNetOperationProtocol>delegate;

/**
 *  初始化方法
 *
 *  @param url    请求地址
 *  @param model  请求对象
 *  @param method 请求方式
 *
 *  @return 实例对象
 */
- (instancetype)initWithUrl:(NSString *)url Model:(ABCRequestModel *)model OperationMethod:(OperationMethod)method;

/**
 *  开始请求
 */
- (void)startOperation;

@end
