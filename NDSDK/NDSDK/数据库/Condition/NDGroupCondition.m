//
//  NDGroupCondition.h
//  查询结果分组
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDGroupCondition.h"

@implementation NDGroupCondition

@synthesize column;

-(id)initWithString:(NSString *)_column
{
    self = [super init];
    if(self){
        self.column = _column;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.column];
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [column release];
    [super dealloc];
}
#endif

@end
