//
//  ABCNetRequest.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetRequest.h"

@implementation ABCNetRequest

+ (instancetype)sharedNetRequest {
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
    [self GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
   RequestModel:(ABCRequestModel *)model
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    NSDictionary *params = [model instancePropertiesList];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallBack(nil,error);
    }];
}

- (void)PostUrl:(NSString *)url
   RequestModel:(ABCRequestModel *)model
           Body:(RequestBodyBlock)bodyBlock
 RequestSuccess:(RequestSuccessBlock)successCallBack
    RequestFail:(RequestFailBlock)failCallBack {
    
    NSDictionary *params = [model instancePropertiesList];
    [self POST:url parameters:params constructingBodyWithBlock:bodyBlock
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallBack(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallBack(nil,error);
    }];
}

@end
