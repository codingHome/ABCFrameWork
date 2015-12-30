//
//  ABCFileDownloadDBModel.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCFileDownloadManager.h"
#import "ABCFileDownloadDBModel.h"

@interface ABCFileDownloadInfoModel : NSObject

/// 文件名字
@property (nonatomic, retain) NSString *fileName;
/// 文件临时名字
@property (nonatomic, retain) NSString *fileTempName;
/// 文件路径
@property (nonatomic, retain) NSString *downloadUrl;
/// 文件下载后的存储路径
@property (nonatomic, retain) NSString *filePath;
/// 文件的大小
@property (nonatomic, assign) NSInteger fileSize;
/// 文件已经下载的长度
@property (nonatomic, assign) NSInteger downloadSize;
/// 文件的下载代理
@property (nonatomic, retain) NSMutableArray     *delegates;
/// 文件的下载请求
@property (nonatomic, retain) NSURLSessionDownloadTask   *downloadRequest;
/// 文件的下载状态
@property (nonatomic, assign) ABC_DOWNLOAD_STATUS status;
/// 计算下载速度的Timer
@property (nonatomic, retain) NSTimer *timer;
/// 累计每秒的下载的字节
@property (nonatomic, assign) NSInteger speed;

- (ABCFileDownloadDBModel *)transformToDBModel;

@end
