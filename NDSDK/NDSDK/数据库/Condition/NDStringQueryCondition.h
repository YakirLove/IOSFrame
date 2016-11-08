//
//  NDStringQueryCondition.h
//  条件查询的sql语句
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDQueryCondition.h"

@interface NDStringQueryCondition : NDQueryCondition

@property(nonatomic,copy)NSString *condition;

#pragma mark 初始化
-(id)initWithString:(NSString *)str;

@end
