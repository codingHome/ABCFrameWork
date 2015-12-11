//
//  ABCCallBackModelDelegate.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABCCallBackModelDelegate <NSObject>

@optional

/**
 *  唯一索引
 */
@property (nonatomic, readonly) NSString *uniqueIndex;

@end