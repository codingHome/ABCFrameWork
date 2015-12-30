//
//  ABCRoundImageView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCRoundImageView : UIImageView

/**
 *  边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  边角角度
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

@end
