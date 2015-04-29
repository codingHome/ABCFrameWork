//
//  ABCImageView.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCImageView : UIImageView

/**
 *  加载图片
 *
 *  @param frame 图片位置
 *  @param image 图片url
 *
 *  @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)image;

/**
 *  加载图片（默认图片）
 *
 *  @param frame       图片位置
 *  @param image       图片url
 *  @param placeHolder 默认图片名称
 *
 *  @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)image placeHolderImage:(NSString *)placeHolder;

@end
