//
//  ABCRoundImageView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCRoundImageView : UIImageView

+ (ABCRoundImageView *)roundImageViewWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;

+ (ABCRoundImageView *)roundImageViewWithImage:(UIImage *)original;

@end
