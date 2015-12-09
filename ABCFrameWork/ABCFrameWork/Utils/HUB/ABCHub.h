//
//  ABCHub.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface ABCHub : SVProgressHUD

+ (void)abc_show;

+ (void)abc_showWithStatus:(NSString*)string;

@end
