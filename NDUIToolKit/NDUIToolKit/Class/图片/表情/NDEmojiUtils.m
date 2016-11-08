//
//  NDEmojiUtils.m
//  NDUIToolKit
//
//  Created by zhangx on 15/9/16.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDEmojiUtils.h"

#define ND_EMOJI_PREFIX @"/e_"

@implementation NDEmojiUtils


/**
 *  编码带emoji的字符串
 *
 *  @param originStr 源字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString *)emojiEncode:(NSString *)originStr
{
    if ( [NSString isEmptyString:originStr] ){
        return @"";
    }
    
    NSArray * emojiConfigDict = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@/%@",NDUI_BUNDLE_NAME,@"emoji"] ofType:@"plist"]];
    
    NSMutableDictionary *emojiDict = [[NSMutableDictionary alloc] init];
    
    __block BOOL isEomji = NO;
    [originStr enumerateSubstringsInRange:NSMakeRange(0, [originStr length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        isEomji = NO;
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
        
        if (isEomji) {
            
            if ([emojiDict.allKeys containsObject:substring] == NO) {
                NSString *obj = [NDEmojiUtils encodeItem:substring];
                if (obj != nil) {
                    [emojiDict setObject:obj forKey:substring];
                }
            }
        }
    }];
    
    
    //替换表情
    for (NSString *key in emojiDict.allKeys) {
        originStr = [originStr stringByReplacingOccurrencesOfString:key withString:[emojiDict objectForKey:key]];
    }
    
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\[%@[a-f0-9A-F_]+\\]",ND_EMOJI_PREFIX] options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchArray = [regex matchesInString:originStr options:0 range:NSMakeRange(0, [originStr length])];
    
    NSString *resultStr = [NSString stringWithString:originStr];
    
    if(matchArray.count > 0){  /// 0 < -1 - -
        for(NSInteger i = 0 ; i < matchArray.count - 1; i++)
        {
            NSTextCheckingResult *match1 = matchArray[i];
            NSTextCheckingResult *match2 = matchArray[i+1];
            if (match1.range.location + match1.range.length == match2.range.location) {  //相邻,判断是否可以构成国旗（IOS8以下国旗取出来lenght＝2，IOS9就没这个问题）
                
                NSString *s1 = [originStr substringWithRange:match1.range];
                NSString *s2 = [originStr substringWithRange:match2.range];
                NSString * value = [NSString stringWithFormat:@"%@%@",[s1 stringByReplacingOccurrencesOfString:@"]" withString:@""],[s2 stringByReplacingOccurrencesOfString:@"[/e" withString:@""]];
                
                if ([emojiConfigDict containsObject:value]) { //可以构成国旗 替换掉
                    resultStr = [resultStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@",s1,s2] withString:value];
                    i++;
                }
            }
        }

    }
    
    return resultStr;
}




#pragma mark 编码表情
+ (NSString *)encodeItem:(NSString *)itemStr
{
    NSData *data = [itemStr dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    
    NSString *tempStr = [[data description] lowercaseString];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSArray *items = [tempStr componentsSeparatedByString:@" "];
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"["];
    [result appendString:ND_EMOJI_PREFIX];
    NSMutableString *item = nil;
    for (NSInteger i = 0 ;i < items.count ; i++) {
        item = [[NSMutableString alloc] initWithString:items[i]];
        while ([item hasPrefix:@"0"]) { //去除左边多余的0
            [item deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        if (i != 0) {
            [result appendString:@"_"];
        }
        [result appendString:item];
    }
    
    [result appendString:@"]"];
    
    
    return result;
}




/**
 *  解码带emoji的字符串
 *
 *  @param resultStr 目的字符串
 *
 *  @return 解码后的字符串
 */
+ (NSString *)emojiDecode:(NSString *)decodedStr
{
    
    if ( [NSString isEmptyString:decodedStr] ){
        return @"";
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\[%@[a-f0-9A-F_]+\\]",ND_EMOJI_PREFIX] options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchArray = [regex matchesInString:decodedStr options:0 range:NSMakeRange(0, [decodedStr length])];
    
    NSMutableDictionary *emojiDict = [[NSMutableDictionary alloc] init];
    for (NSTextCheckingResult *matchItem in matchArray) {
        NSString *item = [decodedStr substringWithRange:matchItem.range];
        if ([emojiDict.allKeys containsObject:item] == NO) {
            NSString *obj = [NDEmojiUtils decodeItem:item];
            if (obj != nil) {
                [emojiDict setObject:obj forKey:item];
            }
        }
    }
    
    //替换表情
    for (NSString *key in emojiDict.allKeys) {
        decodedStr = [decodedStr stringByReplacingOccurrencesOfString:key withString:[emojiDict objectForKey:key]];
    }
    
    return decodedStr;
    
}

#pragma mark 解码表情
+ (NSString *)decodeItem:(NSString *)itemStr
{
    itemStr = [itemStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    itemStr = [itemStr stringByReplacingOccurrencesOfString:ND_EMOJI_PREFIX withString:@""];
    itemStr = [itemStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSArray *items = [itemStr componentsSeparatedByString:@"_"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSMutableString *item = nil;
    for (NSInteger i = 0 ; i < items.count ; i++) {
        item = [[NSMutableString alloc] initWithString:[items[i] lowercaseString]];
        while (item.length != 8) { //去除左边多余的0
            [item insertString:@"0" atIndex:0];
        }
        [data appendData:[NSData stringToHexData:item]];
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF32BigEndianStringEncoding];

}


@end
