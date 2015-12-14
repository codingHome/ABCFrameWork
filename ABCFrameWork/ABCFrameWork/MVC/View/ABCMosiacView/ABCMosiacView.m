//
//  ABCMosiacView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCMosiacView.h"
#import "ABCMosiacDataArray.h"
#import "MJRefresh.h"

@interface ABCMosiacView () <ABCMosiacDataViewDelegate>

@property (nonatomic, assign) NSInteger maxElementsX;

@property (nonatomic, assign) NSInteger maxElementsY;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ABCMosiacDataArray *elements;

@end

@implementation ABCMosiacView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

#pragma mark - Private Method
- (void)setUp {
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    _scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    [self addSubview:_scrollView];
}

- (void)headerRefresh {
    if (_delegate && [_delegate respondsToSelector:@selector(mosaicViewHeaderRefresh:)]) {
        [_delegate mosaicViewHeaderRefresh:self];
    }
}

- (void)footerRefresh {
    if (_delegate && [_delegate respondsToSelector:@selector(mosaicViewFooterRefresh:)]) {
        [_delegate mosaicViewFooterRefresh:self];
    }
}

- (void)refresh{
    NSArray *mosaicElements = [self.dataSource mosaicElements];
    [self setupLayoutWithMosaicElements:mosaicElements];
}

- (void)setupLayoutWithMosaicElements:(NSArray *)mosaicElements{
    NSInteger yOffset = 0;
    
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    NSInteger scrollHeight = 0;
    
    self.scrollView.frame = [self bounds];
    
    for (UIView *subView in self.scrollView.subviews){
        [subView removeFromSuperview];
    }
    
    // Initial setup for the view
    NSUInteger maxElementsX = [self maxElementsX];
    NSUInteger maxElementsY = [self maxElementsY];
    self.elements = [[ABCMosiacDataArray alloc] initWithColumns:maxElementsX andRows:maxElementsY];
    
    CGPoint modulePoint = CGPointZero;
    
    ABCMosiacDataView *lastModuleView = nil;
    
    //  Set modules in scrollView
    for (ABCMosiacDataModel *aModule in mosaicElements){
        CGSize aSize = [self sizeForModuleSize:aModule.imageSize];
        NSArray *coordArray = [self coordArrayForCGSize:aSize];
        
        if (coordArray){
            NSInteger xIndex = [coordArray[0] integerValue];
            NSInteger yIndex = [coordArray[1] integerValue];
            
            modulePoint = CGPointMake(xIndex, yIndex);
            
            [self setModule:aModule withCGSize:aSize withCoord:modulePoint];
            
            CGRect mosaicModuleRect = CGRectMake(xIndex * 80,
                                                 yIndex * 80 + yOffset,
                                                 aSize.width * 80,
                                                 aSize.height * 80);
            
            lastModuleView = [[ABCMosiacDataView alloc] initWithFrame:mosaicModuleRect];
            lastModuleView.dataModel = aModule;
            lastModuleView.delegate = self;
            
            [self.scrollView addSubview:lastModuleView];
            
            scrollHeight = MAX(scrollHeight, lastModuleView.frame.origin.y + lastModuleView.frame.size.height);
        }
    }
    
    //  Setup content size
    CGSize contentSize = CGSizeMake(self.scrollView.frame.size.width,scrollHeight);
    self.scrollView.contentSize = contentSize;
}

- (CGSize)sizeForModuleSize:(NSUInteger)aSize{
    CGSize retVal = CGSizeZero;
    
    switch (aSize) {
            
        case 0:
            retVal = CGSizeMake(4, 4);
            break;
        case 1:
            retVal = CGSizeMake(2, 2);
            break;
        case 2:
            retVal = CGSizeMake(2, 1);
            break;
        case 3:
            retVal = CGSizeMake(1, 1);
            break;
            
        default:
            break;
    }
    
    return retVal;
}

- (NSArray *)coordArrayForCGSize:(CGSize)aSize{
    NSArray *retVal = nil;
    BOOL hasFound = NO;
    
    NSInteger i=0;
    NSInteger j=0;
    
    while (j < [self maxElementsY] && !hasFound){
        
        i = 0;
        
        while (i < [self maxElementsX] && !hasFound){
            
            BOOL fitsInCoord = [self doesModuleWithCGSize:aSize fitsInCoord:CGPointMake(i, j)];
            if (fitsInCoord){
                hasFound = YES;
                
                NSNumber *xIndex = [NSNumber numberWithInteger:i];
                NSNumber *yIndex = [NSNumber numberWithInteger:j];
                retVal = @[xIndex, yIndex];
            }
            
            i++;
        }
        
        j++;
    }
    
    return retVal;
}

- (BOOL)doesModuleWithCGSize:(CGSize)aSize fitsInCoord:(CGPoint)aPoint{
    BOOL retVal = YES;
    
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (retVal && yOffset < aSize.height){
        xOffset = 0;
        
        while (retVal && xOffset < aSize.width){
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            //  Check if the coords are valid in the bidimensional array
            if (xIndex < [self maxElementsX] && yIndex < [self maxElementsY]){
                
                id anObject = [self.elements objectAtColumn:xIndex andRow:yIndex];
                if (anObject != nil){
                    retVal = NO;
                }
                
                xOffset++;
            }else{
                retVal = NO;
            }
        }
        
        yOffset++;
    }
    
    return retVal;
}

- (void)setModule:(ABCMosiacDataModel *)aModule withCGSize:(CGSize)aSize withCoord:(CGPoint)aPoint{
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (yOffset < aSize.height){
        xOffset = 0;
        
        while (xOffset < aSize.width){
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            [self.elements setObject:aModule atColumn:xIndex andRow:yIndex];
            
            xOffset++;
        }
        
        yOffset++;
    }
}

- (NSInteger)maxElementsX{
    NSInteger retVal = _maxElementsX;
    
    if (retVal == -1){
        retVal = self.frame.size.width / 80;
    }
    
    return retVal;
}

- (NSInteger)maxElementsY{
    NSInteger retVal = _maxElementsY;
    
    if (retVal == -1){
        retVal = self.frame.size.height / 80 * [self maxScrollPages];
    }
    
    return retVal;
}

- (NSInteger)maxScrollPages{
    NSInteger retVal = 4;
    return retVal;
}

- (void)layoutSubviews{
    [self refresh];
    [super layoutSubviews];
}

#pragma mark - ABCMosiacDataViewDelegate
- (void)didTapDataView:(ABCMosiacDataView *)dataView {
    if (_delegate && [_delegate respondsToSelector:@selector(mosaicViewDidTap:)]) {
        [_delegate mosaicViewDidTap:dataView];
    }
}

@end
