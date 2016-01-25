//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "ABCNetOperation.h"
#import "ABCDB.h"

@interface ABCNetOperation ()

@property (nonatomic, copy) CallBack callBack;

@end

@implementation ABCNetOperation

+ (void)operationWithCallBack:(CallBack)callBack {
    ABCNetOperation *operation = [[[self class] alloc] init];
    operation.callBack = callBack;
    [operation startOperation];
}

- (void)startOperation {
    AFNetworkReachabilityManager * reachAbilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachAbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self operationMethod];
                break;
        }
    }];
    [reachAbilityManager startMonitoring];
}

- (NSDictionary *)requestCahe {
    return [self getCache];
}

#pragma mark -Private Method
- (void)operationMethod {
    switch ([self method]) {
        case ABCNetOperationGetMethod:
            [self getRequest];
            break;
        case ABCNetOperationPostMethod:
            [self postRequest];
            break;
        case ABCNetOperationPostDataMethod:
            [self postDataRequest];
            break;
    }
}
- (void)getRequest {
    [[ABCNetRequest sharedNetRequest] GetUrl:[self URL] RequestPara:[self requestPara] RequestSuccess:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    } RequestFail:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    }];
}

- (void)postRequest {
    [[ABCNetRequest sharedNetRequest] PostUrl:[self URL] RequestPara:[self requestPara] RequestSuccess:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    } RequestFail:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    }];
}

- (void)postDataRequest {
    [[ABCNetRequest sharedNetRequest] PostUrl:[self URL] RequestPara:[self requestPara] Body:^(id<AFMultipartFormData> formData) {
        if (_bodyBlock) {
            _bodyBlock(formData);
        }
    } RequestSuccess:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    } RequestFail:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    }];
}

- (void)callBackResult:(id)result Error:(NSError *)error {
    
    if (_delegate) {
        if (result&&!error) {
            [_delegate netOperationSuccess:self result:result];
        }else if (error){
            [_delegate netOperationFail:self error:error];
        }
    }else if (_callBack) {
        _callBack(result, error);
    }
    
    //缓存
    [self cache:result];
}

#pragma mark - Cache Method

- (void)cache:(NSDictionary *)result {
    
}

- (NSDictionary *)getCache {
    return nil;
}

#pragma mark - rewrite method
// 请求URL
- (NSString *)URL {
    return nil;
}

// 请求参数
- (NSDictionary *)requestPara {
    return nil;
}

// 请求参数
- (ABCOperationMethod)method {
    return ABCNetOperationGetMethod;
}

// 超时时间
- (NSTimeInterval)timeoutInterval {
    return 10;
}

// 缓存时效
- (NSTimeInterval)cacheDeadLine {
    return 3600;
}

@end
