//
//  NDDataFormat.m
//  数据类型格式化工具
//
//  Created by 陈峰 on 14-7-4.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDataFormat.h"
#import "NDQueryCondition.h"

@implementation NDDataFormat

#pragma mark 时间转nsstring
+(NSString *)dateToString:(NSDate *)date
{
    if(date == nil){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%lld", (int64_t)([date timeIntervalSince1970]*1000.0)];
    }
}

#pragma mark nsstring转时间
+(NSDate *)stringToDate:(NSString *)string
{
    if(string == nil || [@"" isEqualToString:string]){
        return nil;
    }else{
        return [NSDate dateWithTimeIntervalSince1970:([string doubleValue]/1000.0)];
    }
}

#pragma mark 数字转nsstring
+(NSString *)numberToString:(NSNumber *)number
{
    if(number == nil){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%@",number];
    }
}

#pragma mark nsstring转数字
+(NSNumber *)stringToIntNumber:(NSString *)string
{
    if(string == nil || [@"" isEqualToString:string]){
        return nil;
    }else{
        return [NSNumber numberWithInt:string.intValue];
    }
}

#pragma mark nsstring转数字
+(NSNumber *)stringToDoubleNumber:(NSString *)string
{
    if (string == nil || [@"" isEqualToString:string]) {
        return nil;
    }else{
        return [NSNumber numberWithDouble:string.doubleValue];
    }
}


#pragma mark bool转nsstring
+(NSString *)boolToString:(NDBool *)boolean
{
    if(boolean != nil && boolean.boolValue){
        return ND_BOOL_YES_STR;
    }else{
        return ND_BOOL_NO_STR;
    }
}

#pragma mark nsstring转bool
+(NDBool *)stringToBool:(NSString *)string
{
    if(string == nil || [@"" isEqualToString:string]){
        return [NDBool NDNO];
    }else{
        if([ND_BOOL_YES_STR isEqualToString:string]){
            return [NDBool NDYES];
        }else{
            return [NDBool NDNO];
        }
    }
}


#pragma mark oc的类型转成数据库类型
+(NSString *)ocType2DBType:(NSString *)ocType
{
    if([ocType isEqualToString:@"NSString"]){
        return @"TEXT";
    }else if([ocType isEqualToString:@"NDInteger"]){
        return @"INTEGER";
    }else if([ocType isEqualToString:@"NDLong"]){
        return @"BIGINT";
    }else if([ocType isEqualToString:@"NDBool"]){
        return @"TINYINT";
    }else if([ocType isEqualToString:@"NSDate"]){
        return @"BIGINT";
    }else if([ocType isEqualToString:@"NDDouble"]){
        return @"DOUBLE";
    }else if([ocType isEqualToString:@"NDBool"]){
        return @"TINYINT";
    }
    return @"TEXT";
}

#pragma mark long转nsstring
+(NSString *)longToString:(NDLong *)value
{
    return [NSString stringWithFormat:@"%lld",value.longValue];
}

#pragma mark nsstring转long
+(NDLong *)stringToLong:(NSString *)string
{
    return [NDLong dblongWithString:string];
}

#pragma mark integer转nsstring
+(NSString *)integerToString:(NDInteger *)value
{
    return [NSString stringWithFormat:@"%d",value.intValue];
}

#pragma mark nsstring转integer
+(NDInteger *)stringToInteger:(NSString *)string
{
    return [NDInteger dbintWithString:string];
}

#pragma mark double转nsstring
+(NSString *)doubleToString:(NDDouble *)value
{
    return [NSString stringWithFormat:@"%lf",value.doubleValue];
}

#pragma mark nsstring转double
+(NDDouble *)stringToDouble:(NSString *)string
{
    return [NDDouble dbdoubleWithString:string];
}

#pragma mark 格式化时间
+(NSString *)formatData:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    NSString *result = [dateFormatter stringFromDate:date];
#if __has_feature(objc_arc)
#else
    [dateFormatter release];
#endif
    return result;
}

@end
