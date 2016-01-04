//
//  ABCDownloadModel.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/4.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ABCDownloadModel.h"

@implementation ABCDownloadModel

- (void)createTable {
    BOOL isExist = [getCacheDB() checkTableIsExist:[self description]];
    if (isExist) {
        return;
    }else {
        [getCacheDB() createTable:[self class]];
    }
}

- (void)insert {
    NSArray *result = [getCacheDB() queryObjectFromTable:[self class] conditions:@"downloadUrl = ?" args:@[self.downloadUrl] order:nil];
    if (result.count) {
        ABCDownloadModel *model = [result objectAtIndex:0];
        NSString *dbId = [NSString stringWithFormat:@"%ld",model.abc_id];
        self.abc_id = [dbId integerValue];
        [getCacheDB() updateTable:[self class] object:self];
    }else {
        [getCacheDB() insertTable:[self class] object:self];
    }
}

- (void)update {
    [self insert];
}

- (void)deleteFromTable {
    [getCacheDB() deleteFromTable:[self class] conditions:@"downloadUrl = ?" args:@[self.downloadUrl]];
}

+ (ABCDownloadModel *)selectWithDownloadUrl:(NSString *)downloadUrl {
    NSArray *result = [getCacheDB() queryObjectFromTable:[self class] conditions:@"downloadUrl = ?" args:@[downloadUrl] order:nil];
    if (result.count) {
        return [result firstObject];
    }
    return nil;
}

- (BOOL)isPaused {
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:self.tempPath];
    if (isExist) {
        return YES;
    }
    return NO;
}

- (BOOL)isFinished {
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath];
    if (isExist) {
        return YES;
    }
    return NO;
}

@end
