//
//  ABCNetRequest.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetRequest.h"

@implementation ABCNetRequest

+ (ABCNetRequest *)sharedNetRequest {
    static dispatch_once_t onceToken;
    static ABCNetRequest *sharedNetRequest;
    dispatch_once(&onceToken, ^{
        sharedNetRequest = [self new];
    });
    return sharedNetRequest;
}

- (void)GetUrl:(NSString *)url
  RequestModel:(ABCRequestModel *)model
RequestSuccess:(RequestSuccessBlock)successCallBack
   RequestFail:(RequestFailBlock)failCallBack {
    
    NSDictionary *params = [model instancePropertiesList];
    
    [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
   RequestModel:(ABCRequestModel *)model
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    NSDictionary *params = [model instancePropertiesList];
    
    [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
   RequestModel:(ABCRequestModel *)model
           Body:(RequestBodyBlock)bodyBlock
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    NSDictionary *params = [model instancePropertiesList];
    
    [self POST:url parameters:params constructingBodyWithBlock:bodyBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(nil,error);
    }];
}

@end
