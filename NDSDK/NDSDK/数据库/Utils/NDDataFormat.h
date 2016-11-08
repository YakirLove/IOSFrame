//
//  NDDataFormat.h
//  数据类型格式化工具
//
//  Created by 陈峰 on 14-7-4.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBool.h"
#import "NDDouble.h"
#import "NDLong.h"
#import "NDInteger.h"

@interface NDDataFormat : NSObject

#pragma mark 时间转nsstring
+(NSString *)dateToString:(NSDate *)date;

#pragma mark nsstring转时间
+(NSDate *)stringToDate:(NSString *)string;


#pragma mark 时间转nsstring
+(NSString *)numberToString:(NSNumber *)number;

#pragma mark nsstring转数字
+(NSNumber *)stringToIntNumber:(NSString *)string;

#pragma mark nsstring转数字
+(NSNumber *)stringToDoubleNumber:(NSString *)string;

#pragma mark boolean转nsstring
+(NSString *)boolToString:(NDBool *)boolean;

#pragma mark nsstring转boolean
+(NDBool *)stringToBool:(NSString *)string;

#pragma mark long转nsstring
+(NSString *)longToString:(NDLong *)boolean;

#pragma mark nsstring转long
+(NDLong *)stringToLong:(NSString *)string;

#pragma mark integer转nsstring
+(NSString *)integerToString:(NDInteger *)value;

#pragma mark nsstring转integer
+(NDInteger *)stringToInteger:(NSString *)string;

#pragma mark double转nsstring
+(NSString *)doubleToString:(NDDouble *)value;

#pragma mark nsstring转double
+(NDDouble *)stringToDouble:(NSString *)string;

#pragma mark oc的类型转成数据库类型
+(NSString *)ocType2DBType:(NSString *)ocType;

#pragma mark 格式化时间
+(NSString *)formatData:(NSDate *)date;

@end
