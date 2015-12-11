//
//  ABCCallBackModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCCallBackModel.h"
#import "ABCSqlHandler.h"
#import "ABCDataBase.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "FMDB.h"

@interface ABCCallBackModel ()

{
@protected
    __block BOOL _retry;
    __block BOOL _exist;
}

@end

@implementation ABCCallBackModel

- (id)init
{
    if (self = [super init]) {
        
        // 如果存在表, 那么就不在创建表
        if (![self checkTableIsExist]) {
            [self createTable];
            [self createUniqueIndex:[self uniqueIndex]];
        }
    }
    
    return self;
}

- (NSString *)uniqueIndex
{
    return nil;
}

- (long)abc_id {
    return abc_id;
}

#pragma mark -
#pragma mark SQL Public Methods

/**
 *  创建表
 */
- (BOOL)createTable
{
    NSString *sql = [ABCSqlHandler createTableSql:[self class]];;
    return [self executeUpdate:sql];
}

/**
 *  删除表
 */
- (BOOL)dropTable
{
    return [self executeUpdate:[ABCSqlHandler dropTableSql:[self class]], nil];
}

/**
 *  判断表是否存在
 */
- (BOOL)checkTableIsExist
{
    _retry = YES;
    _exist = YES;
    
    [self inDatabase:^(FMDatabase *db)
     {
         NSString *className = NSStringFromClass([self class]);
         
         FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", className];
         while ([rs next])
         {
             // just print out what we've got in a number of formats.
             NSInteger count = [rs intForColumn:@"count"];
             
             if (0 == count)
             {
                 _exist = NO;
             }
             else
             {
                 _exist = YES;
             }
             _retry = NO;
         }
         [rs close];
     }];
    
    while (_retry) {}
    
    return _exist;
}

/**
 *  插入数据
 */
- (BOOL)insertTable
{
    NSMutableDictionary *_dictionary = [NSMutableDictionary dictionaryWithDictionary:[ABCSqlHandler objectToDictionary:self]];
    NSString *sql = [ABCSqlHandler insertSql:[self class] dictionary:_dictionary];
    
    return [self executeUpdate:sql withParameterDictionary:_dictionary];
}

/**
 *  更新数据
 */
- (BOOL)updateTable
{
    NSMutableDictionary *_dictionary = [NSMutableDictionary dictionaryWithDictionary:[ABCSqlHandler objectToDictionary:self]];
    NSString *sql = [ABCSqlHandler updateSql:[self class] dictionary:_dictionary];
    
    return [self executeUpdate:sql withParameterDictionary:_dictionary];
}

/**
 *  移除数据
 */
- (BOOL)deleteFromTable
{
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql = [ABCSqlHandler deleteSql:[self class]
                                         conditions:[NSString stringWithFormat:@"abc_id=%ld",self->abc_id]];
        [db executeUpdate:sql withArgumentsInArray:@[@(2)]];
    }];
    return YES;
}

/**
 *  查询数据 （所有数据）
 */
- (NSArray *)selectFromTable
{
    return [self transformResult:[self executeQuery:[ABCSqlHandler queryAllSql:[self class] conditions:nil order:nil]]];
}

/**
 *  查询数据 （条件查询）
 */
- (NSArray *)selectByConditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order
{
    return [self transformResult:[self executeQuery:[ABCSqlHandler queryWithPageSql:[self class] conditions:conditions pageNumber:pageNumber pageSize:pageSize order:order]]];
}

/**
 *  创建唯一索引
 */
- (BOOL)createUniqueIndex:(NSString *)indexName;
{
    // 如果索引字段为空, 不在创建
    if (!indexName || [indexName isEqualToString:@""]) {
        NSLog(@"%@ 索引不可以为空", [self class]);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX idx_%@ ON %@(%@)",indexName, NSStringFromClass([self class]), indexName];
    
    return [self executeUpdate:sql];
}


#pragma mark -
#pragma mark SQL Handle Methods

/**
 *  通过线程池操作数据库
 */
- (void)inDatabase:(void (^)(FMDatabase *))block
{
    [[ABCDataBase sharedDataBase] inDatabase:^(FMDatabase *db) {
        block(db);
    }];
}

/**
 *  SQL 查找数据库内容
 */
va_list args_query;
- (FMResultSet *)executeQuery:(NSString *)sql, ...
{
    va_start(args_query, sql);
    
    __block FMResultSet *set = nil;
    [self inDatabase:^(FMDatabase *db) {
        set = [db executeQuery:sql, args_query];
    }];
    
    va_end(args_query);
    return set;
}

/**
 *  SQL 数据库基本操作
 */
va_list args_update;
- (BOOL)executeUpdate:(NSString *)sql, ...
{
    va_start(args_update, sql);
    
    __block BOOL success;
    [self inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql,args_update];
    }];
    
    va_end(args_update);
    return success;
}

- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments
{
    __block BOOL success;
    
    [self inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql withParameterDictionary:arguments];
    }];
    
    return success;
}


#pragma mark - SQL Helper

- (NSArray *)transformResult:(FMResultSet *)result
{
    NSMutableArray *array = [NSMutableArray array];
    
    while ([result next]) {
        ABCCallBackModel *obj=[[[self class] alloc] init];
        NSDictionary *dictionary=[result resultDictionary];
        obj->abc_id = [[dictionary valueForKey:@"abc_id"] longValue];
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
                        
                        ((void(*)(id,SEL,id))objc_msgSend)(obj, selector,value);//调用set方法
                        
                    }else {
                        if (value==nil||[value isKindOfClass:[NSNull class]]) {
                            
                        }else{
                            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Value",type]);//判断该类中是否有对应的set方法
                            
                            if ([value respondsToSelector:sel]) {
                                if ([type isEqualToString:@"double"])
                                {
                                    
                                    ((void(*)(id, SEL, double))objc_msgSend)(obj, selector, [value doubleValue]);
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
                                    //
                                    //                                        IMP myImp = [obj methodForSelector:selector];
                                    //                                         myImp(obj,selector,[value floatValue]);
                                    //
                                    //                                        NSLog(@"%f",sid);
                                    //                                        IMP myImp1 = [obj methodForSelector:selector];
                                    //                                        myImp1(obj,selector,[NSNumber numberWithFloat:sid]);
                                }
                                else if([type isEqualToString:@"long"])
                                {
                                    long v = ((long(*)(id,SEL))objc_msgSend)(value, sel);
                                    
                                    ((void(*)(id,SEL,long))objc_msgSend)(obj, selector,v);
                                    
                                }else if ([type isEqualToString:@"int"])
                                {
                                    // 报错 需要修正类型回调
                                    int v = ((int(*)(id,SEL))objc_msgSend)(value, sel);
                                    ((void(*)(id,SEL,int))objc_msgSend)(obj, selector,v);
                                }else {
                                    
                                    int v = ((int(*)(id,SEL))objc_msgSend)(value, sel);
                                    ((void(*)(id,SEL,int))objc_msgSend)(obj, selector,v);
                                    
                                }//调用set方法
                            }else {
                                ((void(*)(id,SEL,id))objc_msgSend)(obj, selector,@"");//调用set方法
                            }
                            
                        }
                    }
                    
                }
                @catch (NSException * e) {
                    
                }
                @finally {
                    
                }
            }
        }
        
        if (obj)
        {
            [array addObject:obj];
        }
    }
    return array;
}

-(NSString*) getType:(NSObject*) bean property:(NSString*) field{
    objc_property_t property = class_getProperty([bean class], [field cStringUsingEncoding:NSUTF8StringEncoding]);
    NSString *proty=[NSString stringWithFormat:@"%s",property_getAttributes(property)]; //字段的属性
    NSString *name=[NSString stringWithFormat:@"%s",property_getName(property)];        //字段的名称
    
    if ([name isEqualToString:field]) {
        NSString *class_type=[proty substringToIndex:2];
        if ([class_type isEqualToString:@"Tl"] ||
            [class_type isEqualToString:@"Tq"]) {														// long类型字段
            return @"long";
        }else if ([class_type isEqualToString:@"T@"]) {
            if ([proty length]>12 && [[proty substringToIndex:12] isEqualToString:@"T@\"NSString\""]) { // NSString 类型字段
                return @"string";
            }
        }else if ([class_type isEqualToString:@"Ti"]) {														// long类型字段
            return @"int";
        }else if ([class_type isEqualToString:@"Tf"])
        {
            return @"float";
        }
        else if([class_type isEqualToString:@"Td"])
        {
            return @"double";
        }
        else if ([class_type isEqualToString:@"Tc"])
        {
            return  @"bool";
        }
        
    }
    
    return @"";
}

@end
