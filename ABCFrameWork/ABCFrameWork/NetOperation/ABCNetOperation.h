//
//  ABCNetOperation.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCNetRequest.h"

typedef void(^CallBack)(NSDictionary* result, NSError *error);

typedef NS_ENUM(NSUInteger, ABCOperationMethod){
    ABCNetOperationGetMethod = 1,
    ABCNetOperationPostMethod,
    ABCNetOperationPostDataMethod
};

@class ABCNetOperation;

@protocol  ABCNetOperationProtocol <NSObject>

@required

- (void)netOperationStarted:(ABCNetOperation*)operation;
- (void)netOperationSuccess:(ABCNetOperation*)operation result:(id)result;
- (void)netOperationFail:(ABCNetOperation*)operation error:(NSError*)error;

@end

@interface ABCNetOperation : NSObject

/**
 *  请求体
 */
@property (nonatomic, strong)RequestBodyBlock bodyBlock;

/**
 *  代理
 */
@property (nonatomic, assign)id<ABCNetOperationProtocol>delegate;

// 请求URL
- (NSString *)URL;

// 请求参数
- (NSDictionary *)requestPara;

// 请求参数
- (ABCOperationMethod)method;

// 超时时间
- (NSTimeInterval)timeoutInterval;

// 缓存时效
- (NSTimeInterval)cacheDeadLine;

/**
 *  开始请求
 */
- (void)startOperation;

/**
 *  block回调方法
 *
 *  @param callBack 请求回调
 */
+ (void)operationWithCallBack:(CallBack)callBack;

/**
 *  请求缓存
 *
 *  @return 请求response
 */
- (NSDictionary *)requestCahe;

@end
