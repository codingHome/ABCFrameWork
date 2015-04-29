//
//  ABCImageLoader.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCImageLoader : UIImageView

/**
 *  初始化方法
 *
 *  @param frame       位置&大小
 *  @param url         图片URL
 *  @param placeHolder 默认图片名称
 *  @param color       进度条颜色
 *
 *  @return 实例变量
 */
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString *)url placeHolder:(NSString *)placeHolder tintColor:(UIColor *)color;

@end
