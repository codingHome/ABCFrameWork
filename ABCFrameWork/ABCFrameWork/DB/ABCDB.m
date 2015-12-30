//
//  ABCDB.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/22.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCDB.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "YYFMDatabase.h"
#import "YYFMDatabaseQueue.h"
#import "ABCSqlHanldler.h"

@interface ABCDB ()

@property (nonatomic, strong) YYFMDatabaseQueue *dbQueue;
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation ABCDB

+ (ABCDB *)sharedDB {
    static dispatch_once_t onceToken;
    static ABCDB *sharedDB;
    dispatch_once(&onceToken, ^{
        sharedDB = [[ABCDB alloc] init];
    });
    return sharedDB;
}

-(void)dealloc
{
    self.dbQueue = nil;
    [super dealloc];
}

/**
 *	@brief	初始化数据库
 *
 *	@param 	dbPath 	数据库路径
 */
- (void)initDBPath:(NSString *)dbPath
{
    self.dbPath = dbPath;
    if (self.dbQueue)
    {
        if ([self.dbQueue.path isEqualToString:dbPath])
        {
            return;
        }
        [self.dbQueue close];
    }
    self.dbQueue = [YYFMDatabaseQueue databaseQueueWithPath:dbPath];
}

- (void)setPassword:(NSString *)password
{
    [self.dbQueue.db setKey:password];
    _password = password;
}

/**
 *	@brief	销毁数据库
 *
 *	@param 	dbPath 	数据库路径
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)destroyDBPath:(NSString *)dbPath
{
    if (![[NSFileManager defaultManager]fileExistsAtPath:dbPath])
    {
        DDLogInfo(@"destroyDataBase：数据库不存在");
        return YES;
    }
    else
    {
        [self close];
        NSError *error=nil;
        [[NSFileManager defaultManager]removeItemAtPath:dbPath error:&error];
        if (error) {
            DDLogInfo(@"destroyDataBase:%@",error);
            return NO;
        }
        return YES;
    }
    return YES;
}

/**
 *	@brief	创建表
 *
 *	@param 	myClass 	类
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)createTable:(Class)myClass
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         [db executeUpdate:[ABCSqlHanldler createTableSql:myClass],nil];
     }];
    return YES;
}

/**
 *	@brief	删除表
 *
 *	@param 	myClass 	类
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)dropTable:(Class)myClass
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         [db executeUpdate:[ABCSqlHanldler dropTableSql:myClass],nil];
     }];
    return YES;
}

/**
 *	@brief	检测一个表是否存在
 *
 *	@param 	className 	表名
 *
 *	@return	YES 为存在 NO为不存在
 */
- (BOOL)checkTableIsExist:(NSString *)className
{
    
    __block BOOL retry = YES;
    __block BOOL exist = YES;
    
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         YYFMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", className];
         while ([rs next])
         {
             // just print out what we've got in a number of formats.
             NSInteger count = [rs intForColumn:@"count"];
             
             if (0 == count)
             {
                 exist = NO;
             }
             else
             {
                 exist = YES;
             }
             retry = NO;
         }
     }];
    
    while (retry) {}
    return exist;
}

#pragma mark - 插入

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	dictionary 	数据字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass dictionary:(NSDictionary *)dictionary
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
         NSString *sql = [ABCSqlHanldler insertSql:myClass dictionary:_dictionary];
         [db executeUpdate:sql withParameterDictionary:_dictionary];
     }];
    return YES;
}

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	myObject 	对象
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass object:(NSObject *)myObject
{
    NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:[self objectToDictionary:myObject]];
    NSString *sql = [ABCSqlHanldler insertSql:myClass dictionary:_dictionary];
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         [db executeUpdate:sql withParameterDictionary:_dictionary];
     }];
    return YES;
}

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	array 	数据数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass dictArray:(NSArray *)array
{
    [self.dbQueue inTransaction:^(YYFMDatabase *db, BOOL *rollback)
     {
         for (NSDictionary *dictionary in array)
         {
             __block NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
             __block NSString *sql = [ABCSqlHanldler insertSql:myClass dictionary:_dictionary];
             
             if (![db executeUpdate:sql withParameterDictionary:_dictionary])
             {
                 *rollback = YES;
                 return;
             }
             else
             {
                 *rollback = NO;
             }
         }
     }];
    return YES;
}

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	objectArray 	对象数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass objectArray:(NSArray *)objectArray
{
    for (NSObject *myObject in objectArray)
    {
        NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:[self objectToDictionary:myObject]];
        [self.dbQueue inTransaction:^(YYFMDatabase *db, BOOL *rollback)
         {
             NSString *sql = [ABCSqlHanldler insertSql:myClass dictionary:_dictionary];
             if (![db executeUpdate:sql withParameterDictionary:_dictionary])
             {
                 *rollback = YES;
                 return;
             }
         }];
    }
    return YES;
}

#pragma mark -  更新

/**
 *	@brief	更新表数据
 *
 *	@param 	myClass 	类
 *	@param 	dictionary  数据字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass dictionary:(NSDictionary *)dictionary
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
         NSString *sql = [ABCSqlHanldler updateSql:myClass dictionary:_dictionary];
         [db executeUpdate:sql withParameterDictionary:_dictionary];
     }];
    return YES;
}

/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	myObject  对象
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass object:(NSObject *)myObject
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:[self objectToDictionary:myObject]];
         NSString *sql = [ABCSqlHanldler updateSql:myClass dictionary:_dictionary];
         [db executeUpdate:sql withParameterDictionary:_dictionary];
     }];
    return YES;
}

/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	array  数据数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass dictArray:(NSArray *)array
{
    
    [self.dbQueue inTransaction:^(YYFMDatabase *db, BOOL *rollback)
     {
         for (NSDictionary *dictionary in array)
         {
             NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
             NSString *sql = [ABCSqlHanldler updateSql:myClass dictionary:_dictionary];
             if (![db executeUpdate:sql withParameterDictionary:_dictionary])
             {
                 *rollback = YES;
                 return;
             }
         }
     }];
    return YES;
}

/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	objectArray  对象数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass objectArray:(NSArray *)objectArray
{
    for (NSObject *myObject in objectArray)
    {
        NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithDictionary:[self objectToDictionary:myObject]];
        NSString *sql = [ABCSqlHanldler updateSql:myClass dictionary:_dictionary];
        
        [self.dbQueue inTransaction:^(YYFMDatabase *db, BOOL *rollback)
         {
             if (![db executeUpdate:sql withParameterDictionary:_dictionary])
             {
                 *rollback = YES;
                 return;
             }
         }];
        
    }
    return YES;
}

#pragma mark - 查询

/**
 *	@brief	查询表数据条数
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *
 */
- (NSInteger)queryCountFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args
{
    
    __block int count = -1;
    
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         
         NSString *sql = [ABCSqlHanldler queryCountSql:myClass conditions:conditions];
         YYFMResultSet *result = [self.dbQueue.db executeQuery:sql withArgumentsInArray:args];
         if ([result next]) {
             count = [result intForColumnIndex:0];
         }
         else
         {
             count = 0;
         }
     }];
    
    while (count == -1){}
    return count;
}

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *
 *	@return	对象数组
 */
-(void )queryObjectFromTable:(Class)myClass conditions:(NSString *)conditions args:(NSArray *)args order:(NSString *)order resultBlock:(QueryResultBlock)resultBlock
{
    NSString *sql = [ABCSqlHanldler queryAllSql:myClass conditions:conditions order:order];
    [self queryObject:myClass sql:sql args:args resultBlock:resultBlock];
}

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *
 *  @return 查询数组
 */
-(NSArray *)queryObjectFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order
{
    __block int i = 0;
    __block NSArray *tempArr = nil;
    [self queryObjectFromTable:myClass conditions:conditions args:args order:order resultBlock:^(NSArray *results)
     {
         tempArr = [NSArray arrayWithArray:results];
         i = 1;
     }];
    
    while (i == 0){}
    
    if (tempArr)
    {
        return tempArr;
    }
    
    return nil;
}

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *
 *	@return	对象数组
 */
-(void)queryDictionaryFromTable:(Class)myClass conditions:(NSString *)conditions args:(NSArray *)args order:(NSString *)order resultBlock:(QueryResultBlock)resultBlock
{
    NSString *sql = [ABCSqlHanldler queryAllSql:myClass conditions:conditions order:order];
    [self queryDictionary:myClass sql:sql args:args resultBlock:resultBlock];
}

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *
 *  @return 查询数组
 */
-(NSArray *)queryDictionaryFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order
{
    __block int i = 0;
    __block NSArray *tempArr = nil;
    [self queryDictionaryFromTable:myClass conditions:conditions args:args order:order resultBlock:^(NSArray *results)
     {
         tempArr = [NSArray arrayWithArray:results];
         i = 1;
     }];
    
    while (i == 0){}
    
    if (tempArr)
    {
        return tempArr;
    }
    
    return nil;
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	页数
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *
 *	@return	对象数组
 */
-(void)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString *)conditions args:(NSArray *)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString *)order resultBlock:(QueryResultBlock)resultBlock
{
    NSString *sql = [ABCSqlHanldler queryWithPageSql:myClass conditions:conditions pageNumber:pageNumber pageSize:pageSize order:order];
    [self queryObject:myClass sql:sql args:args resultBlock:resultBlock];
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	页数
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *
 *  @return 查询数组
 */
-(NSArray *)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order
{
    __block int i = 0;
    __block NSArray *tempArr = nil;
    [self queryObjectWithPageFromTable:myClass conditions:conditions args:args pageNumber:pageNumber pageSize:pageSize order:order resultBlock:^(NSArray *results)
     {
         tempArr = [NSArray arrayWithArray:results];
         i = 1;
     }];
    
    while (i == 0){}
    
    if (tempArr)
    {
        return tempArr;
    }
    
    return nil;
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	offSet 	从哪行开始查询
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args offSet:(NSInteger)offSet pageSize:(NSInteger)pageSize order:(NSString*)order  resultBlock:(QueryResultBlock)resultBlock
{
    NSString *sql = [ABCSqlHanldler queryWithPageSql:myClass conditions:conditions offSet:offSet pageSize:pageSize order:order];
    [self queryObject:myClass sql:sql args:args resultBlock:resultBlock];
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	offSet 	从哪行开始查询
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *
 *  @return 查询数组
 */
-(NSArray *)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args offSet:(NSInteger)offSet pageSize:(NSInteger)pageSize order:(NSString*)order
{
    __block int i = 0;
    __block NSArray *tempArr = nil;
    [self queryObjectWithPageFromTable:myClass conditions:conditions args:args offSet:offSet pageSize:pageSize order:order resultBlock:^(NSArray *results)
     {
         tempArr = [NSArray arrayWithArray:results];
         i = 1;
     }];
    
    while (i == 0){}
    
    if (tempArr)
    {
        return tempArr;
    }
    
    return nil;
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	页数
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *
 *	@return	字典数组
 */
-(void)queryDictionaryWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order resultBlock:(QueryResultBlock)resultBlock
{
    NSString *sql = [ABCSqlHanldler queryWithPageSql:myClass conditions:conditions pageNumber:pageNumber pageSize:pageSize order:order];
    [self queryDictionary:myClass sql:sql args:args resultBlock:resultBlock];
}

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	页数
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *
 *  @return 查询数组
 */
-(NSArray *)queryDictionaryWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order
{
    __block int i = 0;
    __block NSArray *tempArr = nil;
    [self queryDictionaryWithPageFromTable:myClass conditions:conditions args:args pageNumber:pageNumber pageSize:pageSize order:order resultBlock:^(NSArray *results)
     {
         tempArr = [NSArray arrayWithArray:results];
         i = 1;
     }];
    
    while (i == 0){}
    
    if (tempArr)
    {
        return tempArr;
    }
    
    return nil;
}

/**
 *	@brief	删除表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)deleteFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         NSString *sql = [ABCSqlHanldler deleteSql:myClass conditions:conditions];
         [db executeUpdate:sql withArgumentsInArray:args];
     }];
    
    return YES;
}

-(NSDictionary *)objectToDictionary:(NSObject *)myObject
{
    NSDictionary *dict = [ABCSqlHanldler objectToDictionary:myObject];
    return dict;
}
/**
 *	@brief	查询数据 针对所有查询和分页查询 提取出来的主要执行代码
 *
 *	@param 	myClass 	类
 *	@param 	sql 	sql语句
 *	@param 	args 	值
 *
 *	@return	数据数组
 */
-(void)queryObject:(Class)myClass sql:(NSString *)sql args:(NSArray *)args resultBlock:(QueryResultBlock)resultBlock
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         if (resultBlock != nil)
         {
             NSArray *array = [self queryObject:myClass sql:sql args:args];
             resultBlock(array);
         }
     }];
}

/**
 *	@brief	查询数据 针对所有查询和分页查询 提取出来的主要执行代码
 *
 *	@param 	myClass 	类
 *	@param 	sql 	sql语句
 *	@param 	args 	值
 *
 *	@return	数据数组
 */
-(NSArray *)queryObject:(Class)myClass sql:(NSString *)sql args:(NSArray *)args
{
    
    NSMutableArray *array=[NSMutableArray array];
    if (!self.dbQueue.db)
    {
        return array;
    }
    
    YYFMResultSet *result = [self.dbQueue.db executeQuery:sql withArgumentsInArray:args];
    while ([result next])
    {
        NSObject *obj=[[myClass alloc] init];
        NSDictionary *dictionary=[result resultDictionary];
        for (NSString *key in dictionary) {
            NSString *method=[NSString stringWithFormat:@"set%@%@",[[key substringToIndex:1] uppercaseString],[key substringFromIndex:1]];
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",method]);
            //判断该类中是否有对应的set方法
            if ([obj respondsToSelector:selector]) {
                @try {
                    id value=[dictionary objectForKey:key];
                    
                    NSString *type=[self getType:obj property:key];
                    
                    if ([type isEqualToString:@"string"]) {
                        
                        if (value==nil || [value isKindOfClass:[NSNull class]]) {
                            value=@"";
                        }
                        [obj performSelector:selector withObject:value];//调用set方法
                        
                    }
                    else if ([type isEqualToString:@"array"])
                    {
                        if (value==nil || [value isKindOfClass:[NSNull class]]) {
                            value=@"";
                        }
                        
                        NSArray *array = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                        if (array==nil || [array isKindOfClass:[NSNull class]]) {
                            array = [NSArray array];
                        }
                        [obj performSelector:selector withObject:array];//调用set方法
                    }
                    else {
                        if (value==nil||[value isKindOfClass:[NSNull class]]) {
                            
                        }else{
                            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Value",type]);//判断该类中是否有对应的set方法
                            
                            if ([value respondsToSelector:sel]) {
                                if ([type isEqualToString:@"double"])
                                {
                                    
                                    //                                    IMP myImp = [obj methodForSelector:selector];
                                    //                                    myImp(obj,selector,[value doubleValue]);
                                    
                                    double dValue = [value doubleValue];
                                    NSMethodSignature * signature = [self methodSignatureForSelector:selector];
                                    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                                    [invocation setTarget: self];
                                    [invocation setSelector:selector];
                                    [invocation setArgument:obj atIndex:2];
                                    [invocation setArgument:selector atIndex:3];
                                    [invocation setArgument:&dValue atIndex:4];
                                    [invocation invoke];
                                    
                                }
                                else if ([type isEqualToString:@"float"])
                                {
                                    float sid=[value floatValue];
                                    NSMethodSignature *signature = [obj methodSignatureForSelector:selector];
                                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                                    
                                    [invocation setTarget:obj];
                                    [invocation setSelector:selector];
                                    [invocation setArgument:&sid atIndex:2];
                                    
                                    [invocation invoke];
                                    
                                }
                                else if ([type isEqualToString:@"long"]){
                                    
                                    long long sid = [value longLongValue];
                                    
                                    NSMethodSignature *signature = [obj methodSignatureForSelector:selector];
                                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                                    
                                    [invocation setTarget:obj];
                                    [invocation setSelector:selector];
                                    [invocation setArgument:&sid atIndex:2];
                                    
                                    [invocation invoke];
                                }
                                else
                                {
                                    [obj performSelector:selector withObject:[value performSelector:sel withObject:nil]];
                                }//调用set方法
                            }else {
                                [obj performSelector:selector withObject:@""];//调用set方法
                            }
                            
                        }
                    }
                    
                }
                @catch (NSException * e) {
                    
                }
                @finally {
                    
                }
            }else {
                if (![method isEqualToString:@"setAbc_id"]) {
                    
                }
                
            }
        }
        
        if (obj)
        {
            [array addObject:obj];
        }
        [obj release];
    }
    return array;
}

/**
 *	@brief	查询数据 针对所有查询和分页查询 提取出来的主要执行代码
 *
 *	@param 	myClass 	类
 *	@param 	sql 	sql语句
 *	@param 	args 	值
 *
 *	@return	数据数组
 */
-(void)queryDictionary:(Class)myClass sql:(NSString *)sql args:(NSArray *)args resultBlock:(QueryResultBlock)resultBlock
{
    
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         if (resultBlock != nil)
         {
             NSArray *array = [self queryDictionary:myClass sql:sql args:args];
             resultBlock(array);
         }
     }];
}

/**
 *	@brief	查询数据 针对所有查询和分页查询 提取出来的主要执行代码
 *
 *	@param 	myClass 	类
 *	@param 	sql 	sql语句
 *	@param 	args 	值
 *
 *	@return	数据数组
 */
-(NSArray *)queryDictionary:(Class)myClass sql:(NSString *)sql args:(NSArray *)args
{
    YYFMResultSet *result = [self.dbQueue.db executeQuery:sql withArgumentsInArray:args];
    NSMutableArray *array=[NSMutableArray array];
    while ([result next]) {
        
        NSDictionary *dictionary=[result resultDictionary];
        [array addObject:dictionary];
    }
    return array;
}

-(BOOL)close
{
    if (self.dbQueue != nil)
    {
        [self.dbQueue close];
    }
    return YES;
}

#pragma mark -----------
/**
 *	@brief	获取类型字符串
 *
 *	@return
 */
-(NSString*) getType:(NSObject*) bean property:(NSString*) field{
    objc_property_t property = class_getProperty([bean class], [field cStringUsingEncoding:NSUTF8StringEncoding]);
    NSString *proty=[NSString stringWithFormat:@"%s",property_getAttributes(property)]; //字段的属性
    NSString *name=[NSString stringWithFormat:@"%s",property_getName(property)];        //字段的名称
    
    if ([name isEqualToString:field]) {
        NSString *class_type=[proty substringToIndex:2];
        if ([class_type isEqualToString:@"Tl"] || [class_type isEqualToString:@"Tq"]) {														// long类型字段
            return @"long";
        }else if ([class_type isEqualToString:@"T@"]) {
            if ([proty length]>12 && [[proty substringToIndex:12] isEqualToString:@"T@\"NSString\""]) { // NSString 类型字段
                return @"string";
            }
            
            if ([proty length]>11 && [[proty substringToIndex:11] isEqualToString:@"T@\"NSArray\""]) { // array 类型字段
                return @"array";
            }
        }else if ([class_type isEqualToString:@"Ti"]) {														// int类型字段
            return @"int";
        }else if ([class_type isEqualToString:@"Tf"])
        {
            return @"float";
        }
        else if([class_type isEqualToString:@"Td"])
        {
            return @"double";
        }
        else if ([class_type isEqualToString:@"Tc"] || [class_type isEqualToString:@"TB"])
        {
            return  @"bool";
        }
    }
    
    return @"";
}

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件值数组
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryWithSql:(NSString*)sql args:(NSArray*)args resultBlock:(QueryResultBlock)resultBlock
{
    if (resultBlock == nil)
    {
        return;
    }
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         
         NSArray *array = [self queryWithSql:sql args:args];
         if (resultBlock != nil)
         {
             resultBlock(array);
         }
     }];
    
}

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件值数组
 *
 *  @return 查询数组
 */
- (NSArray *)queryInQueueWithSql:(NSString *)sql args:(NSArray *)args
{
    __block NSArray *array = nil;
    
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         array = [self queryWithSql:sql args:args];
     }];
    
    while (!array) {}
    
    return array;
}

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *
 *  @return 查询数组
 */
- (NSArray *)queryInQueueWithSql:(NSString *)sql
{
    __block NSArray *array = nil;
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         array = [self queryWithSql:sql];
     }];
    
    while (!array) {}
    
    return array;
}

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件值数组
 *
 *  @return 查询数组
 */
-(NSArray *)queryWithSql:(NSString*)sql args:(NSArray*)args
{
    NSMutableArray *array=[NSMutableArray array];
    YYFMResultSet *rs = [self.dbQueue.db executeQuery:sql withArgumentsInArray:args];
    while ([rs next])
    {
        [array addObject:[rs resultDictionary]];
    }
    return array;
}

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *
 *  @return 查询数组
 */
-(NSArray *)queryWithSql:(NSString*)sql
{
    NSMutableArray *array = [NSMutableArray array];
    YYFMResultSet *rs = [self.dbQueue.db executeQuery:sql];
    while ([rs next])
    {
        [array addObject:[rs resultDictionary]];
    }
    
    return array;
}

/**
 *	@brief	执行sql语句
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL) executeWithSql:(NSString*)sql args:(NSDictionary*)args
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         [db executeUpdate:sql withParameterDictionary:args];
     }];
    return YES;
}

/**
 *	@brief	执行sql语句
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件数组
 *
 *	@return	成功 YES 失败 NO
 */

-(BOOL) executeWithSql:(NSString*)sql arrayArgs:(NSArray*)args
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db)
     {
         [db executeUpdate:sql withArgumentsInArray:args];
     }];
    return YES;
}

- (void)beginTransaction
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db) {
        [db beginTransaction];
    }];
    
}

- (void)endTransaction
{
    [self.dbQueue inDatabase:^(YYFMDatabase *db) {
        [db commit];
    }];
}

@end
