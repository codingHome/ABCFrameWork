//
//  ABCUtilExtend.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 * 通知的便捷方法
 */
CG_INLINE void ADD_NOTIFICATION(NSString *name, id target, SEL action, id object)
{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:action name:name object:object];
}

CG_INLINE void REMOVE_NOTIFICATION(NSString *name, id target, id object)
{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:name object:object];
}

CG_INLINE void POST_NOTIFICATION(NSString *name, id object, NSDictionary *userInfo)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

/*
 * alert框
 */

CG_INLINE void AlertlogError (NSString* message)
{
    static UIAlertView *alertView = nil;
    if (!alertView)
    {
        alertView = [[UIAlertView alloc] initWithTitle:  @""
                                               message: message
                                              delegate: nil
                                     cancelButtonTitle: @"OK"
                                     otherButtonTitles: nil,
                     nil];
        [alertView show];
    }
    else
    {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
        alertView = [[UIAlertView alloc] initWithTitle:  @""
                                               message: message
                                              delegate: nil
                                     cancelButtonTitle: @"OK"
                                     otherButtonTitles: nil,
                     nil];
        [alertView show];
    }
}
