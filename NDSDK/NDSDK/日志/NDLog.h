//
//  NDLog.h
//  NDSDK
//
//  Created by zhangx on 15/9/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CocoaLumberjack.h"

/**
 *  日志框架
 */
@interface NDLog : NSObject

/**
 *  初始化日志框架
 */
+ (void)init;

/**
 *  初始化日志框架
 *
 *  @param level level 取值为 DDLogLevelOff、DDLogLevelError、DDLogLevelWarning、DDLogLevelInfo、DDLogLevelDebug、DDLogLevelVerbose、DDLogLevelAll
 */
+ (void)initWithLevel:(NSUInteger)level;

/**
 *  info 一段信息
 *
 *  @param format 格式化器
 */
+ (void)info:(NSString *)format, ...;

/**
 *  info 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)infoInSWift:(NSString *)msg;

/**
 *  error 一段信息
 *
 *  @param format 格式化器
 */
+ (void)error:(NSString *)format,...;

/**
 *  error 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)errorInSWift:(NSString *)msg;


/**
 *  warn 一段信息
 *
 *  @param format 格式化器
 */
+ (void)warn:(NSString *)format,...;

/**
 *  warn 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)warnInSWift:(NSString *)msg;

/**
 *  debug 一段信息
 *
 *  @param format 格式化器
 */
+ (void)debug:(NSString *)format,...;

/**
 *  debug 一段信息 swift 专用
 *
 *  @param msg 消息
 */
+ (void)debugInSWift:(NSString *)msg;

@end
