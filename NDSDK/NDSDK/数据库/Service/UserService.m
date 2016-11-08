//
//  UserService.m
//  业务类示例
//
//  Created by 陈峰 on 14-8-13.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "UserService.h"

static UserService *_service;

@implementation UserService

+ (id)instance
{
    @synchronized(self){
        if (!_service) {
            _service = [[UserService alloc] init];
            [_service setUserDao: [[UserModel alloc] initWithUtils:[NDDatabaseUtils getInstance]]];
        }
        return _service;
    }
}

#pragma mark 设置对象
-(void)setUserDao:(UserModel *)_dao
{
    dao = _dao;
}


+(void)destoryService
{
#if __has_feature(objc_arc)
#else
    [_service release];
#endif
}


//业务方法

#pragma mark 取出所有男性用户
-(NSArray *)getManUser
{
    NDQueryCondition *condition = [[NDQueryCondition alloc] initWithKey:@"isMan" value:@"1" oper:ND_OPER_EQ];
    dao.conditionArray = [NSArray arrayWithObject:condition];
    NSArray *result = [dao getModels];
#if __has_feature(objc_arc)
#else
    [condition release];
#endif
    dao.conditionArray = nil;
    return result;
}

-(void)saveModel:(UserModel *)model callback:(void (^)(void))callback
{
    [dao saveModel:model callback:^{
        callback();
    }];
}

-(void)saveModel:(UserModel *)model
{
    [dao saveModel:model];
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [dao release];
    [super dealloc];
}
#endif

@end
