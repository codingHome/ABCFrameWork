//
//  UIButton+ArrayButton.h
//  RYSearch
//
//  Created by Robert on 15/4/24.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ArrayButton)

/**
 *  批量生成Button
 *
 *  @param array NSString类型的数组
 *  @param gap   Button之间的间距
 *
 *  @return Button数组
 */
+ (NSArray *)ButtonWithArray:(NSArray *)array Gap:(NSUInteger)gap;

@end
