//
//  NDOrderCondition.m
//  排序条件
//
//  Created by 陈峰 on 14-7-4.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDOrderCondition.h"

@implementation NDOrderCondition

@synthesize oper;
@synthesize key;

#pragma mark 构造方法
-(id)initWithKey:(NSString *)_key oper:(NSString *)_oper
{
    self = [super init];
    if(self){
        self.key = _key;
        self.oper = _oper;
    }
    return self;
}


-(NSString *)description
{
    return [NSString stringWithFormat:self.oper,self.key];
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [key release];
    [oper release];
    [super dealloc];
}
#endif


@end
