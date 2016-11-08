//
//  NSData+Category.m
//  NDSDK
//
//  Created by zhangx on 15/9/16.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NSData+Category.h"

@implementation NSData (Category)

#pragma mark NSData拓展
+ (NSData *) stringToHexData:(NSString *)str
{
    NSInteger len = [str length] / 2; // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char *byte_chars = malloc(3);
    
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    free(byte_chars);
    return data;
}

@end
