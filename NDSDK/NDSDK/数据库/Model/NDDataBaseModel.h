//
//  NDDataBaseModel.h
//  数据库表对象基础夫类
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDDataBaseModelProtocol.h"
#import "NDDataBaseModelQueryProtocol.h"
#import "NDDatabaseUtils.h"
#import "NDQueryCondition.h"
#import "NDOrderCondition.h"
#import "NDDataFormat.h"
#import "NDLimitCondition.h"
#import "NDGroupCondition.h"
#import "NDStringQueryCondition.h"

@class NDDatabaseUtils;

@interface NDDataBaseModel : NSObject<NDDataBaseModelProtocol,NDDataBaseModelQueryProtocol>

-(id)initWithUtils:(NDDatabaseUtils *)utils;

#pragma mark 获取所有table model的class  用于生成建表语句
+(NSArray *)allTableModels;

#pragma mark 获取所有table model的class  用于生成建表语句
+(NSArray *)allTableModels:(NSString *)dbName;

#pragma mark 条件数组
@property(retain,nonatomic)NSArray *conditionArray;

#pragma mark 排序数组
@property(retain,nonatomic)NSArray *orderArray;

#pragma mark 限制结果条数
@property(retain,nonatomic)NDLimitCondition *limitCondition;

#pragma mark 分组条件
@property(retain,nonatomic)NSArray *groupArray;

@property(retain,nonatomic)NDDatabaseUtils *utils;

#pragma mark value为nil时候不放入dict
-(void)setProperty:(NSDictionary *)dict key:(NSString *)key value:(NSObject *)value;

#pragma mark 封装json数据
-(void)setJSONProperty:(NSDictionary *)dict key:(NSString *)key value:(NSObject *)value;

#pragma mark 封装json int 型数据
-(void)setJSONIntProperty:(NSDictionary *)dict key:(NSString *)key value:(NSObject *)value;

#pragma mark 封装json数值型数据
-(void)setJSONDoubleProperty:(NSDictionary *)dict key:(NSString *)key value:(NSObject *)value;


@end
