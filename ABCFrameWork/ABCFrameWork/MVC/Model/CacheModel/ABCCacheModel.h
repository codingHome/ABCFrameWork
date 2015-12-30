//
//  ABCCacheModel.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/25.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCDBModel.h"

@interface ABCCacheModel : ABCDBModel

@property (nonatomic, copy) NSString *md5_name;

@property (nonatomic, copy) NSString *responseTime;

@property (nonatomic, assign) NSInteger intervalTime;

@property (nonatomic, copy) NSString *responseContent;

- (void)insert;

+ (ABCCacheModel *)queryWithMd5:(NSString *)md5;

@end
