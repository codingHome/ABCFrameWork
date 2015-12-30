//
//  ABCZipManager.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/24.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZipArchiveCompleteBlock)(BOOL result, NSString *errorMessage);


@interface ABCZipManager : NSObject

/**
 *  单例方法
 *
 *  @return 实例变量
 */
+ (ABCZipManager *)sharedZipManager;

/**
 *  压缩文件
 *
 *  @param filePath                文件路径
 *  @param password                密码
 *  @param zipArchiveCompleteBlock 完成回调
 */
- (void)zipFile:(NSString *)filePath password:(NSString *)password complete:(ZipArchiveCompleteBlock)zipArchiveCompleteBlock;

/**
 *  解压缩文件
 *
 *  @param filePath                文件路径
 *  @param password                密码
 *  @param zipArchiveCompleteBlock 完成回调
 */
- (void)unZIpFile:(NSString *)filePath password:(NSString *)password complete:(ZipArchiveCompleteBlock)zipArchiveCompleteBlock;


@end
