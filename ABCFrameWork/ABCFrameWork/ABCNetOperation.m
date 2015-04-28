//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetOperation.h"
#import "ABCCache.h"
#import "SVProgressHUD.h"

@interface ABCNetOperation ()

@property (nonatomic, strong)ABCRequestModel *model;
@property (nonatomic, strong)NSString *url;

@end

@implementation ABCNetOperation

- (instancetype)initWithUrl:(NSString *)url Model:(ABCRequestModel *)model OperationMethod:(OperationMethod)method {
    self = [super init];
    if (self) {
        _url = url;
        _model = model;
        _method = method;
    }
    return self;
}

- (void)setProgressHUB:(BOOL)progressHUB {
    _progressHUB = progressHUB;
    if (_progressHUB) {
        [SVProgressHUD show];
    }
}

- (void)startOperation {
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

- (void)getRequest {
    [[ABCNetRequest sharedNetRequest]GetUrl:_url
                               RequestModel:_model
                             RequestSuccess:^(id result, NSError *error) {
                                 [self callBackResult:result Error:error];
                             }
                                RequestFail:^(id result, NSError *error) {
                                    [self callBackResult:result Error:error];
                                }];
}

- (void)postRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_url
                                RequestModel:_model
                              RequestSuccess:^(id result, NSError *error) {
                                  [self callBackResult:result Error:error];
                              }
                                 RequestFail:^(id result, NSError *error) {
                                     [self callBackResult:result Error:error];
                                 }];
}

- (void)postDataRequest {
    [[ABCNetRequest sharedNetRequest]PostUrl:_url RequestModel:_model
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
    //缓存
    if (_cache) {
        [[ABCCache sharedCache]putIntoTableWithObject:result];
    }
    [SVProgressHUD dismiss];
    //delegate回调
    if (result&&!error) {
        [_delegate netOperationSuccess:result];
    }else if (error){
        [_delegate netOperationFail:error];
    }
}

@end
