//
//  ABCNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCNetOperation.h"
#import "SVProgressHUD.h"
#import "ABCCallBackModel.h"
#import "ABCNetObserver.h"

@interface ABCNetOperation ()

@property (nonatomic, strong)ABCRequestModel *requestModel;
@property (nonatomic, strong)NSString *url;

@end

@implementation ABCNetOperation

-(void)dealloc {
    [[ABCNetObserver sharedNetObserver] removeNotification:self];
}

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

- (void)startOperation {
    //获取网络状态
    [[ABCNetObserver sharedNetObserver] registNotification:self selector:@selector(getNetWorkStatus:)];
    [[ABCNetObserver sharedNetObserver] startNotifier];
}

- (void)getNetWorkStatus:(NSNotification *)notification {
    ABCNetObserver *observer = notification.object;
    if (observer.status == ABCNetStatusWifi || observer.status == ABCNetStatusWWAN) {
        [self startRequest];
    }else {
        [SVProgressHUD showWithStatus:@"网络异常"];
    }
}

- (void)startRequest {
    if (_progressHUB) {
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
    
    [SVProgressHUD dismiss];
    //delegate回调
    if (result&&!error) {
        [_delegate netOperationSuccess:callBackModel];
    }else if (error){
        [_delegate netOperationFail:error];
    }
}

- (ABCCallBackModel *)transformCallBackResult:(NSDictionary *)result {
    NSString *modelClassStr = [NSStringFromClass(self.requestModel.class) stringByReplacingOccurrencesOfString:@"RequestModel" withString:@"CallBackModel"];
    
    Class ModelClass = NSClassFromString(modelClassStr);
    
    ABCCallBackModel *callBackModel = [[ModelClass alloc] initWithDictionary:result error:nil];
    
    if (self.cache) {
        [callBackModel insertTable];
    }
    return callBackModel;
}

@end
