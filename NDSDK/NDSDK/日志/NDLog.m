//
//  NDLog.m
//  NDSDK
//
//  Created by zhangx on 15/9/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDLog.h"

static NSUInteger ddLogLevel = DDLogLevelDebug;

@implementation NDLog

/**
 *  初始化日志框架
 */
+ (void)init
{
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}


+ (void)initWithLevel:(NSUInteger)level
{
    ddLogLevel = level;   //设置等级
    [NDLog init];
}

/**
 *  info 一段信息
 *
 *  @param format 格式化器
 */
+ (void)info:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    DDLogInfo([[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

/**
 *  info 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)infoInSWift:(NSString *)msg
{
    DDLogInfo(msg);
}

/**
 *  error 一段信息
 *
 *  @param format 格式化器
 */
+ (void)error:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    DDLogError([[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

/**
 *  error 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)errorInSWift:(NSString *)msg
{
    DDLogError(msg);
}

/**
 *  warn 一段信息
 *
 *  @param format 格式化器
 */
+ (void)warn:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    DDLogWarn([[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

/**
 *  warn 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)warnInSWift:(NSString *)msg
{
    DDLogWarn(msg);
}


/**
 *  debug 一段信息
 *
 *  @param format 格式化器
 */
+ (void)debug:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    DDLogDebug([[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

/**
 *  debug 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)debugInSWift:(NSString *)msg
{
    DDLogDebug(msg);
}

@end
