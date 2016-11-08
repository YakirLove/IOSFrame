//
//  NDOrderCondition.h
//  排序条件
//
//  Created by 陈峰 on 14-7-4.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

//字符串比较
#define ND_OPER_ASC @"%@ ASC"
#define ND_OPER_DESC @"%@ DESC"
#define ND_OPER_ASC_NUMBER @"CAST (%@ AS DOUBLE) ASC"
#define ND_OPER_DESC_NUMBER @"CAST (%@ AS DOUBLE) DESC"

#define ORDER_RECORD_DESC [[NDOrderCondition alloc] initWithKey:@"rowId" oper:ND_OPER_DESC]

@interface NDOrderCondition : NSObject

#pragma mark 排序的数据库字段
@property(copy,nonatomic)NSString *key;
#pragma mark 排序类型
@property(copy,nonatomic)NSString *oper;

#pragma mark 构造方法
-(id)initWithKey:(NSString *)key oper:(NSString *)oper;

@end
