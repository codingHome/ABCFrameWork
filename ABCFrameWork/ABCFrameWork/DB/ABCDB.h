//
//  ABCDB.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/22.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	查询成功的block
 *
 *	@param 	 	查询结果
 */
typedef void(^QueryResultBlock)(NSArray *results);

@interface ABCDB : NSObject

/**
 *	@brief	当前数据库路径
 */
@property (nonatomic, strong) NSString      *dbPath;

/**
 *	@brief	设置数据库密码
 */
@property (nonatomic, strong) NSString      *password;

/**
 *	@brief	单例
 */
+ (ABCDB *)sharedDB;

#pragma mark - 库文件
/**
 *	@brief	初始化数据库
 *
 *	@param 	dbPath 	数据库路径
 */
- (void)initDBPath:(NSString *)dbPath;

/**
 *	@brief	销毁数据库
 *
 *	@param 	dbPath 	数据库路径
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)destroyDBPath:(NSString *)dbPath;

#pragma mark - 表操作
/**
 *	@brief	创建表
 *
 *	@param 	myClass 	类
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)createTable:(Class)myClass;

/**
 *	@brief	删除表
 *
 *	@param 	myClass 	类
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)dropTable:(Class)myClass;

/**
 *	@brief	检测一个表是否存在
 *
 *	@param 	className 	表名
 *
 *	@return	YES 为存在 NO为不存在
 */
- (BOOL)checkTableIsExist:(NSString *)className;

#pragma mark - 插入
/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	dictionary 	数据字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass dictionary:(NSDictionary *)dictionary;

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	myObject 	对象
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass object:(NSObject *)myObject;

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	array 	数据字典数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass dictArray:(NSArray *)array;

/**
 *	@brief	插入表数据
 *
 *	@param 	myClass 	类
 *	@param 	objectArray 	对象数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)insertTable:(Class)myClass objectArray:(NSArray *)objectArray;

#pragma mark - 更新
/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	dictionary  数据字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass dictionary:(NSDictionary *)dictionary;
/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	myObject  对象
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass object:(NSObject *)myObject;
/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	array  数据数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass dictArray:(NSArray *)array;
/**
 *	@brief	更新表数据 根据主键id更新
 *
 *	@param 	myClass 	类
 *	@param 	objectArray  对象数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)updateTable:(Class)myClass objectArray:(NSArray *)objectArray;

#pragma mark - 查询
/**
 *	@brief	查询表数据条数
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *
 */
- (NSInteger)queryCountFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args;

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryObjectFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order resultBlock:(QueryResultBlock)resultBlock;

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
-(NSArray *)queryObjectFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order;

/**
 *	@brief	查询表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件 eg:@"name=?"
 *	@param 	args 	条件的值  eg:["张三"]
 *	@param 	order 	排序    eg:@"date desc"
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryDictionaryFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order resultBlock:(QueryResultBlock)resultBlock;

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
-(NSArray *)queryDictionaryFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args order:(NSString*)order;

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	要查的页数
 *	@param 	pageSize 	每页的条数
 *	@param 	order 	排序
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order  resultBlock:(QueryResultBlock)resultBlock;

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
-(NSArray *)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order;

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
-(void)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args offSet:(NSInteger)offSet pageSize:(NSInteger)pageSize order:(NSString*)order  resultBlock:(QueryResultBlock)resultBlock;

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
-(NSArray *)queryObjectWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args offSet:(NSInteger)offSet pageSize:(NSInteger)pageSize order:(NSString*)order;

/**
 *	@brief	分页查询
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *	@param 	pageNumber 	页数
 *	@param 	pageSize 	条数
 *	@param 	order 	排序
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryDictionaryWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order  resultBlock:(QueryResultBlock)resultBlock;

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
-(NSArray *)queryDictionaryWithPageFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize order:(NSString*)order;

/**
 *	@brief	删除表数据
 *
 *	@param 	myClass 	类
 *	@param 	conditions 	条件
 *	@param 	args 	值
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL)deleteFromTable:(Class)myClass conditions:(NSString*)conditions args:(NSArray*)args;


/**
 *	@brief	执行查询sql,此方法不在队列里面
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件值数组
 *  @param  resultBlock 查询结果的block
 *
 */
-(void)queryWithSql:(NSString*)sql args:(NSArray*)args resultBlock:(QueryResultBlock)resultBlock;

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件值数组
 *
 *  @return 查询数组
 */
- (NSArray *)queryInQueueWithSql:(NSString *)sql args:(NSArray *)args;

/**
 *	@brief	执行查询sql
 *
 *	@param 	sql 	sql语句
 *
 *  @return 查询数组
 */
- (NSArray *)queryInQueueWithSql:(NSString *)sql;

/**
 *	@brief	执行sql语句
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件字典
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL) executeWithSql:(NSString*)sql args:(NSDictionary*)args;

/**
 *	@brief	执行sql语句
 *
 *	@param 	sql 	sql语句
 *	@param 	args 	条件数组
 *
 *	@return	成功 YES 失败 NO
 */
-(BOOL) executeWithSql:(NSString*)sql arrayArgs:(NSArray*)args;

- (void)beginTransaction;

- (void)endTransaction;

@end
