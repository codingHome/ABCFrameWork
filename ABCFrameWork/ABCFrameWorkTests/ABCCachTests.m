//
//  ABCCachTests.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABCCache.h"

@interface ABCCachTests : XCTestCase

@property (nonatomic, strong)NSDictionary *jsonString;

@end

@implementation ABCCachTests

- (void)setUp {
    [super setUp];
    self.jsonString = @{
                        @"text" : @"Agree!Nice weather!",
                        @"user" : @{
                                @"name" : @"Jack",
                                @"icon" : @"lufy.png"
                                },
                        @"retweetedStatus" : @{
                                @"text" : @"Nice weather!",
                                @"user" : @{
                                        @"name" : @"Rose",
                                        @"icon" : @"nami.png"
                                        }
                                }
                        };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPut {
    [[ABCCache sharedCache]putIntoTableWithObject:self.jsonString];
}

- (void)testGet {
    NSString *tableName = [NSString stringWithCString:object_getClassName(self.jsonString) encoding:NSUTF8StringEncoding];
    id result = [[ABCCache sharedCache]getFormTableWithTableName:tableName];
    NSLog(@"%@",result);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
