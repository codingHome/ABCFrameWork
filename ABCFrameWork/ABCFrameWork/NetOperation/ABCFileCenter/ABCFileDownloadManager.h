//
//  ABCFileDownloadManager.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ABC_DOWNLOAD_STATUS) {
    ABC_NEVER_DOWNLOAD,
    ABC_DOWNLOADING,
    ABC_DOWNLOAD_FINISH,
    ABC_DOWNLOAD_PAUSE
};

@protocol ABCFileDownloadManagerDelegate <NSObject>
@optional

/**
 *  开始下载回调
 *
 *  @param urlString 下载URL
 */
- (void)downloadStartedWithURLString:(NSString *)urlString;

/**
 *  下载完成回调
 *
 *  @param urlString 下载URL
 */
- (void)downloadFinishedWithURLString:(NSString *)urlString;

/**
 *  下载失败回调
 *
 *  @param urlString 下载URL
 *  @param error     失败信息
 */
- (void)downloadFailedWithURLString:(NSString *)urlString error:(NSError *)error;

/**
 *  下载进度回调
 *
 *  @param urlString 下载URL
 *  @param progress  下载进度
 */
- (void)downloadingWithURLString:(NSString *)urlString progress:(float)progress;

/**
 *  下载速度回调
 *
 *  @param urlString 下载URL
 *  @param speed     下载速度
 */
- (void)downloadingWithURLString:(NSString *)urlString speed:(float)speed;
@end


@interface ABCFileDownloadManager : NSObject

/**
 *  下载文件信息
 */
@property (nonatomic, retain, readonly) NSMutableDictionary   *allDownloadFileInfos;

/**
 *  单例方法
 *
 *  @return 实例变量
 */
+ (ABCFileDownloadManager *)sharedDownloadManager;

/**
 *  下载方法
 *
 *  @param urlString 下载URL
 *  @param delegate  下载delegate
 */
- (void)downloadFileWithURLString:(NSString *)urlString delegate:(id)delegate;

/**
 *  移除下载请求
 *
 *  @param urlString 下载URL
 */
- (void)removeRequestWithURLString:(NSString *)urlString;

/**
 *  移除全部下载请求
 */
- (void)removeAllRequest;

/**
 *  暂停请求
 *
 *  @param urlString 下载URL
 */
- (void)pauseWithURLString:(NSString *)urlString;

/**
 *  暂停全部请求
 */
- (void)pauseAllRequest;

@end


@interface ABCFileDownloadManager (downloadFileInfo)

/**
 *  获取当前下载文件信息
 *
 *  @return 文件信息数组
 */
- (NSArray *)getResumeDowndingFilesInfo;

/**
 *  指定下载请求状态
 *
 *  @param urlString 下载URL
 *
 *  @return 下载状态
 */
- (ABC_DOWNLOAD_STATUS)statusWithFileUrl:(NSString *)urlString;

/**
 *  下载文件进度
 *
 *  @param urlString 下载URL
 *
 *  @return 文件进度
 */
- (CGFloat)progressWithFileUrl:(NSString *)urlString;

/**
 *  下载文件大小
 *
 *  @param urlString 下载URL
 *
 *  @return 文件大小
 */
- (CGFloat)fileSizeWithFileUrl:(NSString *)urlString;

/**
 *  文件路径
 *
 *  @param urlString 下载URL
 *
 *  @return 文件大小
 */
- (NSString *)downPathWithURLString:(NSString *)urlString;

/**
 *  移除未下载完成文件
 *
 *  @param urlString 下载URL
 */
- (void)removeTemFileWithURLString:(NSString *)urlString;

/**
 *  移除下载完成文件
 *
 *  @param urlString 下载URL
 */
- (void)removeFileWithURLString:(NSString *)urlString;

/**
 *  移除全部文件
 */
- (void)removeAllFile;

/**
 *  检查文件是否存在
 *
 *  @param urlString 下载URL
 *
 *  @return YES：文件存在 NO：文件不存在
 */
- (BOOL)checkFileIsExistWithURLString:(NSString *)urlString;

@end


@interface ABCFileDownloadManager (downloadFileDelegate)

/**
 *  检查下载代理是否存在
 *
 *  @param urlString 下载URL
 *  @param delegate  下载代理
 *
 *  @return YES：代理存在 NO：代理不存在
 */
- (BOOL)checkDelegateExistWithURLString:(NSString *)urlString delegate:(id)delegate;

/**
 *  恢复下载
 *
 *  @param urlString 下载URL
 *  @param delegate  下载代理
 */
- (void)recoverAllDownloadWithURLString:(NSString *)urlString delegate:(id)delegate;

/**
 *  下载添加代理
 *
 *  @param urlString 下载URL
 *  @param delegate  下载代理
 */
- (void)addDelegateToRequestWithURLString:(NSString *)urlString delegate:(id)delegate;

/**
 *  移除下载代理
 *
 *  @param urlString 下载URL
 *  @param delegate  下载代理
 */
- (void)removeDelegateToRequestWithURLString:(NSString *)urlString delegate:(id)delegate;

@end
