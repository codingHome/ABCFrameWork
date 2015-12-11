//
//  ABCCallBackModelTest.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestModel.h"
#import "ABCDataBase.h"

@interface ABCCallBackModelTest : XCTestCase

@property (nonatomic, strong) TestModel *testModel;

@end

@implementation ABCCallBackModelTest

- (void)setUp {
    [super setUp];
    NSLog(@"%@",NSHomeDirectory());
    NSDictionary *params = @{
                             @"uid"           : @(1),
                             @"q_char"        : @"c",
                             @"q_short"       : @(1),
                             @"q_int"         : @(2),
                             @"q_long"        : @(3),
                             @"q_long_long"   : @(4),
                             @"q_float"       : @(5.555),
                             @"q_double"      : @(6.666),
                             @"q_string"      : @"string",
                             @"q_number"      : @(7),
                             @"q_array"       : @[@"1",@"2"],
                             @"q_m_array"     : [@[@"1",@"2"] mutableCopy],
                             @"q_dictionary"  : @{@"1":@"2"},
                             @"q_m_dictionary": [@{@"1":@"2"} mutableCopy],
                             };
    self.testModel = [[TestModel alloc] initWithDictionary:params error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLog
{
    NSLog(@"%@",self.testModel);
}

- (void)testInsert
{
    BOOL hasInsert = [self.testModel insertTable];
    NSLog(@"插入结果: %d", hasInsert);
}

- (void)testDelete
{
    BOOL hasDelete = [[[self.testModel selectFromTable] lastObject] deleteFromTable];
    NSLog(@"删除结果: %d", hasDelete);
}

- (void)testUpdate
{
    self.testModel = [[self.testModel selectFromTable] lastObject];
    
    self.testModel.q_char = 10;
    self.testModel.q_short = 10;
    self.testModel.q_int = 10;
    self.testModel.q_long = 10;
    self.testModel.q_long_long = 10;
    self.testModel.q_float = 10.10;
    self.testModel.q_float = 10.10;
    
    self.testModel.q_number = @(10);
    self.testModel.q_string = @"Update";
    self.testModel.q_array = @[@"Update"];
    self.testModel.q_m_array = [@[@"Update"] mutableCopy];
    self.testModel.q_dictionary = @{@"Update":@"Update"};
    self.testModel.q_m_dictionary = [@{@"Update":@"Update"} mutableCopy];
    
    [self.testModel updateTable];
}

- (void)testSelect
{
    NSArray *selectArr = [self.testModel selectByConditions:@"uid=1"
                                                       args:nil
                                                 pageNumber:1
                                                   pageSize:1
                                                      order:nil];
    NSLog(@"%ld", (unsigned long)selectArr.count);
}

- (void)testDrop
{
    BOOL hasDrop = [self.testModel dropTable];
    NSLog(@"是否移除表: %d", hasDrop);
}

@end
