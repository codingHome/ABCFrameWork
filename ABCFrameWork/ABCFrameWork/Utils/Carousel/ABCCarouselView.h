//
//  ABCCarouselView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/14.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABCCarouselView;

@protocol ABCCarouselViewDelegate <NSObject>

- (void)carouselView:(ABCCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;

@end

@interface ABCCarouselView : UIView

/**
 *  初始化类方法
 *
 *  @param frame  frame
 *  @param images 图片名数组
 */
+ (instancetype)carouselViewWithFrame:(CGRect)frame Images:(NSArray *)images;

@property (nonatomic, weak) id<ABCCarouselViewDelegate> delegate;

@end
