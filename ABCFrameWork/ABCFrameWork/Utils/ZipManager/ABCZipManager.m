//
//  ABCZipManager.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/24.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCZipManager.h"
#import "ZipArchive.h"

@interface ABCZipManager () <ZipArchiveDelegate>

@property (nonatomic, strong) ZipArchive *zipArchive;

@property (nonatomic, copy) ZipArchiveCompleteBlock completeBlock;

@end

@implementation ABCZipManager

+ (ABCZipManager *)sharedZipManager {
    static dispatch_once_t onceToken;
    static ABCZipManager *sharedManager;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ABCZipManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _zipArchive = [[ZipArchive alloc] init];
        _zipArchive.delegate = self;
    }
    return self;
}

- (void)zipFile:(NSString *)filePath password:(NSString *)password complete:(ZipArchiveCompleteBlock)zipArchiveCompleteBlock {
    
    self.completeBlock = zipArchiveCompleteBlock;
    
    NSString *fileName = [filePath lastPathComponent];
    
    NSArray *tempArray = [fileName componentsSeparatedByString:@"."];
    
    NSString *OriginFileName = nil;
    
    if (tempArray.count) {
        OriginFileName = [tempArray firstObject];
    }
    
    if ([OriginFileName isEmpty]) {
        return;
    }
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@.zip",OriginFileName];
    
    NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@",[filePath stringByDeletingLastPathComponent], zipFileName];
    
    BOOL result = false;
    
    if ([password isEmpty]) {
        result = [_zipArchive CreateZipFile2:zipFilePath];
    }else {
        result = [_zipArchive CreateZipFile2:zipFilePath Password:password];
    }
    
    result = [_zipArchive addFileToZip:filePath newname:fileName];
    
    result = [_zipArchive CloseZipFile2];
    
    if (self.completeBlock) {
        if (result) {
            self.completeBlock(result, nil);
        }
    }
}

- (void)unZIpFile:(NSString *)filePath password:(NSString *)password complete:(ZipArchiveCompleteBlock)zipArchiveCompleteBlock {
    
    self.completeBlock = zipArchiveCompleteBlock;
    
    NSString *fileName = [filePath lastPathComponent];
    
    NSArray *tempArray = [fileName componentsSeparatedByString:@"."];
    
    NSString *OriginFileName = nil;
    
    if (tempArray.count) {
        OriginFileName = [tempArray firstObject];
    }
    
    if ([OriginFileName isEmpty]) {
        return;
    }
    
    NSString *unZipFileDir = [NSString stringWithFormat:@"%@/%@",[filePath stringByDeletingLastPathComponent], OriginFileName];
    
    BOOL result = false;
    
    if ([password isEmpty]) {
        result = [_zipArchive UnzipOpenFile:filePath];
    }else {
        result = [_zipArchive UnzipOpenFile:filePath Password:password];
    }
    
    result = [_zipArchive UnzipFileTo:unZipFileDir overWrite:YES];
    
    result = [_zipArchive UnzipCloseFile];
    
    if (self.completeBlock) {
        if (result) {
            
            NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:unZipFileDir];
            NSString* fileName = nil;
            while ((fileName = [dirEnum nextObject])) {

                NSString *unZipFileFullPath = [unZipFileDir stringByAppendingPathComponent:fileName];
                
                NSString *targetFilePath = [[unZipFileDir stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
                
                [[NSFileManager defaultManager] moveItemAtPath:unZipFileFullPath toPath:targetFilePath error:nil];
                
                [[NSFileManager defaultManager] removeItemAtPath:unZipFileDir error:nil];
                
                break;
            }
            self.completeBlock(result, nil);
        }
    }
}

#pragma mark - ZipArchiveDelegate
-(void) ErrorMessage:(NSString*) msg {
    if (self.completeBlock) {
        self.completeBlock(false, msg);
    }
}

-(BOOL) OverWriteOperation:(NSString*) file {
    return true;
}

@end
