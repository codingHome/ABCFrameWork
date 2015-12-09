//
//  TestViewController.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "TestViewController.h"
#import "TestRequestModel.h"

@implementation TestViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}


- (void)test {
    TestRequestModel *testModel = [[TestRequestModel alloc] init];
    testModel.city = @"beijing";
    testModel.key = @"ec1c681fdacfcc3d4dfc530981b86a82";
    
//    ABCNetOperation *testOperation = [[ABCNetOperation alloc] initWithUrl:@"http://web.juhe.cn:8080/environment/air/cityair?" Model:testModel OperationMethod:ABCNetOperationGetMethod];
//    testOperation.delegate = self;
//    [testOperation startOperation];
    ABCNetOperation *testOperation = [[ABCNetOperation alloc] init];
    [testOperation operationWithUrl:@"http://web.juhe.cn:8080/environment/air/cityair?" Model:testModel OperationMethod:ABCNetOperationGetMethod CallBack:^(id result, NSError *error) {
        
    }];
}

- (void)netOperationStarted:(ABCNetOperation*)operation {
    
}
- (void)netOperationSuccess:(ABCNetOperation*)operation result:(id)result {
    
}
- (void)netOperationFail:(ABCNetOperation*)operation error:(NSError*)error {
    
}
@end
