//
//  NDLimitCondition.m
//  查询结果限制条数跟起始位置  用于分页
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDLimitCondition.h"

@implementation NDLimitCondition

@synthesize count;
@synthesize offset;

-(id)initWithCount:(int )_count offset:(int)_offset
{
    self = [super init];
    if(self){
        self.count = _count;
        self.offset = _offset;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@" limit %d offset %d ",self.count,self.offset];
}

@end
