//
//  NSString+NDJson.m
//  SystemJsonParse
//
//  Created by zhangx on 15/4/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDJson.h"

@implementation NSString (NDJson_JsonParsing)

#pragma mark 字符串转Json对象
- (id)JSONValue
{
    if ([NSString isEmptyString:self]) {   ///空字串
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result  = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}

@end


@implementation NSObject (NDJson_JsonWriting)

#pragma mark Json对象转字符串
- (NSString *)JSONRepresentation;
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

