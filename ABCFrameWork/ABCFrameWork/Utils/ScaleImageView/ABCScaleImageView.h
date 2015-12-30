//
//  ABCScaleImageView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/23.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCScaleImageView : UIView

/**
 *  当前显示图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  重置放大倍数
 */
- (void)restScale;

@end
