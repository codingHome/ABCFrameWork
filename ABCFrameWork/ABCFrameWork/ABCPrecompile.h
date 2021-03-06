//
//  ABCPrecompile.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 Robert. All rights reserved.
//

#ifndef ABCPrecompile_h
#define ABCPrecompile_h

#import "ABCDB.h"

//主代理
#define ABCAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/**
 *  色值宏定义
 */
#define ABC_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ABC_RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

/**
 *  字体大小
 */
#define ABC_FONT_SIZE_DEFAULT(size) [UIFont systemFontOfSize:size]
#define ABC_FONT_SIZE_BOLD(size)    [UIFont boldSystemFontOfSize:size]

/**
 *  当前系统版本
 */
#define ABC_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  导航条高度
 */
#define ABC_STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 *  设备屏幕高度
 */
#define ABC_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  设备屏幕宽度
 */
#define ABC_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

/**
 *  满屏幕大小
 */
#define ABC_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

/**
 *  当前版本支持最低系统配置
 */
#define ABC_LEAST_DEVICE_VERSION(x) SYSTEM_VERSION >= x ? 1 : 0

/**
 *  简写NSFileManager
 */
#define ABC_FILE_MANAGER ([NSFileManager defaultManager])

/**
 *  简写NSUserDefaults
 */
#define ABC_USER_DEFAULT ([NSUserDefaults standardUserDefaults])

/**
 *  沙盒路径
 */
#define ABC_PATH_SANDBOX ( NSHomeDirectory() )
#define ABC_PATH_DOCUMENTS ( NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] )
#define ABC_PATH_LIBRARY   ( NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] )
#define ABC_PATH_CACHE  ( NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] )
#define ABC_PATH_TMP     ( NSTemporaryDirectory() )

/**
 *  自定义沙盒路径
 */
#define ABC_PATH_FORMAT(main_path,sub_path) ( sub_path==nil ? main_path : [NSString stringWithFormat:@"%@/%@", main_path, sub_path] )
#define ABC_PATH_FORMAT_SANDBOX(sub_path)   ABC_PATH_FORMAT(PATH_SANDBOX, sub_path)
#define ABC_PATH_FORMAT_DOCUMENTS(sub_path) ABC_PATH_FORMAT(PATH_LIBRARY, sub_path)
#define ABC_PATH_FORMAT_LIBRARY(sub_path)   ABC_PATH_FORMAT(PATH_LIBRARY, sub_path)
#define ABC_PATH_FORMAT_TMP(sub_path)       ABC_PATH_FORMAT(PATH_TMP, sub_path)

/**
 *  资源文件路径
 */
#define ABC_PATH_RESOURCE(resource, type) \
[[NSBundle mainBundle] pathForResource:resource ofType:type]

/**
 *  weakSelf
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 *  程序主代理
 */
#define APP_DELEGATE    ((AppDelegate *)[UIApplication sharedApplication].delegate)
#endif /* ABCPrecompile_h */

/**
 *  缓存数据库
 */
static ABCDB *cacheDb = nil;

CG_INLINE ABCDB* getCacheDB() {
    if (!cacheDb) {
        cacheDb = [[ABCDB alloc] init];
        
        NSString *dbDir = [NSString stringWithFormat:@"%@/%@",ABC_PATH_CACHE, @"com.abc.cache"];
        
        BOOL isDir = false;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbDir isDirectory:&isDir];
        
        if (!isExist || !isDir) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dbDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@", dbDir, @"cache.db"];
        
        [cacheDb initDBPath:dbPath];
        cacheDb.password = dbPath;
    }
    return cacheDb;
}