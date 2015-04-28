//
//  ABCImageLoader.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCImageLoader : UIImageView

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString *)url placeHolder:(NSString *)placeHolder tintColor:(UIColor *)color;

@end
