//
//  ABCDBModelSpec.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/25.
//  Copyright 2016年 Robert. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "ABCDBModel.h"

// http://onevcat.com/2014/02/ios-test-with-kiwi/

SPEC_BEGIN(ABCDBModelSpec)

describe(@"ABCDBModel", ^{
    context(@"When Create", ^{
        __block ABCDBModel *dbModel = nil;
        beforeAll(^{
            dbModel = [[ABCDBModel alloc] init];
        });
        
        afterAll(^{
            dbModel = nil;
        });
        
        it(@"should have the class ABCDBModel", ^{
            [[[ABCDBModel class] shouldNot] beNil];
        });
        
        it(@"should exist", ^{
            [[dbModel shouldNot] beNil];
        });
        
        it(@"should have property abc_id", ^{
            [[theValue(dbModel.abc_id) should] equal:theValue(0)];
        });
    });
});

SPEC_END
