//
//  ABCNetRequest.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^RequestSuccessBlock)(id result, NSError *error);
typedef void (^RequestFailBlock)(id result, NSError *error);
typedef void (^RequestBodyBlock) (id<AFMultipartFormData> formData);

@interface ABCNetRequest : AFHTTPSessionManager

/**
 *  单例方法
 *
 *  @return 网络请求对象
 */
+ (ABCNetRequest *)sharedNetRequest;

/**
 *  GET请求
 *
 *  @param url             请求URL
 *  @param para            请求参数
 *  @param successCallBack 请求成功回掉
 *  @param failCallBack    请求失败回掉
 */
- (void)GetUrl:(NSString *)url
   RequestPara:(NSDictionary *)para
RequestSuccess:(RequestSuccessBlock)successCallBack
   RequestFail:(RequestFailBlock)failCallBack;

/**
 *  POST请求
 *
 *  @param url             请求URL
 *  @param para            请求参数
 *  @param successCallBack 请求成功回掉
 *  @param failCallBack    请求失败回掉
 */
- (void)PostUrl:(NSString *)url
    RequestPara:(NSDictionary *)para
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack;

/**
 *  POST请求（上传数据）
 *
 *  @param url             请求URL
 *  @param para            请求参数
 *  @param bodyBlock       请求体数据
 *  @param successCallBack 请求成功回掉
 *  @param failCallBack    请求失败回掉
 */
- (void)PostUrl:(NSString *)url
    RequestPara:(NSDictionary *)para
           Body:(RequestBodyBlock)bodyBlock
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack;

@end
