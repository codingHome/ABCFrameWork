//
//  ABCDownloadManager.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/30.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCDownloadManager.h"
#import "AFNetworking.h"

@interface ABCDownloadManager ()

@property (nonatomic, strong) AFURLSessionManager      *sessionManager;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, copy  ) NSString                 *downloadDir;

@property (nonatomic, strong) NSData                   *resumeData;

@property (nonatomic, strong) DownloadProgressBlock    progressBlock;

@property (nonatomic, strong) DownloadSuccessBlock     successBlock;

@property (nonatomic, strong) DownloadFailureBlock     failureBlock;

@end

@implementation ABCDownloadManager

- (ABCDownloadManager *)downloadFileWithURLString:(NSString *)URLString
                                              cachePath:(NSString *)cachePath
                                               progress:(DownloadProgressBlock)progressBlock
                                                success:(DownloadSuccessBlock)successBlock
                                                failure:(DownloadFailureBlock)failureBlock {
    WS(weakSelf);
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    self.downloadDir = [ABC_PATH_FORMAT(ABC_PATH_DOCUMENTS, @"DownloadFile") stringByAppendingPathComponent:cachePath];
    
    
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:self.downloadDir isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    self.downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.progressBlock) {
            weakSelf.progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:weakSelf.downloadDir];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock(weakSelf.sessionManager, error);
            }
        }else {
            if (weakSelf.successBlock) {
                weakSelf.successBlock(weakSelf.sessionManager, response);
            }
        }
    }];
    
    [self.downloadTask resume];
    
    return self;
}

- (void)pause {
    WS(weakSelf);
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.resumeData = resumeData;
    }];
}

- (void)resume {
    WS(weakSelf);
    self.downloadTask = [self.sessionManager downloadTaskWithResumeData:self.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.progressBlock) {
            weakSelf.progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:weakSelf.downloadDir];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock(weakSelf.sessionManager, error);
            }
        }else {
            if (weakSelf.successBlock) {
                weakSelf.successBlock(weakSelf.sessionManager, response);
            }
        }
    }];
    [self.downloadTask resume];
}

- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict) {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

@end
