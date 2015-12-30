//
//  ABCFileDownloadDBModel.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCDBModel.h"

@interface ABCFileDownloadDBModel : ABCDBModel

/// 文件的名字
@property (nonatomic, strong) NSString  *name;
/// 文件临时名字
@property (nonatomic, strong) NSString  *tempname;
/// 文件的下载url
@property (nonatomic, strong) NSString  *fileUrl;
/// 要下载的文件长度
@property (nonatomic, assign) NSUInteger    fileSize;
/// 文件下载后的存储路径
@property (nonatomic, strong) NSString  *filePath;


+ (void)createTable;

+ (NSArray *)selectAll;

+ (ABCFileDownloadDBModel *)selectWithUrl:(NSString *)url;

- (void)insert;

- (void)update;

- (void)deleteFromTable;

@end
