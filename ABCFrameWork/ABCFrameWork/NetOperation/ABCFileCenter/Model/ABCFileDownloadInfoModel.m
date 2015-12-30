//
//  ABCFileDownloadDBModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCFileDownloadInfoModel.h"

@interface ABCFileDownloadInfoModel ()

@property (nonatomic, strong) ABCFileDownloadDBModel *fileDBModel;

@end

@implementation ABCFileDownloadInfoModel

- (void)dealloc {
    if ([self.timer isValid]){
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (id)init {
    if (self = [super init]){
        self.delegates = [NSMutableArray array];
    }
    return self;
}

- (ABC_DOWNLOAD_STATUS)status {
    return [[ABCFileDownloadManager sharedDownloadManager] statusWithFileUrl:self.downloadUrl];
}


- (ABCFileDownloadDBModel *)transformToDBModel {
    if (self.fileDBModel) {
        self.fileDBModel = [[ABCFileDownloadDBModel alloc] init];
        self.fileDBModel.name = self.fileName;
        self.fileDBModel.tempname = self.fileTempName;
        self.fileDBModel.fileUrl = self.downloadUrl;
        self.fileDBModel.fileSize = self.fileSize;
        self.fileDBModel.filePath = self.filePath;
    }
    return self.fileDBModel;
}

@end
