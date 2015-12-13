//
//  ABCMosiacDataModel.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCMosiacDataModel : NSObject

/**
 *  图片URL
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  图片大小 0->3
 */
@property (nonatomic, assign) NSUInteger imageSize;

/**
 *  初始化方法
 *
 *  @param dict 字典
 *
 *  @return 实例对象
 */
-(id)initWithDictionary:(NSDictionary *)dict;

@end
