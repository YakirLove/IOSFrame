//
//  NDInteger.m
//  bool的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDInteger.h"

@implementation NDInteger
@synthesize intValue;

-(id)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        intValue = [str intValue];
    }
    return self;
}

-(id)initWithInt:(int)iv
{
    self = [super init];
    if (self) {
        intValue = iv;
    }
    return self;
}

#pragma mark 用string初始化
+(NDInteger *)dbintWithString:(NSString *)string
{
    
#if __has_feature(objc_arc)
    NDInteger *dbint = [[NDInteger alloc] init];
#else
    NDInteger *dbint = [[[NDInteger alloc] init] autorelease];
#endif
    if(string == nil || string.length == 0){
        dbint.intValue = 0;
    }else{
        dbint.intValue = [string intValue];
    }
    return dbint;
}

#pragma mark 打印值
-(NSString *)description
{
    return [NSString stringWithFormat:@"%d",intValue];
}

@end
