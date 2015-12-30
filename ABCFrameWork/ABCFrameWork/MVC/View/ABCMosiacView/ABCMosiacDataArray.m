//
//  ABCMosiacDataArray.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCMosiacDataArray.h"

#define INVALID_ELEMENT_INDEX -1

@interface ABCMosiacDataArray ()

/**
 *  元素集合
 */
@property (nonatomic, strong) NSMutableArray *elements;

/**
 *  行
 */
@property (nonatomic, assign) NSUInteger rows;

/**
 *  列
 */
@property (nonatomic, assign) NSUInteger columns;

@end

@implementation ABCMosiacDataArray

-(NSInteger)elementIndexWithColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    NSInteger retVal = 0;
    if (xIndex >= _columns || yIndex >= _rows){
        retVal = INVALID_ELEMENT_INDEX;
    }else{
        retVal = xIndex + (yIndex * self.columns);
    }
    return retVal;
}

#pragma mark - Public

-(id)initWithColumns:(NSUInteger)numberOfColumns andRows:(NSUInteger)numberOfRows{
    self = [super init];
    if (self){
        NSUInteger capacity = numberOfColumns * numberOfRows;
        _columns = numberOfColumns;
        _rows = numberOfRows;
        _elements = [[NSMutableArray alloc] initWithCapacity:capacity];
        for(NSInteger i=0; i<capacity; i++){
            [_elements addObject:[NSNull null]];
        }
    }
    return self;
}

-(id)objectAtColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    id retVal = nil;
    
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];
    
    if (elementIndex != INVALID_ELEMENT_INDEX){
        
        if ([_elements objectAtIndex:elementIndex] != [NSNull null]){
            retVal = [_elements objectAtIndex:elementIndex];
        }
    }
    
    return retVal;
}

-(void)setObject:(id)anObject atColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];
    
    [_elements replaceObjectAtIndex:elementIndex withObject:anObject];
}

@end
