//
//  ABCMosiacDataArray.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCMosiacDataArray : NSArray

/**
 *  初始化行列
 *
 *  @param numberOfColumns 列
 *  @param numberOfRows    排
 *
 *  @return 实例变量
 */
-(id)initWithColumns:(NSUInteger)numberOfColumns andRows:(NSUInteger)numberOfRows;

/**
 *  获取指定行列下的元素
 *
 *  @param xIndex 列
 *  @param yIndex 行
 *
 *  @return 指定元素
 */
-(id)objectAtColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex;

/**
 *  设定指定行列下的元素
 *
 *  @param anObject 元素
 *  @param xIndex   列
 *  @param yIndex   行
 */
-(void)setObject:(id)anObject atColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex;

@end
