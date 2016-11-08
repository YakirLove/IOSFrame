//
//  NSDate+Addition.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+Category.h"

#define DefaultFormatData @"yyyy-MM-dd HH:mm:ss"   //所有format 默认为yyyy-MM-dd HH:mm:ss格式

@interface NSDate (Addition)

/**
 *  现在时间转换成字串
 *
 *  @param format 时间格式
 *
 *  @return 返回当前时间的字符串
 */
+ (NSString *)currentDateStringWithFormat:(NSString *)format;

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

/**
 *  根据字符串得到NSDate型的时间
 *
 *  @param string 要转换的字符串
 *  @param format 时间格式
 *
 *  @return 返回转换结果
 */
+ (NSDate *)dateFromString:(NSString *)string format:(NSString*)format;

/**
 *  时间戳转换成时间
 *
 *  @param stampTime 时间戳值
 *
 *  @return 返回转换的时间结果
 */
+(NSDate *)stampConversionTime:(double)stampTime;


/**
 *  格式化时间，转为字符串
 *
 *  @param format 时间格式
 *
 *  @return 返回格式化的结果
 */
- (NSString *)dateWithFormat:(NSString *)format;

//时区,校正成本地时间
-(NSDate *)timeZoneAndLocalTimeCorrection;

/**
 *  时间转换成时间戳
 *
 *  @return 返回转换后的时间戳
 */
-(NSString *)timestampFromDate;

/**
 *  时间格式化并做时区校正，默认“Asia/Shanghai”时区
 *
 *  @param timeZone 时区
 *  @param format   时间格式
 *
 *  @return 返回格式化后的时间
 */
-(NSDate *)timeZoneCorrection:(NSString *)timeZone format:(NSString *)format;

/**
 *  时间增减,day: -1=昨天，1＝明天，2＝后天，3...
 *
 *  @param day 增减的天数
 *
 *  @return 返回增减后的结果
 */
-(NSDate *)timeAddSubtract:(NSInteger)day;

/*标准时间日期描述*/
-(NSString *)formattedTime;

/*距离当前的时间间隔描述*/
- (NSString *)timeIntervalDescription;

/*精确到分钟的日期描述*/
- (NSString *)minuteDescription;

/*格式化日期描述*/
- (NSString *)formattedDateDescription;

@end
