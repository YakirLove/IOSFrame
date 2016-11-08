//
//  NDQueryCondition.m
//  查询条件
//
//  Created by 陈峰 on 14-7-2.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDQueryCondition.h"

@implementation NDQueryCondition

@synthesize oper;
@synthesize key;
@synthesize value;

#pragma mark 构造方法
-(id)initWithKey:(NSString *)_key value:(NSString *)_value oper:(NSString *)_oper
{
    self = [super init];
    if(self){
        self.key = _key;
        self.value = _value;
        self.oper = _oper;
    }
    return self;
}

-(NSString *)description
{
    return  [NSMutableString stringWithFormat: self.oper,self.key,self.value];
}



#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [oper release];
    [key release];
    [value release];
    [super dealloc];
}
#endif

@end
