//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetOperation.h"
#import "ABCHub.h"

@interface ABCNetOperation ()

@property (nonatomic, strong) ABCRequestModel *requestModel;
@property (nonatomic, copy) CallBack callBack;

@end

@implementation ABCNetOperation

- (instancetype)initWithModel:(ABCRequestModel *)model {
    self = [super init];
    if (self) {
        _requestModel = model;
    }
    return self;
}

+ (void)operationWithModel:(ABCRequestModel *)model CallBack:(CallBack)callBack {
    ABCNetOperation *operation = [[ABCNetOperation alloc] initWithModel:model];
    operation.callBack = callBack;
    [operation startOperation];
}

- (void)startOperation {
    switch (_requestModel.method) {
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
    [[ABCNetRequest sharedNetRequest]GetUrl:_requestModel.URL
                               RequestModel:_requestModel
                             RequestSuccess:^(id result, NSError *error) {
                                 [self callBackResult:result Error:error];
                             }
                                RequestFail:^(id result, NSError *error) {
                                    [self callBackResult:result Error:error];
                                }];
}

- (void)postRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_requestModel.URL
                                RequestModel:_requestModel
                              RequestSuccess:^(id result, NSError *error) {
                                  [self callBackResult:result Error:error];
                              }
                                 RequestFail:^(id result, NSError *error) {
                                     [self callBackResult:result Error:error];
                                 }];
}

- (void)postDataRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_requestModel.URL
                                RequestModel:_requestModel
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
    
    //delegate回调
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

@end
