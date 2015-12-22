//
//  YYFMDatabasePool.m
//  YYFMDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "YYFMDatabaseQueue.h"
#import "YYFMDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 YYFMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */
 
@implementation YYFMDatabaseQueue

@synthesize path = _path;

+ (id)databaseQueueWithPath:(NSString*)aPath {
    
    YYFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    YYFMDBAutorelease(q);
    
    return q;
}

- (id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [YYFMDatabase databaseWithPath:aPath];
        YYFMDBRetain(_db);
        
        if (![_db open]) {
            NSLog(@"Could not create database queue for path %@", aPath);
            YYFMDBRelease(self);
            return 0x00;
        }
        
        _path = YYFMDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"YYFMDB.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (YYFMDatabase *)db
{
    return _db;
}

- (void)dealloc {
    
    YYFMDBRelease(_db);
    YYFMDBRelease(_path);
    
    if (_queue) {
        YYFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    YYFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        [_db close];
        YYFMDBRelease(_db);
        _db = 0x00;
    });
    YYFMDBRelease(self);
}

- (YYFMDatabase*)database {
    if (!_db) {
        _db = YYFMDBReturnRetained([YYFMDatabase databaseWithPath:_path]);
        
        if (![_db open]) {
            NSLog(@"YYFMDatabaseQueue could not reopen database for path %@", _path);
            YYFMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(YYFMDatabase *db))block
{
    YYFMDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        YYFMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [YYFMDatabaseQueue inDatabase:]");
        }
    });
    
    YYFMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(YYFMDatabase *db, BOOL *rollback))block {
    YYFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    YYFMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(YYFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(YYFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(YYFMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    YYFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
            
        }
    });
    YYFMDBRelease(self);
    return err;
}
#endif

@end
