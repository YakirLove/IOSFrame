//
//  NDDatabaseManage.m
//  ios数据库管理工具类
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDatabaseUtils.h"
#import "NDDataBaseModel.h"
#import "NDQueryCondition.h"
#import "NDOrderCondition.h"
#import "NDTableManageModel.h"
#import <objc/runtime.h>
#import "FMDataBase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase+Category.h"
#import "FMDatabaseQueue+Category.h"

#if ND_NEED_SQL
#define SQL_LOG NSLog     //输出sql日志
#else
#define SQL_LOG(...) {}        //不输出sql日志
#endif

@interface NDDatabaseManager(Private)
+ (NSString *)getDocumentsDirectory;
+ (NSString *)getDatabaseFilePath:(NSString *)pszFileName;
@end

@implementation NDDatabaseManager

#pragma mark 获取app document的物理路径
+ (NSString *)getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory=%@",documentsDirectory);
    return documentsDirectory;
}

#pragma mark 获取app db文件 存放的物理路径
+ (NSString *)getDatabaseFilePath:(NSString *)pszFileName
{
    return [[NDDatabaseManager getDocumentsDirectory] stringByAppendingPathComponent:pszFileName];
}

@end


@interface NDDatabaseUtils(){
    FMDatabaseQueue *queue;
    FMDatabase *fmdb;
    dispatch_queue_t dispatchQueue;
}

@end

@implementation NDDatabaseUtils

#pragma mark 初始化
- (id)init:(NSString *)dbName
{
    if(self = [super init]){
        isOpenDB = FALSE;
        self.dbName = dbName;
        fmdb = [FMDatabase databaseWithPath:[NDDatabaseManager getDatabaseFilePath:[NSString stringWithFormat:@"%@.sqlite",dbName]]];
        queue = [FMDatabaseQueue databaseQueueWithPath:[NDDatabaseManager getDatabaseFilePath:[NSString stringWithFormat:@"%@.sqlite",dbName]]];
        dispatchQueue = dispatch_queue_create([[NSString stringWithFormat:@"queue_%@",self.dbName] UTF8String], NULL);
    }
    return self;
}


+(NDDatabaseUtils *) getInstance
{
    return [NDDatabaseUtils getInstance:ND_DB_FILE_NANE];
}

#pragma mark 获得工具类实例
+(NDDatabaseUtils *)getInstance:(NSString *)dbName
{
    static NSMutableDictionary *utilDict;
    
    @synchronized(self)
    {
        if (utilDict == nil) {
            utilDict = [[NSMutableDictionary alloc] init];
        }
    }
    
    NDDatabaseUtils *sharedSingleton = nil;
    @synchronized(utilDict){
        if ([[utilDict allKeys] containsObject:dbName] == NO) {
            sharedSingleton = [[NDDatabaseUtils alloc] init:dbName];
            [sharedSingleton initTable];
            [utilDict setObject:sharedSingleton forKey:dbName];
        }else{
            sharedSingleton = [utilDict objectForKey:dbName];
        }
    }
    
    return sharedSingleton;
}


//判断表是否存在
-(BOOL)isExistByTable: (NSString *)tableName{
    NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(*) as c FROM sqlite_master where type='table' and name='%@'",tableName];
    return [self count:sql] > 0;
}


#pragma mark 设置数据库密码
-(BOOL)setKey:(NSString *)key
{
    const void * bytes = [key UTF8String];
    NSData *keyData = [NSData dataWithBytes:bytes length:(NSInteger)strlen(bytes)];
    if(!keyData){
        return NO;
    }
    
    int rc = sqlite3_key([fmdb sqlite3], [keyData bytes], (int)[keyData length]);
    return rc == SQLITE_OK;
}

#pragma mark 打开指定数据库
-(void)initTable
{
    if ([fmdb open]) {
        
#if defined(__LOG_OUTPT__)
        SQL_LOG(@"open database success!");
#endif
        isOpenDB = YES;
        
        
        NSArray * modelClasses = [NDDataBaseModel allTableModels:self.dbName];
        if(modelClasses.count > 0)
        {
#if __has_feature(objc_arc)
            NDDataBaseModel *model = [[modelClasses[0] alloc] init];
#else
            NDDataBaseModel *model = [[[modelClasses[0] alloc] init] autorelease];
#endif
            if([self isExistByTable:[model tableName]]){
                if (!DB_NEED_ENCODE) {
                    [fmdb close];
                }
                return;
            }
        }
        
        //创建表结构
        NSMutableArray *createTableSqls = [[NSMutableArray alloc] init];
        NSMutableArray *createIndexSqls = [[NSMutableArray alloc] init];
        NDDataBaseModel *model = nil;
        NSMutableString *sql = nil;
        for (Class modelClass in modelClasses) {
            model = [[modelClass alloc] init];
            sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS "];
            [sql appendString:[NSString stringWithFormat:@"%@(",[model tableName]]]; //表名
            [sql appendString:[NSString stringWithFormat:@"%@ text PRIMARY KEY",[model idName]]]; //主键
            
            //找出相应类型
            unsigned int outCount, i;
            NSMutableDictionary *typeDict = [[NSMutableDictionary alloc] init];
            
            while (true) { //增加中间父类
                objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
                for (i=0; i<outCount; i++) {
                    objc_property_t property = properties[i];
                    NSString *typeKey = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                    if ([[model getAllColumnsName] containsObject:typeKey] == NO) {  //属性并非数据库的字段的话
                        continue;
                    }
                    NSString * tempValue = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
                    NSRange range = [tempValue rangeOfString:@"\""];
                    tempValue = [tempValue substringFromIndex:range.location+1];
                    range = [tempValue rangeOfString:@"\""];
                    NSString *typeValue = [tempValue substringToIndex:range.location];
                    [typeDict setObject:[NDDataFormat ocType2DBType:typeValue] forKey:typeKey];
                }
                modelClass = class_getSuperclass(modelClass);
                if(modelClass == nil || modelClass == [NDDataBaseModel class]){
                    break;
                }
            }
            
            for (NSString *column in [model getAllColumnsName]) {
                if([model.idName isEqualToString:column] == NO){ //非主键
                    [sql appendString:[NSString stringWithFormat:@",%@ %@",column,[typeDict objectForKey:column]]];
                }
            }
            [sql appendString:@");"];
            [createTableSqls addObject:sql];
            
            for (NSString *indexColumn in [model getAllIndexColumnsName]) {
                [createIndexSqls addObject:[NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS %@_index ON %@(%@);",indexColumn,model.tableName,indexColumn]];
            }
            
#if __has_feature(objc_arc)
            typeDict = nil;
            model = nil;
#else
            [typeDict release];
            [model release];
#endif
        }
        for (NSString *createTableSql in createTableSqls) {
            [fmdb executeUpdate:createTableSql]; //建表
        }
        [createTableSqls removeAllObjects];
        
        for (NSString *createIndexSql in createIndexSqls) {
            [fmdb executeUpdate:createIndexSql]; //建索引
        }
#if __has_feature(objc_arc)
        createTableSqls = nil;
        createIndexSqls = nil;
#else
        [createTableSqls release];
        [createIndexSqls release];
#endif
        
        NDTableManageModel *tempModel = nil;
        //初始化表索引 用来做自动递增操作
        NDTableManageModel *serviceModel = [[NDTableManageModel alloc] initWithUtils:self];
        for (Class modelClass in modelClasses) {
            model = [[modelClass alloc] init];
            tempModel = [[NDTableManageModel alloc] init];
            if([tempModel isKindOfClass:modelClass] == NO){ //普通table 不是tableMange
                tempModel.userTableName = [model tableName];
                tempModel.idIndex = @"0";
                [serviceModel saveModel:tempModel];
            }
#if __has_feature(objc_arc)
            model = nil;
            tempModel = nil;
#else
            [model release];
            [tempModel release];
#endif
        }
        
        if (!DB_NEED_ENCODE) {
            [fmdb close];
        }
    }
}


#pragma mark 添加字段
//sqlite 类型有
//NULL. 空值
//INTEGER. 整型
//REAL.浮点型
//TEXT.文本类型(常用)
//BLOB. 二进制类型，用来存储文件，比如图片
-(void)addColumn:(NSString *)col intoTable:(NSString *)table type:(NSString *)type
{
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",table,col,type];
    [self executeUpdateSQLCommand:sql];
}



#pragma mark 判断某个字段是否已经存在  可用于动态改变表结构的时候进行字段存在性判断
-(BOOL)validateColIsExist:(NSString *)col intoTable:(NSString *)table
{
    if (DB_NEED_ENCODE || [fmdb open]) {
        NSString* sql = [NSString stringWithFormat:@"SELECT SQL FROM SQLITE_MASTER WHERE NAME = '%@'",table];
        FMResultSet * rs = [fmdb executeQuery:sql];
        NSString *title = @"";
        while ([rs next]) {
            title = [rs stringForColumn:@"SQL"];
            break;
        }
        [rs close];
        if (!DB_NEED_ENCODE) {
            [fmdb close];
        }
        
        NSRange range = [[title uppercaseString] rangeOfString:[col uppercaseString]];
        return range.location != NSNotFound;
    }
    return YES;
}

#pragma mark 将数据插入到某张表
-(void)saveData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName keyName:(NSString *)keyName isAutoincrement:(BOOL)isAutoincrement block:(void (^)(void))block
{
    //独立线程调用
    dispatch_async(dispatchQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            [self executeSave:dataDict tableName:tableName keyName:keyName isAutoincrement:isAutoincrement db:db];
            block();
        }];
    });
}

#pragma mark 将数据插入到某张表
-(void)saveData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName keyName:(NSString *)keyName isAutoincrement:(BOOL)isAutoincrement
{
    [self executeSave:dataDict tableName:tableName keyName:keyName isAutoincrement:isAutoincrement db:fmdb];
}

-(void)executeSave:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName keyName:(NSString *)keyName isAutoincrement:(BOOL)isAutoincrement db:(FMDatabase *)db
{
    if (DB_NEED_ENCODE || [db open]) {
        if (isAutoincrement) {
            FMResultSet *resultSet = [db executeQuery:@"SELECT idIndex FROM TableManage WHERE userTableName = ?",tableName];
            if (resultSet.next) {
                long long index = [[resultSet stringForColumn:@"idIndex"] longLongValue];
                NSString *newIndex = [NSString stringWithFormat:@"%lld",index + 1];
                [dataDict setObject:newIndex forKey:keyName];
                [db executeUpdate:@"UPDATE TableManage SET idIndex = ? WHERE userTableName = ?",newIndex,tableName];
            }
            [resultSet close];
        }
        
        //构造insert的sql语句
        NSMutableString *sql = [[NSMutableString alloc ] init];
        [sql appendString:@"INSERT INTO "];
        [sql appendString:tableName];
        [sql appendString:@" ("];
        NSMutableString *var = [[NSMutableString alloc ] init];
        for (int i = 0 ; i < dataDict.allKeys.count ; i++) {
            if(i != 0){
                [sql appendString:@","];
                [var appendString:@","];
            }
            [sql appendString:dataDict.allKeys[i]];
            [var appendString:@"?"];
        }
        [sql appendString:@") VALUES("];
        [sql appendString:var];
        [sql appendString:@")"];
        SQL_LOG(@"insert sql : %@",sql);
        NSMutableString *params =   [[NSMutableString alloc ] init];
        [params appendString:@"params is :"];
        NSMutableArray *paramArray = [[NSMutableArray alloc] init];
        NSObject *temp = nil;
        for (int i = 0;  i < dataDict.allKeys.count ; i++) {
            temp = [dataDict objectForKey:dataDict.allKeys[i]];
            [paramArray addObject:[self dataTypeAdapt:temp]];
            [params appendString:[NSString stringWithFormat:@"[%@] ",temp]];
        }
        
        [db executeUpdate:sql withArgumentsInArray:paramArray];
        
        if (!DB_NEED_ENCODE) {
            [db close];
        }
        
        SQL_LOG(@"%@",params);
#if __has_feature(objc_arc)
#else
        [sql release];
        [var release];
        [params release];
        [paramArray release];
#endif
    }
}

#pragma mark 类型适配
-(NSObject *)dataTypeAdapt:(NSObject *)obj
{
    if([obj isKindOfClass:[NSString class]]){
        return obj;
    }else if([obj isKindOfClass:[NDBool class]]){
        return [NSNumber numberWithInt:[(NDBool *)obj intValue]];
    }else if([obj isKindOfClass:[NDDouble class]]){
        return [NSNumber numberWithDouble:[(NDDouble *)obj doubleValue]];
    }else if([obj isKindOfClass:[NDInteger class]]){
        return [NSNumber numberWithInt:[(NDInteger *)obj intValue]];
    }else if([obj isKindOfClass:[NDLong class]]){
        return [NSNumber numberWithLongLong:[(NDLong *)obj longValue]];
    }else if([obj isKindOfClass:[NSDate class]]){
        NSString *tempString = [NDDataFormat dateToString:(NSDate *)obj];
        return [NSNumber numberWithLongLong:[[NDDataFormat stringToLong:tempString] longValue]];
    }else if([obj isKindOfClass:[NDDataBaseModel class]]){
        return [(NDDataBaseModel *)obj idValue];
    }
    return obj;
}

-(void)executeUpdate:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName conditions:(NSArray *)conditions db:(FMDatabase *)db
{
    
    //构造update的sql语句
    NSMutableString *sql = [[NSMutableString  alloc] init];
    [sql appendString:@"UPDATE "];
    [sql appendString:tableName];
    [sql appendString:@" SET "]; //stringWithFormat:@"UPDATE %@ SET  ",tableName];
    for (int i = 0 ; i < dataDict.allKeys.count ; i++) {
        if(i != 0){
            [sql appendString:@","];
        }
        [sql appendString:dataDict.allKeys[i]];
        [sql appendString:@" = ? "];
    }
    
    if(conditions != nil && conditions.count > 0){
        [sql appendString:@" WHERE "];
        NDQueryCondition *condition = nil;
        for ( int i = 0 ; i < conditions.count ; i++) {
            condition = conditions[i];
            if(i > 0){
                [sql appendString:@" AND "];
            }
            [sql appendString:[condition description]];
        }
    }
    
    SQL_LOG(@"update sql : %@",sql);
    
    
    NSObject *temp = nil;
    
    NSMutableArray *paramArray = [[NSMutableArray alloc] init];
    NSMutableString *params =  [[NSMutableString  alloc] init];
    [params appendString:@"params is :"];
    for (int i = 0;  i < dataDict.allKeys.count ; i++) {
        temp = [dataDict objectForKey:dataDict.allKeys[i]];
        [paramArray addObject:[self dataTypeAdapt:temp]];
        [params appendString:[NSString stringWithFormat:@"[%@] ",temp]];
    }
    
    if (DB_NEED_ENCODE || [db open]) {
        [db executeUpdate:sql withArgumentsInArray:paramArray];
        
        if (!DB_NEED_ENCODE) {
            [db close];
        }
    }
    
    SQL_LOG(@"%@",params);
#if __has_feature(objc_arc)
#else
    [sql release];
    [paramArray release];
    [params release];
#endif
}

#pragma mark 将数据更新到某张表
-(void)updateData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName conditions:(NSArray *)conditions
{
    [self executeUpdate:dataDict tableName:tableName conditions:conditions db:fmdb];
}

#pragma mark 将数据更新到某张表
-(void)updateData:(NSMutableDictionary *)dataDict tableName:(NSString *)tableName conditions:(NSArray *)conditions block:(void (^)(void))block
{
    dispatch_async(dispatchQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            [self executeUpdate:dataDict tableName:tableName conditions:conditions db:db];
            block();
        }];
    });
}

#pragma mark 数据查询
-(NSMutableArray *)executeQuery:(NSString *)tableName columns:(NSArray *)columns conditions:(NSArray *)conditions orders:(NSArray *)orders limitCondition:(NDLimitCondition *)limitCondition groupConditions:(NSArray *)groupConditions db:(FMDatabase *)db
{
#if __has_feature(objc_arc)
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
#else
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
#endif
    
    NSMutableString* sql = [NSMutableString stringWithFormat:@"SELECT  "];
    for (int i = 0; i<columns.count; i++) {
        if(i != 0){
            [sql appendString:@","];
        }
        [sql appendString:columns[i]];
    }
    [sql appendString:[NSString stringWithFormat:@" FROM %@" ,tableName]];
    if(conditions != nil && conditions.count > 0){
        [sql appendString:@" WHERE "];
        NDQueryCondition *condition = nil;
        for ( int i = 0 ; i < conditions.count ; i++) {
            condition = conditions[i];
            if(i > 0){
                [sql appendString:@" AND "];
            }
            [sql appendString:[condition description]];
        }
    }
    //分组条件
    if(groupConditions != nil && groupConditions.count > 0){
        [sql appendString:@" GROUP BY "];
        NDGroupCondition *group = nil;
        for ( int i = 0 ; i < groupConditions.count ; i++) {
            group = groupConditions[i];
            if(i > 0){
                [sql appendString:@" , "];
            }
            [sql appendString:[group description]];
        }
    }
    //排序条件
    if(orders != nil && orders.count > 0){
        [sql appendString:@" ORDER BY "];
        NDQueryCondition *order = nil;
        for ( int i = 0 ; i < orders.count ; i++) {
            order = orders[i];
            if(i > 0){
                [sql appendString:@" , "];
            }
            [sql appendString:[order description]];
        }
    }
    //起始位置，限制条数
    if(limitCondition != nil){
        [sql appendString:[limitCondition description]];
    }
    SQL_LOG(@"select sql : %@",sql);
    
    if (DB_NEED_ENCODE || [db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (NSString *colName in columns) {
                [dict setObject:[rs stringForColumn:colName] == nil ?@"":[rs stringForColumn:colName] forKey:colName];
            }
            [result addObject:dict];
#if __has_feature(objc_arc)
            dict = nil;
#else
            [dict release];
#endif
        }
        [rs close];
        if (!DB_NEED_ENCODE) {
            [db close];
        }
        
    }
    return result;
}

//
//#pragma mark 查询所有数据
-(NSMutableArray *)getDatas:(NSString *)tableName columns:(NSArray *)columns conditions:(NSArray *)conditions orders:(NSArray *)orders limitCondition:(NDLimitCondition *)limitCondition groupConditions:(NSArray *)groupConditions
{
    return [self executeQuery:tableName columns:columns conditions:conditions orders:orders limitCondition:limitCondition groupConditions:groupConditions db:fmdb];
}


-(void)getDatas:(NSString *)tableName columns:(NSArray *)columns conditions:(NSArray *)conditions orders:(NSArray *)orders limitCondition:(NDLimitCondition *)limitCondition groupConditions:(NSArray *)groupConditions block:(void (^)(NSMutableArray *result))block
{
    //独立线程调用
    dispatch_async(dispatchQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            block([self executeQuery:tableName columns:columns conditions:conditions orders:orders limitCondition:limitCondition groupConditions:groupConditions db:db]);
        }];
    });
}



#pragma mark 根据sql 查询
-(NSMutableArray *)executeQuery:(NSString *)sql db:(FMDatabase *)db
{
#if __has_feature(objc_arc)
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
#else
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
#endif
    SQL_LOG(@"select sql : %@",sql);
    
    if (DB_NEED_ENCODE || [db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 0; i < [rs columnCount] ; i++) {
                [arr addObject:[rs stringForColumnIndex:i] == nil ? @"":[rs stringForColumnIndex:i]];
            }
            [result addObject:arr];
#if __has_feature(objc_arc)
            arr = nil;
#else
            [arr release];
#endif
        }
        [rs close];
        if (!DB_NEED_ENCODE) {
            [db close];
        }
        
    }
    return result;
}

#pragma mark 根据sql 查询
-(NSMutableArray *)getDatas:(NSString *)sql
{
    return [self executeQuery:sql db:fmdb];
}

#pragma mark 根据sql 查询
-(void)getDatas:(NSString *)sql block:(void (^)(NSMutableArray *result))block
{
    //独立线程调用
    dispatch_async(dispatchQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            block([self executeQuery:sql db:db]);
        }];
    });
}

-(void)executeDelete:(NSString *)tableName conditions:(NSArray *)conditions limitCondition:(NDLimitCondition *)limitCondition db:(FMDatabase *)db
{
    NSMutableString *sql=[NSMutableString stringWithFormat:@"DELETE FROM %@",tableName];
    if(conditions != nil && conditions.count > 0){
        [sql appendString:@" WHERE "];
        NDQueryCondition *condition = nil;
        for ( int i = 0 ; i < conditions.count ; i++) {
            condition = conditions[i];
            if(i > 0){
                [sql appendString:@" AND "];
            }
            [sql appendString:[condition description]];
        }
    }
    
    //起始位置，限制条数
    if(limitCondition != nil){
        [sql appendString:[NSString stringWithFormat:@" where rowid in (select rowid from %@ limit %d) ",tableName,limitCondition.count]];
    }
    SQL_LOG(@"delete sql : %@",sql);
    
    if (DB_NEED_ENCODE || [db open]) {
        [db executeUpdate:sql];
        if (!DB_NEED_ENCODE) {
            [db close];
        }
    }
}

#pragma mark 将数据从某张表中删除
-(void)deleteDatas:(NSString *)tableName conditions:(NSArray *)conditions limitCondition:(NDLimitCondition *)limitCondition
{
    [self executeDelete:tableName conditions:conditions limitCondition:limitCondition db:fmdb];
}

#pragma mark 将数据从某张表中删除
-(void)deleteDatas:(NSString *)tableName conditions:(NSArray *)conditions  limitCondition:(NDLimitCondition *)limitCondition block:(void (^)(void))block
{
    dispatch_async(dispatchQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            [self executeDelete:tableName conditions:conditions limitCondition:limitCondition db:db];
        }];
    });
}

#pragma mark 计算条数
-(int)count:(NSString *)tableName conditions:(NSArray *)conditions
{
    NSMutableString* sql = [NSMutableString stringWithFormat:@"SELECT COUNT(*) AS c FROM %@",tableName];
    if(conditions != nil && conditions.count > 0){
        [sql appendString:@" WHERE "];
        NDQueryCondition *condition = nil;
        for ( int i = 0 ; i < conditions.count ; i++) {
            condition = conditions[i];
            if(i > 0){
                [sql appendString:@" AND "];
            }
            [sql appendString:[condition description]];
        }
    }
    int result = 0;
    SQL_LOG(@"count sql : %@",sql);
    if (DB_NEED_ENCODE || [fmdb open]) {
        FMResultSet *rs = [fmdb executeQuery:sql];
        while ([rs next]) {
            result = [rs intForColumn:@"c"];
        }
        [rs close];
        
        if (!DB_NEED_ENCODE) {
            [fmdb close];
        }
        
    }
    
    return result;
}



-(NSInteger)count:(NSString *)sql
{
    FMResultSet * rs = [fmdb executeQuery:sql];
    int result = 0;
    while ([rs next]) {
        result = [rs intForColumn:@"c"];
        break;
    }
    [rs close];
    return result;
}



#pragma mark  执行sql更新语句
-(BOOL)executeUpdateSQLCommand:(NSString *)command
{
    if (DB_NEED_ENCODE || [fmdb open]) {
        [fmdb executeUpdate:command];
        if (!DB_NEED_ENCODE) {
            [fmdb close];
        }
        
    }
    return NO;
}



-(void)dealloc
{
    
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}

@end
