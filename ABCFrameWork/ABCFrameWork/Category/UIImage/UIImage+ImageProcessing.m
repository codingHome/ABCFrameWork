//
//  UIImage+ImageProcessing.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/23.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "UIImage+ImageProcessing.h"

@implementation UIImage (ImageProcessing)

- (UIImage *)imageByScalingToMinSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointMake(0, 0);
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        DDLogDebug(@"imageByScalingToMixSize could not scale image");
    return newImage ;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        DDLogDebug(@"could not scale image");
    return newImage ;
}

//---------
// targetSize: 画布大小
// contentSize: 内容大小
//---------
- (UIImage *)imageByScalingToSize:(CGSize)targetSize contentSize:(CGSize)contentSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = contentSize.width;
    CGFloat targetHeight = contentSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, contentSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(targetSize);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointMake(targetSize.width/2 - scaledWidth/2, targetSize.height/2 - scaledHeight/2);
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        DDLogDebug(@"could not scale image");
    return newImage ;
}

//---------
// 不等比例压缩
// targetSize:
//---------
- (UIImage *)imageByNotEquleToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(targetSize);
    
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        DDLogDebug(@"could not scale image");
    return newImage ;
}


- (UIImage*)scaleImageCenterSize:(CGSize )size
{
    
    UIImage *image = self;
    CGSize imgSize = image.size; //原图大小
    CGSize viewSize = size;          //视图大小
    CGFloat imgwidth = 0;            //缩放后的图片宽度
    CGFloat imgheight = 0;          //缩放后的图片高度
    
    //视图横长方形及正方形
    if (viewSize.width >= viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgwidth = viewSize.width;
            imgheight = imgSize.height/(imgSize.width/imgwidth);
        }
        //放大
        if(imgSize.width < viewSize.width){
            imgwidth = viewSize.width;
            imgheight = (viewSize.width/imgSize.width)*imgSize.height;
        }
        //判断缩放后的高度是否小于视图高度
        imgheight = imgheight < viewSize.height?viewSize.height:imgheight;
    }
    
    //视图竖长方形
    if (viewSize.width < viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgheight = viewSize.height;
            imgwidth = imgSize.width/(imgSize.height/imgheight);
        }
        
        //放大
        if(imgSize.height < viewSize.height){
            imgheight = viewSize.width;
            imgwidth = (viewSize.height/imgSize.height)*imgSize.width;
        }
        //判断缩放后的高度是否小于视图高度
        imgwidth = imgwidth < viewSize.width?viewSize.width:imgwidth;
    }
    
    //重新绘制图片大小
    UIImage *i;
    UIGraphicsBeginImageContext(CGSizeMake(imgwidth, imgheight));
    [image drawInRect:CGRectMake(0, 0, imgwidth, imgheight)];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取中间部分图片显示
    if (imgwidth > 0) {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(i.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }else{
        CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(fabsf(imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }
}

@end
