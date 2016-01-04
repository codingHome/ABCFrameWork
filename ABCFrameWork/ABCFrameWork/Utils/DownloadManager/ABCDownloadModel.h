//
//  ABCDownloadModel.h
//  ABCFrameWork
//
//  Created by Robert on 16/1/4.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ABCDBModel.h"

@interface ABCDownloadModel : ABCDBModel

/**
 *  下载URL
 */
@property (nonatomic, copy) NSString *downloadUrl;

/**
 *  下载路径
 */
@property (nonatomic, copy) NSString *downloadPath;

/**
 *  下载临时路径
 */
@property (nonatomic, copy) NSString *tempPath;

/**
 *  文件名称
 */
@property (nonatomic, copy) NSString *cacheName;

#pragma mark - DB
- (void)createTable;

- (void)insert;

- (void)update;

- (void)deleteFromTable;

+ (ABCDownloadModel *)selectWithDownloadUrl:(NSString *)downloadUrl;

#pragma mark - Status
- (BOOL)isPaused;

- (BOOL)isFinished;

@end
