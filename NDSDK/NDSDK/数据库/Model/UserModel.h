//
//  UserModel.h
//  示例表
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDataBaseModel.h"

@interface UserModel : NDDataBaseModel

//用户id
@property(nonatomic,strong)NSString *userId;
//用户名
@property(nonatomic,copy)NSString *userName;
//年龄
@property(nonatomic,strong)NDInteger *age;
//生日
@property(nonatomic,strong)NSDate *birthday;
//是不是男性
@property(nonatomic,strong)NDBool * isMan;

//测试字段
@property(nonatomic,strong)NDDouble *dtest;

//测试字段
@property(nonatomic,strong)NDLong *ltest;

@end
