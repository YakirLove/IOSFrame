//
//  NDDataBaseModel.h
//  数据库表对象接口
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NDDataBaseModelProtocol  <NSObject>

@required
#pragma mark 表名
-(NSString *)tableName;

#pragma mark 主键名称
-(NSString *)idName;

#pragma mark 主键值
-(NSString *)idValue;

#pragma mark 设置主键值
-(void)setIdValue:(NSString *)idValue;

#pragma mark 是否主键递增
-(BOOL)isAutoincrement;

#pragma mark 获取所有列名
-(NSArray *)getAllColumnsName;

#pragma mark 获取所有需要加索引的列
-(NSArray *)getAllIndexColumnsName;

#pragma mark 获取所有要加密的列名
-(NSArray *)getAllEncodeColumnsName;

#pragma mark  dict转model
-(id)dictToModel:(NSDictionary *)dict;

#pragma mark  model转dict
-(NSMutableDictionary *)modelToDict;

#pragma mark  model转dict
-(NSDictionary *)toDictionary;

@end

