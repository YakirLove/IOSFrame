//
//  NDDouble.m
//  double的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDouble.h"

@implementation NDDouble

@synthesize doubleValue;

-(id)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        doubleValue = [str doubleValue];
    }
    return self;
}

-(id)initWithDouble:(double)dv
{
    self = [super init];
    if (self) {
        doubleValue = dv;
    }
    return self;
}

#pragma mark 用string初始化
+(NDDouble *)dbdoubleWithString:(NSString *)string
{
    
#if __has_feature(objc_arc)
    NDDouble *dbdouble = [[NDDouble alloc] init];
#else
    NDDouble *dbdouble = [[[NDDouble alloc] init] autorelease];
#endif
    if(string == nil || string.length == 0){
        dbdouble.doubleValue = 0.0;
    }else{
        dbdouble.doubleValue = [string doubleValue];
    }
    return dbdouble;
}

#pragma mark 打印值
-(NSString *)description
{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}

@end
