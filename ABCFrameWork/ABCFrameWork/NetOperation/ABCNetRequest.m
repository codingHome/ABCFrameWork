//
//  ABCNetRequest.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "ABCNetRequest.h"

static const CGFloat KTimeoutInterval = 20;

@implementation ABCNetRequest

+ (ABCNetRequest *)sharedNetRequest {
    static dispatch_once_t onceToken;
    static ABCNetRequest *sharedNetRequest;
    dispatch_once(&onceToken, ^{
        sharedNetRequest = [[self alloc] init];
        sharedNetRequest.requestSerializer.timeoutInterval = KTimeoutInterval;
    });
    return sharedNetRequest;
}

- (void)GetUrl:(NSString *)url
   RequestPara:(NSDictionary *)para
RequestSuccess:(RequestSuccessBlock)successCallBack
   RequestFail:(RequestFailBlock)failCallBack {
    
    [self GET:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
    RequestPara:(NSDictionary *)para
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    [self POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
    RequestPara:(NSDictionary *)para
           Body:(RequestBodyBlock)bodyBlock
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    [self POST:url parameters:para constructingBodyWithBlock:bodyBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

@end
