//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetOperation.h"
#import "ABCHub.h"
#import "ABCCallBackModel.h"

@interface ABCNetOperation ()

@property (nonatomic, strong) ABCRequestModel *requestModel;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) CallBack callBack;

@end

@implementation ABCNetOperation

- (instancetype)initWithUrl:(NSString *)url Model:(ABCRequestModel *)model OperationMethod:(OperationMethod)method {
    self = [super init];
    if (self) {
        _url = url;
        _requestModel = model;
        _method = method;
        _progressHUB = YES;
        _cache = YES;
    }
    return self;
}

+ (void)operationWithUrl:(NSString *)url Model:(ABCRequestModel *)model OperationMethod:(OperationMethod)method CallBack:(void(^)(id result, NSError *error))callBack {
    ABCNetOperation *operation = [[ABCNetOperation alloc] initWithUrl:url Model:model OperationMethod:method];
    operation.callBack = callBack;
    [operation startOperation];
}

- (void)startOperation {
    if (_progressHUB) {
        [ABCHub abc_show];
        switch (_method) {
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
}


- (void)getRequest {
    [[ABCNetRequest sharedNetRequest]GetUrl:_url
                               RequestModel:_requestModel
                             RequestSuccess:^(id result, NSError *error) {
                                 [self callBackResult:result Error:error];
                             }
                                RequestFail:^(id result, NSError *error) {
                                    [self callBackResult:result Error:error];
                                }];
}

- (void)postRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_url
                                RequestModel:_requestModel
                              RequestSuccess:^(id result, NSError *error) {
                                  [self callBackResult:result Error:error];
                              }
                                 RequestFail:^(id result, NSError *error) {
                                     [self callBackResult:result Error:error];
                                 }];
}

- (void)postDataRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_url RequestModel:_requestModel
                                        Body:^(id<AFMultipartFormData> formData) {
                                            if (_bodyBlock) {
                                                _bodyBlock(formData);
                                            }
                                        }
                              RequestSuccess:^(id result, NSError *error) {
                                  [self callBackResult:result Error:error];
                              }
                                 RequestFail:^(id result, NSError *error) {
                                     [self callBackResult:result Error:error];
                                 }];
}

- (void)callBackResult:(id)result Error:(NSError *)error {
    
    ABCCallBackModel *callBackModel = [self transformCallBackResult:result];
    
    [ABCHub dismiss];
    //delegate回调
    if (_delegate) {
        if (result&&!error) {
            [_delegate netOperationSuccess:self result:callBackModel];
        }else if (error){
            [_delegate netOperationFail:self error:error];
        }
    }else if (_callBack) {
        _callBack(result, error);
    }
}

- (ABCCallBackModel *)transformCallBackResult:(id)result {
    
    NSString *modelClassStr = [NSStringFromClass(self.requestModel.class) stringByReplacingOccurrencesOfString:@"RequestModel" withString:@"CallBackModel"];
    
    Class ModelClass = NSClassFromString(modelClassStr);
    
    ABCCallBackModel *callBackModel = nil;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        callBackModel = [[ModelClass alloc] initWithDictionary:result error:nil];
    }else if ([result isKindOfClass:[NSString class]]) {
        callBackModel = [[ModelClass alloc] initWithString:result error:nil];
    }
    
    if (self.cache) {
        [callBackModel insertTable];
    }
    return callBackModel;
}

@end
