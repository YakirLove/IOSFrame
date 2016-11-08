//
//  NDTableManageModel.h
//  数据库表格管理
//
//  Created by 陈峰 on 14-7-21.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDataBaseModel.h"

@interface NDTableManageModel : NDDataBaseModel

#pragma mark 用户表表名
@property(nonatomic,copy)NSString *userTableName;

#pragma mark 主键索引
@property(nonatomic,copy)NSString *idIndex;

@end
