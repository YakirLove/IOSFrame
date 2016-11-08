//
//  UserService.h
//  业务类示例
//
//  Created by 陈峰 on 14-8-13.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDBaseService.h"
#import "UserModel.h"

@interface UserService : NDBaseService{
    UserModel *dao; //数据库处理类
}

#pragma mark 获取实例
+(UserService *)instance;

#pragma mark 获取实例
+(void)destoryService;

//业务方法

#pragma mark 取出所有男性用户
-(NSArray *)getManUser;

-(void)saveModel:(UserModel *)model callback:(void (^)(void))callback;

-(void)saveModel:(UserModel *)model;

@end
