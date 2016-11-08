//
//  NDDataBaseModelQueryProtocol.h
//  数据库表对象查询接口
//
//  Created by 陈峰 on 14-7-2.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDDataBaseModel;
@protocol NDDataBaseModelQueryProtocol <NSObject>


#pragma mark 获取对象 可加查询条件
-(NSArray *)getModels;
#pragma mark 获取对象 可加查询条件
-(void)getModels:(void (^)(NSArray *result))callback;

#pragma mark 获取Dictionary对象 可加查询条件
-(void)getDictModels:(void (^)(NSArray *result))callback;

#pragma mark 获取Dictionary对象 可加查询条件
-(NSArray *)getDictModels;

#pragma mark 删除对象 可加查询条件
-(void)deleteModels;

#pragma mark 删除对象 可加查询条件
-(void)deleteModels:(void (^)(void))callback;

#pragma mark 更新对象 可加查询条件 不能更改 主键的值
-(void)updateModels;

#pragma mark 更新对象 可加查询条件 不能更改 主键的值
-(void)updateModels:(void (^)(void))callback;

#pragma mark 根据id获取对象  取不到返回nil
-(id)getModelById:(NSString *)idValue;

#pragma mark 记录数
-(int)count;

#pragma mark 保存model到数据库中
-(void)saveModel:(NDDataBaseModel *)model;

#pragma mark 保存model到数据库中
-(void)saveModel:(NDDataBaseModel *)model callback:(void (^)(void))callback;

#pragma mark 从数据库中删除
-(void)deleteModel:(NDDataBaseModel *)model;

#pragma mark 从数据库中删除
-(void)deleteModel:(NDDataBaseModel *)model callback:(void (^)(void))callback;


#pragma mark 更新
-(void)updateModel:(NDDataBaseModel *)model;

#pragma mark 更新
-(void)updateModel:(NDDataBaseModel *)model callback:(void (^)(void))callback;

@end
