//
//  TestRequestModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "TestRequestModel.h"

@implementation TestRequestModel

- (NSString *)URL {
    return @"http://web.juhe.cn:8080/environment/air/cityair?";
}

- (ABCOperationMethod)method {
    return ABCNetOperationGetMethod;
}

@end
