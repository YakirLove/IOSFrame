//
//  NDTableManageModel.m
//  数据库表格管理
//
//  Created by 陈峰 on 14-7-21.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDTableManageModel.h"

#define ND_TABLE_MANAGE_COLUMNS @[@"userTableName",@"idIndex"]
//#define TABLE_ENCODE_COLUMNS @[@"tableName"]
#define ND_TABLE_MANAGE_ENCODE_COLUMNS @[]
#define ND_TABLE_MANAGE_TABLE @"TableManage"
#define ND_TABLE_MANAGE_ID @"userTableName"

@implementation NDTableManageModel

@synthesize userTableName;
@synthesize idIndex;

#pragma mark 返回user表表名
-(NSString *)tableName
{
    return ND_TABLE_MANAGE_TABLE;
}

#pragma mark 返回主键列名
-(NSString *)idName
{
    return ND_TABLE_MANAGE_ID;
}

#pragma mark 返回主键列值
-(NSString *)idValue
{
    return self.userTableName;
}

#pragma mark user表列名
-(NSArray *)getAllColumnsName
{
    return ND_TABLE_MANAGE_COLUMNS;
}

#pragma mark 获取所有要加密的列名 子类重写
-(NSArray *)getAllEncodeColumnsName
{
    return ND_TABLE_MANAGE_ENCODE_COLUMNS;
}

#pragma mark userModel转dict
-(NSMutableDictionary *)modelToDict
{
#if __has_feature(objc_arc)
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
#else
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
#endif
    [self setProperty:dict key:@"userTableName" value:self.userTableName];
    [self setProperty:dict key:@"idIndex" value:self.idIndex];
    return dict;
}

#pragma mark dict转userModel
-(id)dictToModel:(NSDictionary *)dict
{
    if(dict.count == 0){
        return nil;
    }
#if __has_feature(objc_arc)
    NDTableManageModel *model = [[NDTableManageModel alloc] init];
#else
    NDTableManageModel *model = [[[NDTableManageModel alloc] init] autorelease];
#endif
    model.userTableName = [dict objectForKey:@"userTableName"];
    model.idIndex = [dict objectForKey:@"idIndex"];
    return model;
}


#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [userTableName release];
    [idIndex release];
    [super dealloc];
}
#endif


@end
