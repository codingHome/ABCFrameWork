//
//  UIImage+ImageProcessing.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/23.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageProcessing)

/**
 *	@brief	在固定的范围(不会拉伸图像,没有透明像素,生成的图像不一定是targetSize大小)
 *
 *	@param 	targetSize 	画布大小
 */
- (UIImage *)imageByScalingToMinSize:(CGSize)targetSize;

/**
 *	@brief	在固定的范围(不会拉伸图像,自动等比例缩放,生成targetSize大小的图像)
 *
 *	@param 	targetSize 	画布大小
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

/**
 *	@brief	在固定的范围
 *
 *	@param 	targetSize      画布大小
 *	@param 	contentSize 	图像内容大小
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize contentSize:(CGSize)contentSize;

/**
 *	@brief	不等比例压缩(会拉伸)
 *
 *	@param 	targetSize 	画布大小
 */
- (UIImage *)imageByNotEquleToSize:(CGSize)targetSize;

/**
 *  截取图片的中间部分显示
 *
 *  @param size 显示区域大小
 *
 *  @return  截取后的图片
 */
- (UIImage*)scaleImageCenterSize:(CGSize )size;

@end
