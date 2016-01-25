//
//  TestNetOperation.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/25.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "TestNetOperation.h"

@implementation TestNetOperation

- (NSString *)URL {
    return @"http://localhost:12306/assetApp/login";
}

- (NSDictionary *)requestPara {
    NSDictionary *dic = @{@"username":@"atbj505",
                          @"password":@"123456"
                          };
    return dic;
}

- (ABCOperationMethod)method {
    return ABCNetOperationGetMethod;
}

@end
