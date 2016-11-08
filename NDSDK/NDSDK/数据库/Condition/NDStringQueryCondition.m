//
//  NDStringQueryCondition.m
//  条件查询的sql语句
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDStringQueryCondition.h"

@implementation NDStringQueryCondition

@synthesize condition;

#pragma mark 初始化
-(id)initWithString:(NSString *)str
{
    self = [super init];
    if(self){
        self.condition = str;
    }
    return self;
}

-(NSString *)description
{
    return self.condition;
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [condition release];
    [super dealloc];
}
#endif


@end
