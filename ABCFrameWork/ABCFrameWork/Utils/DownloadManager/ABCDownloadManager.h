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
 *  @param cacheName     保存名称
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 当前下载任务
 */
- (void)downloadFileWithURLString:(NSString *)URLString
                        cacheName:(NSString *)cacheName
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
- (void)resumeWithURLString:(NSString *)URLString
                   Progress:(DownloadProgressBlock)progressBlock
                    success:(DownloadSuccessBlock)successBlock
                    failure:(DownloadFailureBlock)failureBlock;

/**
 *  删除下载的文件
 *
 *  @param URLString 下载Url
 */
- (void)deleteDownloadedFileWithURLString:(NSString *)URLString;

/**
 *  获取下载文件大小
 *
 *  @param URLString 下载Url
 *  @param isTemp    是否是临时文件夹下的文件
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForURLString:(NSString *)URLString isTemp:(BOOL)isTemp;

@end
