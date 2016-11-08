//
//  FMDatabase+Category.m
//  Demo
//
//  Created by zhangx on 15/7/1.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "FMDatabase+Category.h"
#import <objc/runtime.h>

@implementation FMDatabase (Category)

+ (void)load
{
    Class c = [FMDatabase class];
    AutoCloseSwizzle(c, @selector(open), @selector(override_open));
    AutoCloseSwizzle(c, @selector(openWithFlags:), @selector(override_openWithFlags:));
}

-(BOOL)override_open
{
    BOOL result = [self override_open];
    if (DB_NEED_ENCODE) {
        [self setDBKey:DB_KEY];
    }
    return result;
}

-(BOOL)override_openWithFlags:(int)flags
{
    BOOL result = [self override_openWithFlags:flags];
    if (DB_NEED_ENCODE) {
        [self setDBKey:DB_KEY];
    }
    return result;
}

#pragma mark 设置数据库密码
-(BOOL)setDBKey:(NSString *)key
{
    const void * bytes = [key UTF8String];
    NSData *keyData = [NSData dataWithBytes:bytes length:(NSInteger)strlen(bytes)];
    if(!keyData){
        return NO;
    }
    
    int rc = sqlite3_key([self sqlite3], [keyData bytes], (int)[keyData length]);
    return rc == SQLITE_OK;
}

-(sqlite3 *)sqlite3
{
    return _db;
}



@end
