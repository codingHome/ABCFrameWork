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
#import "ABCCacheModel.h"

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
    ABCCacheModel *cacheModel = [[ABCCacheModel alloc] init];
    cacheModel.md5_name = [[self.requestModel operationURL] MD5];
    cacheModel.responseTime = [NSString formatCurDate];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];
    cacheModel.responseContent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [cacheModel insert];
}

- (void)getLocalCache {
    NSString *md5 = [[self.requestModel operationURL] MD5];
    
    NSString *currentTime = [NSString formatCurDate];
    NSDate *curdate = [NSDate formatDate:currentTime];
    
    ABCCacheModel* model = [ABCCacheModel queryWithMd5:md5];
    
    NSDate *responseDate = [NSDate formatDate:model.responseTime];
    long differencetime = fabs([curdate timeIntervalSinceDate:responseDate]);
    
    if (differencetime > model.intervalTime) {
        return;
    }else {
        NSError *error = nil;
        NSData *jsonData = [model.responseContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
        [self callBackResult:dic Error:error];
    }
}

@end
