//
//  ABCRoundImageView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCRoundImageView.h"

@implementation ABCRoundImageView

+ (ABCRoundImageView *)roundImageViewWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original {
    ABCRoundImageView *imageView = [[ABCRoundImageView alloc] initWithImage:original];
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];

    [original drawInRect:imageView.bounds];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageView;
}

+ (ABCRoundImageView *)roundImageViewWithImage:(UIImage *)original {
    ABCRoundImageView *imageView = [[ABCRoundImageView alloc] initWithImage:original];
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    CGFloat cornerRadius = imageView.bounds.size.width>imageView.bounds.size.height?imageView.bounds.size.height:imageView.bounds.size.width;
    
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius/2] addClip];
    
    [original drawInRect:imageView.bounds];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageView;
}

@end
