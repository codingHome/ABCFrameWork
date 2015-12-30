//
//  ABCFileDownloadDBModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/29.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCFileDownloadDBModel.h"

@implementation ABCFileDownloadDBModel

+ (void)createTable {
    if (![getCacheDB() checkTableIsExist:[self description]]) {
        [getCacheDB() createTable:[self class]];
    }
}

+ (NSArray *)selectAll {
    return [getCacheDB() queryDictionaryFromTable:[self class] conditions:nil args:nil order:nil];
}


+ (ABCFileDownloadDBModel *)selectWithUrl:(NSString *)url {
    NSArray *result = [getCacheDB() queryObjectFromTable:[self class] conditions:@"fileUrl = ?" args:@[url] order:nil];
    if (result && result.count) {
        return [result firstObject];
    }
    return nil;
}

- (void)insert {
    NSArray *result = [getCacheDB() queryObjectFromTable:[self class] conditions:@"fileUrl = ?" args:@[self.fileUrl] order:nil];
    if (result && result.count) {
        ABCFileDownloadDBModel *model = [result firstObject];
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
    [getCacheDB() deleteFromTable:[self class] conditions:@"" args:@[]];
}

@end
