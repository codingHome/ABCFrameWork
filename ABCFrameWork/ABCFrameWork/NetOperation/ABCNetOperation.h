//
//  ABCNetOperation.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCNetRequest.h"

typedef void(^CallBack)(id result, NSError *error);

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

/**
 *  初始化方法
 *
 *  @param url    请求地址
 *  @param model  请求对象
 *
 *  @return 实例对象
 */
- (instancetype)initWithModel:(ABCRequestModel *)model;

/**
 *  开始请求
 */
- (void)startOperation;

/**
 *  block回调方法
 *
 *  @param url      请求地址
 *  @param model    请求对象
 *  @param method   请求方式
 *  @param callBack 请求回调
 */
+ (void)operationWithModel:(ABCRequestModel *)model CallBack:(CallBack)callBack;

@end
