//
//  NDDataBaseModel.m
//  数据库表对象基础夫类
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDataBaseModel.h"
#import "NDCommonFunc.h"
#import <objc/runtime.h>
#import "NDTableManageModel.h"

@implementation NDDataBaseModel

@synthesize conditionArray;
@synthesize orderArray;
@synthesize limitCondition;
@synthesize groupArray;

-(id)initWithUtils:(NDDatabaseUtils *)utils
{
    self = [super init];
    if (self) {
        self.utils = utils;
    }
    return self;
}

#pragma mark 获取所有table model的class  用于生成建表语句
+(NSArray *)allTableModels
{
    return [NDDataBaseModel allTableModels:ND_DB_FILE_NANE];
}

#pragma mark 获取所有table model的class  用于生成建表语句
+(NSArray *)allTableModels:(NSString *)dbName
{
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DBMappingTable.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:defaultPath];
    NSArray *classNames = nil;
    for (NSString *key in dict.allKeys) {
        if([dbName hasPrefix:key]){
            classNames = [dict objectForKey:key];
            break;
        }
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[NDTableManageModel class]];
    for (NSString *className in classNames) {
        [result addObject:NSClassFromString(className)];
    }
    return result;
}

#pragma mark 表名  子类重写
-(NSString *)tableName
{
    return @"";
}

#pragma mark 主键名称  子类重写
-(NSString *)idName
{
    return @"";
}

#pragma mark 主键值  子类重写
-(NSString *)idValue
{
    return @"";
}

#pragma mark 保存model到数据库中
-(void)saveToDatabase
{
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [_utils saveData:dict tableName:[self tableName] keyName:self.idName isAutoincrement:self.isAutoincrement];
    [dict removeAllObjects];
}

#pragma mark 保存model到数据库中
-(void)saveToDatabase:(void (^)(void))callback;
{
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [_utils saveData:dict tableName:[self tableName] keyName:self.idName isAutoincrement:self.isAutoincrement block:^{
        [dict removeAllObjects];
        callback();
    }];
}


#pragma mark 保存model到数据库中
-(void)saveModel:(NDDataBaseModel *)model callback:(void (^)(void))callback
{
    model.utils = self.utils;
    [model saveToDatabase:^{
        model.utils = nil;
        callback();
    }];
}

#pragma mark 保存model到数据库中
-(void)saveModel:(NDDataBaseModel *)model
{
    model.utils = self.utils;
    [model saveToDatabase];
    model.utils = nil;
}

#pragma mark 从数据库中删除
-(void)deleteFromDatabase
{
    NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:[self idName] value:[self idValue] oper:ND_OPER_EQ];
    [_utils deleteDatas:[self tableName] conditions:[NSArray arrayWithObject:condition] limitCondition:limitCondition];
#if __has_feature(objc_arc)
    condition = nil;
#else
    [condition release];
#endif
}

#pragma mark 从数据库中删除
-(void)deleteFromDatabase:(void (^)(void))callback
{
    __block NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:[self idName] value:[self idValue] oper:ND_OPER_EQ];
    [_utils deleteDatas:[self tableName] conditions:[NSArray arrayWithObject:condition] limitCondition:limitCondition block:^{
        
        callback();
#if __has_feature(objc_arc)
        condition = nil;
#else
        [condition release];
#endif
    }];

}

#pragma mark 从数据库中删除
-(void)deleteModel:(NDDataBaseModel *)model
{
    model.utils = self.utils;
    [model deleteFromDatabase];
    model.utils = nil;
}

#pragma mark 从数据库中删除
-(void)deleteModel:(NDDataBaseModel *)model callback:(void (^)(void))callback
{
    model.utils = self.utils;
    [model deleteFromDatabase:^{
        model.utils = nil;
        callback();
    }];
}

#pragma mark 将列值跟列名转成Dictionary
-(NSMutableDictionary *)columnsNameAndValue
{
    NSMutableDictionary * dict = [self modelToDict];
    for (NSString * columnName in dict.allKeys) {
        if([self valueForKey:columnName] != nil){
            NSString *columnValue = [dict valueForKey:columnName] ;
#if  ND_NEED_ENCODE
            if([[self getAllEncodeColumnsName] containsObject:columnName]){ //能加密的必须是nsstring型的
                [dict setObject:[NDCommonFunc base64StringFromText:columnValue] forKey:columnName];
            }else{
                [dict setObject:columnValue forKey:columnName];
            }
#else
            [dict setObject:columnValue forKey:columnName];
#endif
        }
    }
    return dict;
}

#pragma mark 更新对象 可加查询条件 不能更改 主键的值
-(void)updateModels
{
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [dict removeObjectForKey:[self idName]];
    [_utils updateData:dict tableName:[self tableName] conditions:[self conditionArray]];
    [dict removeAllObjects];
}

-(void)updateModels:(void (^)(void))callback
{
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [dict removeObjectForKey:[self idName]];
    [_utils updateData:dict tableName:[self tableName] conditions:[self conditionArray] block:^{
        [dict removeAllObjects];
        callback();
    }];
}

#pragma mark 更新
-(void)updateInDatabase
{
    NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:[self idName] value:[self idValue] oper:ND_OPER_EQ];
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [_utils updateData:dict tableName:[self tableName] conditions:[NSArray arrayWithObject:condition]];
    [dict removeAllObjects];
#if __has_feature(objc_arc)
    condition = nil;
#else
    [condition release];
#endif
}

-(void)updateInDatabase:(void (^)(void))callback
{
    __block NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:[self idName] value:[self idValue] oper:ND_OPER_EQ];
    NSMutableDictionary *dict = [self columnsNameAndValue];
    [_utils updateData:dict tableName:[self tableName] conditions:[NSArray arrayWithObject:condition] block:^{
        [dict removeAllObjects];
#if __has_feature(objc_arc)
        condition = nil;
#else
        [condition release];
#endif
    }];
}

#pragma mark 更新
-(void)updateModel:(NDDataBaseModel *)model
{
    model.utils = self.utils;
    [model updateInDatabase];
    model.utils = nil;
}

#pragma mark 更新
-(void)updateModel:(NDDataBaseModel *)model callback:(void (^)(void))callback
{
    model.utils = self.utils;
    [model updateInDatabase:^{
        model.utils = nil;
        callback();
    }];
}

#pragma mark 获取对象 可加查询条件
-(NSArray *)getModels
{
    NSMutableArray * dictArray = [_utils getDatas:[self tableName] columns:[self getAllColumnsName] conditions:[self conditionArray] orders:self.orderArray limitCondition:self.limitCondition groupConditions:self.groupArray];
#if __has_feature(objc_arc)
    NSMutableArray *result = [[NSMutableArray alloc] init];
#else
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
#endif
    
    id model = nil;
    for (NSDictionary *dict in dictArray) {
#if  ND_NEED_ENCODE
        for (NSString* columnName in dict.allKeys) {
            if([[self getAllEncodeColumnsName] containsObject:columnName]){ //解密
                [dict setValue:[NDCommonFunc textFromBase64String:[dict objectForKey:columnName]] forKey:columnName];
            }
        }
#endif
        model = [self dictToModel:dict];
        if(model != nil){
            [result addObject:model];
        }
    }
    return result;
}


-(void)getModels:(void (^)(NSArray *result))callback
{
    [_utils getDatas:[self tableName] columns:[self getAllColumnsName] conditions:[self conditionArray] orders:self.orderArray limitCondition:self.limitCondition groupConditions:self.groupArray block:^(NSArray *dictArray) {
        
#if __has_feature(objc_arc)
        NSMutableArray *result = [[NSMutableArray alloc] init];
#else
        NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
#endif
        
        id model = nil;
        for (NSDictionary *dict in dictArray) {
#if  ND_NEED_ENCODE
            for (NSString* columnName in dict.allKeys) {
                if([[self getAllEncodeColumnsName] containsObject:columnName]){ //解密
                    [dict setValue:[NDCommonFunc textFromBase64String:[dict objectForKey:columnName]] forKey:columnName];
                }
            }
#endif
            model = [self dictToModel:dict];
            if(model != nil){
                [result addObject:model];
            }
        }
        callback(result);
    }];
}


-(NSArray *)getDictModels
{
#if __has_feature(objc_arc)
    NSMutableArray *result = [[NSMutableArray alloc] init];
#else
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
#endif
    
    NSArray *temp = [self getModels];
    for (NDDataBaseModel *model in temp) {
        [result addObject:[model toDictionary]];
    }
    
    return result;
}

#pragma mark 获取Dictionary对象 可加查询条件
-(void)getDictModels:(void (^)(NSArray *result))callback
{
    [self getModels:^(NSArray *temp) {
#if __has_feature(objc_arc)
        NSMutableArray *result = [[NSMutableArray alloc] init];
#else
        NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
#endif
        for (NDDataBaseModel *model in temp) {
            [result addObject:[model toDictionary]];
        }
        callback(result);
    }];
}

#pragma mark 删除对象 可加查询条件
-(void)deleteModels
{
    [_utils deleteDatas:[self tableName] conditions:[self conditionArray] limitCondition:limitCondition];
}


#pragma mark 删除对象 可加查询条件
-(void)deleteModels:(void (^)(void))callback
{
    [_utils deleteDatas:[self tableName] conditions:[self conditionArray] limitCondition:limitCondition block:^{
        callback();
    }];
}

#pragma mark 记录数
-(int)count
{
    int cnt = [_utils count:[self tableName] conditions:[self conditionArray]];
    return cnt;
}

#pragma mark 根据id获取对象
-(id)getModelById:(NSString *)idValue
{
    NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:[self idName] value:idValue oper:ND_OPER_EQ];
    NSMutableArray * dictArray = [_utils getDatas:[self tableName] columns:[self getAllColumnsName] conditions:[NSArray arrayWithObject:condition] orders:nil  limitCondition:nil groupConditions:nil];
#if __has_feature(objc_arc)
    condition = nil;
#else
    [condition release];
#endif
    
    if(dictArray.count == 0){
        return nil;
    }
    NSMutableDictionary * dict = dictArray[0];
#if  ND_NEED_ENCODE
    for (NSString* columnName in dict.allKeys) {
        if([[self getAllEncodeColumnsName] containsObject:columnName]){ //解密
            [dict setValue:[NDCommonFunc textFromBase64String:[dict objectForKey:columnName]] forKey:columnName];
        }
    }
#endif
    id model = [self dictToModel:dict];
    return model;
}

#pragma mark value为nil时候不放入dict
-(void)setProperty:(NSMutableDictionary *)dict key:(NSString *)key value:(NSObject *)value
{
    if (value != nil) {
        [dict setValue:value forKey:key];
    }
}

#pragma mark 封装json数据
-(void)setJSONProperty:(NSMutableDictionary *)dict key:(NSString *)key value:(NSObject *)value
{
    if (value == nil || [value description] == nil || [value description].length == 0) {
        [dict setValue:@"" forKey:key];
    }else{
        [dict setValue:[value description] forKey:key];
    }
}

#pragma mark 封装json int 型数据
-(void)setJSONIntProperty:(NSMutableDictionary *)dict key:(NSString *)key value:(NSObject *)value
{
    if (value == nil || [value description] == nil || [value description].length == 0) {
        [dict setValue:[NSNumber numberWithInt:-1] forKey:key];
    }else{
        [dict setValue:[NSNumber numberWithInt:[[value description] intValue]] forKey:key];
    }
}

#pragma mark 封装json数值型数据
-(void)setJSONDoubleProperty:(NSMutableDictionary *)dict key:(NSString *)key value:(NSObject *)value
{
    if (value == nil || [value description] == nil || [value description].length == 0) {
        [dict setValue:[NSNumber numberWithInt:-1] forKey:key];
    }else{
        [dict setValue:[NSNumber numberWithDouble:[[value description] doubleValue]] forKey:key];
    }
}

#pragma mark 封装json object数据
-(void)setJSONObjProperty:(NSMutableDictionary *)dict key:(NSString *)key value:(NSObject *)value
{
    if (value == nil || [value description] == nil || [value description].length == 0) {
        NSDictionary *temp = [[NSDictionary alloc] init];
        [dict setValue:temp forKey:key];
#if __has_feature(objc_arc)
#else
        [temp release];
#endif
    }else{
        //TODO
    }
}


#pragma mark dict转model 子类重写
-(id)dictToModel:(NSDictionary *)dict
{
    return nil;
}

#pragma mark model转dict 子类重写
-(NSMutableDictionary *)modelToDict
{
    return nil;
}

#pragma mark  model转dict 子类重写
-(NSMutableDictionary *)toDictionary
{
    return nil;
}

#pragma mark 获取所有列名  子类重写
-(NSArray *)getAllColumnsName
{
    return @[];
}

#pragma mark 获取所有需要加索引的列 子类重写
-(NSArray *)getAllIndexColumnsName
{
    return @[];
}

#pragma mark 获取所有要加密的列名 子类重写
-(NSArray *)getAllEncodeColumnsName
{
    return @[];
}

#pragma mark 是否主键递增 默认不递增  如有需要递增  子类重写 返回YES
-(BOOL)isAutoincrement
{
    return NO;
}

#pragma mark 设置主键值 子类重写
-(void)setIdValue:(NSString *)idValue
{
    
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [_utils release];
    [orderArray release];
    [conditionArray release];
    [limitCondition release];
    [groupArray release];
    [super dealloc];
}
#endif

@end
