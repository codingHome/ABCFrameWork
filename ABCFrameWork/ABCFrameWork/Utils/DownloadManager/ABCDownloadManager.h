//
//  ABCDownloadManager.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/30.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadProgressBlock)(CGFloat progress, CGFloat total);
typedef void(^DownloadSuccessBlock)(AFURLSessionManager *operation, id responseObject);
typedef void(^DownloadFailureBlock)(AFURLSessionManager *operation, NSError *error);


@interface ABCDownloadManager : NSObject

/**
 *  下载方法
 *
 *  @param URLString     下载URL
 *  @param cachePath     保存路径
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 当前下载任务
 */
- (ABCDownloadManager *)downloadFileWithURLString:(NSString *)URLString
                                              cachePath:(NSString *)cachePath
                                               progress:(DownloadProgressBlock)progressBlock
                                                success:(DownloadSuccessBlock)successBlock
                                                failure:(DownloadFailureBlock)failureBlock;
/**
 *  暂停下载文件
 */
- (void)pause;

/**
 *  继续下载文件
 */
- (void)resume;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;

@end
