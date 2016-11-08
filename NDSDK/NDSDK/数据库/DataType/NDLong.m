//
//  NDLong.m
//  long的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDLong.h"

@implementation NDLong
@synthesize longValue;

-(id)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        longValue = [str longLongValue];
    }
    return self;
}

-(id)initWithLong:(long long)lv
{
    self = [super init];
    if (self) {
        longValue = lv;
    }
    return self;
}

#pragma mark 用string初始化
+(NDLong *)dblongWithString:(NSString *)string
{
    
#if __has_feature(objc_arc)
    NDLong *dblong = [[NDLong alloc] init];
#else
    NDLong *dblong = [[[NDLong alloc] init] autorelease];
#endif
    if(string == nil || string.length == 0){
        dblong.longValue = 0;
    }else{
        dblong.longValue = [string longLongValue];
    }
    return dblong;
}

#pragma mark 打印值
-(NSString *)description
{
    return [NSString stringWithFormat:@"%lld",longValue];
}

@end
