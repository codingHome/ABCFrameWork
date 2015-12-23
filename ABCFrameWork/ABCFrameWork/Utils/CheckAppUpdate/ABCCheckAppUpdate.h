//
//  ABCCheckAppUpdate.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/22.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABCCheckAppUpdateDelegate <NSObject>

/**
 *	@brief	检测更新错误
 *
 *	@param 	error 	错误信息
 */
-(void)checkAppUpdateError:(NSString *)error;

@end

@interface ABCCheckAppUpdate : NSObject

/**
 *	@brief	检测更新
 *
 *	@param 	delegate    代理
 */
- (void)checkNativeUpdateDelegate:(id <ABCCheckAppUpdateDelegate>)delegate;

@end
