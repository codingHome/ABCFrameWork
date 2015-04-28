//
//  ABCRequestModelTest.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABCRequestTestModel.h"

@interface ABCRequestModelTest : XCTestCase

@property (nonatomic, strong)ABCRequestTestModel *requestModel;

@end

@implementation ABCRequestModelTest

- (void)setUp {
    [super setUp];
    
    self.requestModel = [[ABCRequestTestModel alloc] init];
    self.requestModel.name = @"robert";
    self.requestModel.school = @"cug";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstancePropertiesList{
    NSDictionary *dic = [self.requestModel instancePropertiesList];
    XCTAssert(dic.count == 2, @"Pass");
}

- (void)testclassPropertyListt{
    NSArray *array = [self.requestModel classPropertyList];
    XCTAssert(array.count == 2, @"Pass");
}

- (void)testoperationURL{
    NSString *str = [self.requestModel operationURL];
    XCTAssert(str.length, @"Pass");
}

@end
