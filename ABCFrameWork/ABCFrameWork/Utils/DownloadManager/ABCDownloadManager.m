//
//  ABCDownloadManager.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/30.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCDownloadManager.h"
#import "AFNetworking.h"
#import "ABCDownloadModel.h"

@interface ABCDownloadManager ()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, copy  ) NSString                 *downloadDir;

@property (nonatomic, copy  ) NSString                 *tempDir;

@property (nonatomic, strong) ABCDownloadModel         *downloadModel;

@end

@implementation ABCDownloadManager

- (void)downloadFileWithURLString:(NSString *)URLString
                        cacheName:(NSString *)cacheName
                         progress:(DownloadProgressBlock)progressBlock
                          success:(DownloadSuccessBlock)successBlock
                          failure:(DownloadFailureBlock)failureBlock {
    WS(weakSelf);
    
    self.downloadModel.downloadUrl = URLString;
    self.downloadModel.tempPath = [[self.tempDir lastPathComponent] stringByAppendingPathComponent:[cacheName stringByAppendingString:@".tmp"]];
    self.downloadModel.downloadPath = [[self.downloadDir lastPathComponent] stringByAppendingPathComponent:cacheName];
    self.downloadModel.cacheName = cacheName;
    [self.downloadModel insert];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    __block AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    self.downloadTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:weakSelf.downloadDir];
        return [documentsDirectoryURL URLByAppendingPathComponent:cacheName];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(sessionManager, error);
            }
        }else {
            if (successBlock) {
                successBlock(sessionManager, response);
            }
        }
    }];
    
    [self.downloadTask resume];
}

- (void)pause {
    WS(weakSelf);
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [resumeData writeToFile:[weakSelf.tempDir stringByAppendingPathComponent:[weakSelf.downloadModel.cacheName stringByAppendingString:@".tmp"]] atomically:YES];
    }];
}

- (void)resumeWithURLString:(NSString *)URLString
                   Progress:(DownloadProgressBlock)progressBlock
                    success:(DownloadSuccessBlock)successBlock
                    failure:(DownloadFailureBlock)failureBlock {
    WS(weakSelf);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    __block AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    self.downloadModel = [ABCDownloadModel selectWithDownloadUrl:URLString];
    
    NSData *resumeData = [NSData dataWithContentsOfFile:ABC_PATH_FORMAT(ABC_PATH_TMP, self.downloadModel.tempPath)];
    
    self.downloadTask = [sessionManager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:weakSelf.downloadDir];
        return [documentsDirectoryURL URLByAppendingPathComponent:weakSelf.downloadModel.cacheName];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(sessionManager, error);
            }
        }else {
            [self removeTempFile:self.downloadModel];
            if (successBlock) {
                successBlock(sessionManager, response);
            }
        }
    }];
    [self.downloadTask resume];
}

- (void)deleteDownloadedFileWithURLString:(NSString *)URLString {
    ABCDownloadModel *model = [ABCDownloadModel selectWithDownloadUrl:URLString];
    [self removeTempFile:model];
    [self removeDownloadFile:model];
    [model deleteFromTable];
}

- (unsigned long long)fileSizeForURLString:(NSString *)URLString isTemp:(BOOL)isTemp {
    signed long long fileSize = 0;
    
    ABCDownloadModel *model = [ABCDownloadModel selectWithDownloadUrl:URLString];
    
    NSString *path = isTemp ? model.tempPath : model.downloadPath;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict) {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

#pragma mark - Private Method
- (instancetype)init {
    if (self = [super init]) {
        self.downloadModel = [[ABCDownloadModel alloc] init];
        [self.downloadModel createTable];
        [self initDir];
    }
    return self;
}

- (void)initDir {
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:self.downloadDir isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    existed = [[NSFileManager defaultManager] fileExistsAtPath:self.tempDir isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.tempDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)removeTempFile:(ABCDownloadModel *)model {
    NSString *tempPath = ABC_PATH_FORMAT(ABC_PATH_TMP, model.tempPath);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:tempPath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    }
}

- (void)removeDownloadFile:(ABCDownloadModel *)model {
    NSString *downloadPath = ABC_PATH_FORMAT(ABC_PATH_DOCUMENTS, model.downloadPath);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:downloadPath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
    }
}

#pragma mark - Setter && Getter
- (NSString *)downloadDir {
    if (!_downloadDir) {
        _downloadDir = ABC_PATH_FORMAT(ABC_PATH_DOCUMENTS, @"DownloadFile");
    }
    return _downloadDir;
}

- (NSString *)tempDir {
    if (!_tempDir) {
        _tempDir = ABC_PATH_FORMAT(ABC_PATH_TMP, @"TempFile");
    }
    return _tempDir;
}

@end
