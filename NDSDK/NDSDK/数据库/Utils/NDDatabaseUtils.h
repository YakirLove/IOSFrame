//
//  NDDatabaseManage.h
//  ios数据库管理工具类
//  使用需加入 libsqlite3.0.dylib
//  Created by 陈蜂 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NDLimitCondition.h"


#pragma mark - 数据库管理类
@interface NDDatabaseManager : NSObject

@end


#pragma mark - 数据库工具类
@interface NDDatabaseUtils : NSObject {
    BOOL isOpenDB;  //数据库是否打开
}

@property(copy,nonatomic)NSString *dbName;

#pragma mark 获得工具类实例
+(NDDatabaseUtils *)getInstance:(NSString *)dbName;

#pragma mark 获得工具类实例
+(NDDatabaseUtils *)getInstance;

#pragma mark 将数据插入到某张表
-(void)saveData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName keyName:(NSString *)keyName isAutoincrement:(BOOL)isAutoincrement;

#pragma mark 将数据插入到某张表
-(void)saveData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName keyName:(NSString *)keyName isAutoincrement:(BOOL)isAutoincrement block:(void (^)(void))block;

#pragma mark 将数据更新到某张表
-(void)updateData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName conditions:(NSArray *)conditions;

#pragma mark 将数据更新到某张表
-(void)updateData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName conditions:(NSArray *)conditions block:(void (^)(void))block;

#pragma mark 删除数据
-(void)deleteDatas:(NSString *)tableName conditions:(NSArray *)conditions  limitCondition:(NDLimitCondition *)limitCondition block:(void (^)(void))block;

#pragma mark 删除数据
-(void)deleteDatas:(NSString *)tableName conditions:(NSArray *)conditions  limitCondition:(NDLimitCondition *)limitCondition;

#pragma mark 查询所有数据 +查询条件 +排序规则
-(NSMutableArray *)getDatas:(NSString *)tableName columns:(NSArray *)columns conditions:(NSArray *)conditions orders:(NSArray *)orders limitCondition:(NDLimitCondition *)limitCondition groupConditions:(NSArray *)groupConditions;

#pragma mark 查询所有数据 +查询条件 +排序规则
-(void)getDatas:(NSString *)tableName columns:(NSArray *)columns conditions:(NSArray *)conditions orders:(NSArray *)orders limitCondition:(NDLimitCondition *)limitCondition groupConditions:(NSArray *)groupConditions block:(void (^)(NSMutableArray *result))block;

#pragma mark 根据sql 查询
-(void)getDatas:(NSString *)sql block:(void (^)(NSMutableArray *result))block;

#pragma mark 根据sql 查询
-(NSMutableArray *)getDatas:(NSString *)sql;

#pragma mark 计算条数
-(int)count:(NSString *)tableName conditions:(NSArray *)conditions;

#pragma mark  执行sql更新语句
-(BOOL)executeUpdateSQLCommand:(NSString *)command;

#pragma mark 判断某个字段是否已经存在  可用于动态改变表结构的时候进行字段存在性判断
-(BOOL)validateColIsExist:(NSString *)col intoTable:(NSString *)table;

#pragma mark 增加字段
-(void)addColumn:(NSString *)col intoTable:(NSString *)table type:(NSString *)type;

@end




