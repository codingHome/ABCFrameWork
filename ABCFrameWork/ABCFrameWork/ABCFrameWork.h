//
//  ABCFrameWork.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 Robert. All rights reserved.
//
//
/*
 *   #####################################################
 *   #                                                   #
 *   #                       _oo0oo_                     #
 *   #                      o8888888o                    #
 *   #                      88" . "88                    #
 *   #                      (| -_- |)                    #
 *   #                      0\  =  /0                    #
 *   #                    ___/`---'\___                  #
 *   #                  .' \\|     |# '.                 #
 *   #                 / \\|||  :  |||# \                #
 *   #                / _||||| -:- |||||- \              #
 *   #               |   | \\\  -  #/ |   |              #
 *   #               | \_|  ''\---/''  |_/ |             #
 *   #               \  .-\__  '-'  ___/-. /             #
 *   #             ___'. .'  /--.--\  `. .'___           #
 *   #          ."" '<  `.___\_<|>_/___.' >' "".         #
 *   #         | | :  `- \`.;`\ _ /`;.`/ - ` : | |       #
 *   #         \  \ `_.   \_ __\ /__ _/   .-` /  /       #
 *   #     =====`-.____`.___ \_____/___.-`___.-'=====    #
 *   #                       `=---='                     #
 *   #     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #
 *   #                                                   #
 *   #               佛祖保佑         永无BUG              #
 *   #                                                   #
 *   #####################################################
*/

#ifndef ABCFrameWork_ABCFrameWork_h
#define ABCFrameWork_ABCFrameWork_h

#import "ABCPrecompile.h"
#import "ABCUtilExtend.h"

#import "ABCRequestModel.h"
#import "ABCNetOperation.h"

#import "Masonry.h"
#import "UIView+DDAddition.h"
#import "NSString+Additions.h"
#import "NSDate+util.h"

#import "CocoaLumberjack/CocoaLumberjack.h"


#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

#endif
