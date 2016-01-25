//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "ABCNetOperation.h"
#import "ABCReachability.h"
#import "ABCDB.h"

@interface ABCNetOperation ()

@property (nonatomic, copy) CallBack callBack;

@end

@implementation ABCNetOperation

+ (void)operationWithCallBack:(CallBack)callBack {
    ABCNetOperation *operation = [[ABCNetOperation alloc] init];
    operation.callBack = callBack;
    [operation startOperation];
}

- (void)startOperation {
    ABCReachability *reachability = [ABCReachability reachabilityWithHostName:@"www.baidu.com"];
    ABCNetStatus status = [reachability currentReachabilityStatus];
    
    switch (status) {
        case ABCNetStatusNone:
            [self getLocalCache];
            break;

        case ABCNetStatusWwan:
        case ABCNetStatusWifi:
            [self operationMethod];
            break;
    }
}

#pragma mark -Private Method
- (void)operationMethod {
    switch (self.method) {
        case ABCNetOperationGetMethod:
            
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
    [[ABCNetRequest sharedNetRequest] GetUrl:self.URL RequestPara:self.requestPara RequestSuccess:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    } RequestFail:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    }];
}

- (void)postRequest {
    [[ABCNetRequest sharedNetRequest] PostUrl:self.URL RequestPara:self.requestPara RequestSuccess:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    } RequestFail:^(id result, NSError *error) {
        [self callBackResult:result Error:error];
    }];
}

- (void)postDataRequest {
    [[ABCNetRequest sharedNetRequest] PostUrl:self.URL RequestPara:self.requestPara Body:^(id<AFMultipartFormData> formData) {
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
    
    //缓存
    [self localCache:result];
    
    if (_delegate) {
        if (result&&!error) {
            [_delegate netOperationSuccess:self result:result];
        }else if (error){
            [_delegate netOperationFail:self error:error];
        }
    }else if (_callBack) {
        _callBack(result, error);
    }
}

#pragma mark - DB Method

- (void)localCache:(NSDictionary *)result {
    
}

- (void)getLocalCache {

}

@end
