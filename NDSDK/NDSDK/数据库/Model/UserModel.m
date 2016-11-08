//
//  UserModel.m
//  示例表
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "UserModel.h"
#import <objc/runtime.h>


#define USER_COLUMNS @[@"userId",@"userName",@"age",@"birthday",@"isMan",@"dtest",@"ltest"]
#define USER_INDEX_COLUMNS @[@"userName"]
#define USER_ENCODE_COLUMNS @[@"userName"]
#define USER_TABLE @"User"
#define USER_ID @"userId"
#define USER_ID_AUTOINCREMENT YES

@implementation UserModel

@synthesize userId;
@synthesize userName;
@synthesize age;
@synthesize birthday;
@synthesize isMan;

@synthesize dtest;
@synthesize ltest;

#pragma mark 返回user表表名
-(NSString *)tableName
{
    return USER_TABLE;
}

#pragma mark 返回主键列名
-(NSString *)idName
{
    return USER_ID;
}

#pragma mark 返回主键列值
-(NSString *)idValue
{
    return self.userId;
}

#pragma mark user表列名
-(NSArray *)getAllColumnsName
{
    return USER_COLUMNS;
}

#pragma mark 所有需要加索引的列
-(NSArray *)getAllIndexColumnsName
{
    return USER_INDEX_COLUMNS;
}

#pragma mark 获取所有要加密的列名 子类重写
-(NSArray *)getAllEncodeColumnsName
{
    return USER_ENCODE_COLUMNS;
}

#pragma mark 是否主键递增
-(BOOL)isAutoincrement
{
    return USER_ID_AUTOINCREMENT;
}

#pragma mark 设置主键值 子类重写
-(void)setIdValue:(NSString *)idValue
{
    self.userId = idValue;
}

#pragma mark userModel转dict
-(NSMutableDictionary *)modelToDict
{
#if __has_feature(objc_arc)
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
#else
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
#endif
    [self setProperty:dict key:@"userId" value:self.userId];
    [self setProperty:dict key:@"userName" value:self.userName];
    [self setProperty:dict key:@"age" value:self.age];
    [self setProperty:dict key:@"birthday" value:self.birthday];
    [self setProperty:dict key:@"isMan" value:self.isMan];
    [self setProperty:dict key:@"dtest" value:self.dtest];
    [self setProperty:dict key:@"ltest" value:self.ltest];
    return dict;
}

#pragma mark dict转userModel
-(id)dictToModel:(NSDictionary *)dict
{
    if(dict.count == 0){
        return nil;
    }
#if __has_feature(objc_arc)
    UserModel *model = [[UserModel alloc] init];
#else
    UserModel *model = [[[UserModel alloc] init] autorelease];
#endif
    model.userId = [dict objectForKey:@"userId"];
    model.userName = [dict objectForKey:@"userName"];
    model.age = [NDDataFormat stringToInteger:[dict objectForKey:@"age"]];
    model.birthday = [NDDataFormat stringToDate:[dict objectForKey:@"birthday"]];
    model.isMan = [NDDataFormat stringToBool:[dict objectForKey:@"isMan"]];
    model.dtest = [NDDataFormat stringToDouble:[dict objectForKey:@"dtest"]];
    model.ltest = [NDDataFormat stringToLong:[dict objectForKey:@"ltest"]];
    
    return model;
}


#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [userId release];
    [userName release];
    [age release];
    [birthday release];
    [isMan release];
    [ltest release];
    [dtest release];
    [super dealloc];
}
#endif


@end
