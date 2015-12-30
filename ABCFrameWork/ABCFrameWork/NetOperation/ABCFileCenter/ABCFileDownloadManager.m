//
//  ABCFileDownloadManager.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCFileDownloadManager.h"
#import "ABCFileDownloadInfoModel.h"

@interface ABCFileDownloadManager ()

@property (nonatomic, retain, readwrite) NSMutableDictionary   *allDownloadFileInfos;

@end

@implementation ABCFileDownloadManager

+ (ABCFileDownloadManager *)sharedDownloadManager {
    static dispatch_once_t onceToken;
    static ABCFileDownloadManager *sharedDownloadManager;
    dispatch_once(&onceToken, ^{
        sharedDownloadManager = [[self alloc] init];
    });
    return sharedDownloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.allDownloadFileInfos = [NSMutableDictionary dictionary];
        // 创建数据库和文件存数
        [self checkDBExist];
        // 初始化数据
        [self initDownloadFileInfos];
    }
    return self;
}

- (void)downloadFileWithURLString:(NSString *)urlString delegate:(id)delegate {
    ABC_DOWNLOAD_STATUS status = [self statusWithFileUrl:urlString];
    if (status == ABC_NEVER_DOWNLOAD)
    {
        // 没有下载过，创建一个下载
        [self creatRequestWithURLString:urlString delegate:delegate];
    }else if (status == ABC_DOWNLOAD_PAUSE) {
        //继续下载
        [self reStartRequestWithURLString:urlString delegate:delegate];
    }
    else if (status == ABC_DOWNLOAD_FINISH){
        if ([delegate respondsToSelector:@selector(downloadFailedWithURLString:error:)])
        {
            [delegate downloadFinishedWithURLString:urlString];
        }
        return;
    }
}

- (void)removeRequestWithURLString:(NSString *)urlString {
    ABCFileDownloadInfoModel *requestInfo = [self fileInfoForURLString:urlString];
    NSURLSessionDownloadTask *request = requestInfo.downloadRequest;
    [request cancel];
    // 停止计算速度的计时器
    if (requestInfo.timer)
    {
        if ([requestInfo.timer isValid])
        {
            [requestInfo.timer invalidate];
        }
        requestInfo.timer = nil;
    }
    // 删除下载的文件或临时文件
    [self removeFileWithURLString:requestInfo.downloadUrl];
    // 删除数据库
    [[requestInfo transformToDBModel] deleteFromTable];
    // 删除临时缓存字典中的文件对象
    if ([self.allDownloadFileInfos.allKeys containsObject:requestInfo.downloadUrl])
    {
        [self.allDownloadFileInfos removeObjectForKey:requestInfo.downloadUrl];
    }
}

- (void)removeAllRequest {
    
}

- (void)pauseWithURLString:(NSString *)urlString {
    
}

- (void)pauseAllRequest {
    
}

#pragma mark - Private Method
- (void)checkDBExist
{
    // 创建DB表
    [ABCFileDownloadDBModel createTable];
    
    // 创建文件下载的缓存路径
    NSString *tempPath = ABC_PATH_FORMAT(ABC_PATH_TMP, @"tempFile");
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath])
    {
        //如果不存在创建下载的缓存路径,因为下载时,不会自动创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:tempPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    // 创建文件的下载路径
    NSString *filePath = ABC_PATH_FORMAT(ABC_PATH_DOCUMENTS, @"DownloadedFile");

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //如果不存在说创建,因为下载时,不会自动创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

- (void)initDownloadFileInfos
{
    // 读取数据库数据
    NSArray  *dataArray = [ABCFileDownloadDBModel selectAll];
    [self.allDownloadFileInfos removeAllObjects];
    
    for (ABCFileDownloadDBModel *dbModel in dataArray)
    {
        ABCFileDownloadInfoModel *fileInfo = [[ABCFileDownloadInfoModel alloc] init];
        fileInfo.fileName = dbModel.name;
        fileInfo.fileTempName = dbModel.tempname;
        fileInfo.downloadUrl = dbModel.fileUrl;
        fileInfo.fileSize = dbModel.fileSize;
        fileInfo.filePath = dbModel.filePath;
        // 判断当前文件的状态
        ABC_DOWNLOAD_STATUS status = [self initDownloadStatueForFile:fileInfo];
        // 计算文件的进度
        if (status == ABC_DOWNLOAD_PAUSE)
        {
            // 判断缓存文件是否存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:ABC_PATH_FORMAT(ABC_PATH_TMP, fileInfo.fileTempName)])
            {
                // 计算下载的数据
                NSString *downloadSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:ABC_PATH_FORMAT(ABC_PATH_TMP, fileInfo.fileTempName) error:nil] objectForKey:NSFileSize];
                fileInfo.downloadSize = downloadSize.integerValue;
            }
            else
            {
                fileInfo.downloadSize = 0;
            }
        }
        else if (status == ABC_DOWNLOAD_FINISH)
        {
            fileInfo.downloadSize = fileInfo.fileSize;
        }
        else if (status == ABC_NEVER_DOWNLOAD)
        {
            fileInfo.downloadSize = 0;
        }
        // 将文件添加到下载文件信息字典中
        [self.allDownloadFileInfos setObject:fileInfo forKey:fileInfo.downloadUrl];
    }
}

- (ABC_DOWNLOAD_STATUS)initDownloadStatueForFile:(ABCFileDownloadInfoModel *)fileInfo {
    return 0;
}

- (void)creatRequestWithURLString:(NSString *)urlString delegate:(id)delegate {
#warning todo
}

- (void)reStartRequestWithURLString:(NSString *)urlString delegate:(id)delegate {
#warning todo
}

- (ABCFileDownloadInfoModel *)fileInfoForURLString:(NSString *)urlString
{
    if ([self.allDownloadFileInfos.allKeys containsObject:urlString])
    {
        ABCFileDownloadInfoModel *fileInfo = [self.allDownloadFileInfos objectForKey:urlString];
        return fileInfo;
    }
    
    return nil;
}
@end

@implementation ABCFileDownloadManager (downloadFileInfo)

- (NSArray *)getResumeDowndingFilesInfo {
    return nil;
}

- (ABC_DOWNLOAD_STATUS)statusWithFileUrl:(NSString *)urlString {
    return 0;
}

- (CGFloat)progressWithFileUrl:(NSString *)urlString {
    return 0;
}

- (CGFloat)fileSizeWithFileUrl:(NSString *)urlString {
    return 0;
}

- (NSString *)downPathWithURLString:(NSString *)urlString {
    return nil;
}

- (void)removeTemFileWithURLString:(NSString *)urlString {
    
}

- (void)removeFileWithURLString:(NSString *)urlString {
    
}

- (void)removeAllFile {
    
}

- (BOOL)checkFileIsExistWithURLString:(NSString *)urlString {
    return YES;
}

@end

@implementation ABCFileDownloadManager (downloadFileDelegate)

- (BOOL)checkDelegateExistWithURLString:(NSString *)urlString delegate:(id)delegate {
    return YES;
}

- (void)recoverAllDownloadWithURLString:(NSString *)urlString delegate:(id)delegate {
    
}

- (void)addDelegateToRequestWithURLString:(NSString *)urlString delegate:(id)delegate {
    
}

- (void)removeDelegateToRequestWithURLString:(NSString *)urlString delegate:(id)delegate {
    
}

@end