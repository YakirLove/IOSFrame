//
//  NSString+Category.m
//  NDSDK
//
//  Created by 林 on 9/9/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import "NSString+Category.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation NSString (Category)

#pragma mark 空字符串
+ (BOOL) isEmptyString:(NSString *)str
{
    return (NSNull *)str == [NSNull null] || str == nil || str.length == 0 || [str isEqualToString:@"(null)"];
}

#pragma mark 是否匹配正则表达式
-(BOOL)isMatch:(NSString *)regularStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    return [predicate evaluateWithObject:self];
}

#pragma mark 去除前后空格
- (NSString *)trimString
{
    if ([NSString isEmptyString:self]) {
        return @"";
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//获取字符串长度
-(CGFloat)getStringWidth:(UIFont *)font maxSize:(CGSize)maxSize;
{
    if ([NSString isEmptyString:self]==YES) {
        return 0;
    }
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize expectedLabelSizeOne = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return expectedLabelSizeOne.width;
}

//获取字符串高度
-(CGFloat)getStringHeight:(UIFont *)font maxSize:(CGSize)maxSize
{
    if ([NSString isEmptyString:self]==YES) {
        return 0;
    }

    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize expectedLabelSizeOne = [self boundingRectWithSize:maxSize options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return expectedLabelSizeOne.height;
}

//字符串endcode
-(NSString *)stringFormatEndcode:(NSStringEncoding)encoding;
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    NSInteger len = [escapeChars count];
    
    NSMutableString *temp = [[NSMutableString alloc]initWithString:[self stringByAddingPercentEscapesUsingEncoding:encoding]];
    
    NSInteger i;
    for (i = 0; i < len; i++) {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    NSString *outStr = [NSString stringWithString: temp];
    return outStr;
}

//正则出字符串中的网址
-(NSMutableArray *)stringRegularSite
{
    NSError *error;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    //NSString *regulaStr = @"((https?|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [self substringWithRange:match.range];
        [array addObject:substringForMatch];
    }
    return array;
}

//判断字符串是否包含汉字
-(BOOL)isHaveChineseFont
{
    for (NSUInteger i=0; i<self.length; i++) {
        unichar c=[self characterAtIndex:i];
        if (c>=0x4E00&&c<=0x9FFF) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isNumber
{
    if ([NSString isEmptyString:self] == YES) {
        return NO;
    }
    //判断是不是纯数字
    NSString *numString=[self stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]];
    if (numString.length>0) {
        return NO;
    }
    else
    {
        return YES;
    }
}

//判断是否合法的邮箱
-(BOOL)isValidateEmail
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:self];
}

//判断是否是合法的手机号码
-(BOOL)isMobileNumber
{
    if(self.length == 11 && [[self substringToIndex:1] isEqualToString:@"1"])
        return YES;
    return NO;
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    /**
//     29         * 国际长途中国区(+86)
//     30         * 区号：+86
//     31         * 号码：十一位
//     32         */
//    NSString * IPH = @"^\\+861(3|5|8)\\d{9}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestiph = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IPH];
//    if (([regextestmobile evaluateWithObject:self] == YES)
//        || ([regextestcm evaluateWithObject:self] == YES)
//        || ([regextestct evaluateWithObject:self] == YES)
//        || ([regextestcu evaluateWithObject:self] == YES)
//        || ([regextestiph evaluateWithObject:self] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

-(NSDate *)dateFromString:(NSString*)format
{
    if ([NSString isEmptyString:self]==YES) {
        return nil;
    }
    if ([NSString isEmptyString:format]==YES || [format isEqualToString:@""]) {
        format = DefaultFormatData;
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    return [dateformatter dateFromString:self];
}


/**
 *  取一段宽度的字符串
 *
 *  @param font     字体
 *  @param width    源字符串
 *  @param callback 回调
 *
 */
-(void)getWidthString:(UIFont *)font width:(CGFloat)width callback:(void (^)(BOOL a,NSString *result))callback
{
    
    CGFloat textHeight = [self getStringHeight:font maxSize:CGSizeMake(width, INT_MAX)];
    
    if(textHeight + 1.0 >= font.lineHeight && textHeight - 1.0 <= font.lineHeight ){ //单行直接返回
        callback(NO,self);
        return ;
    }else{ //多行 二分法计算
        NSString *temp = [self copy];
        
        while (true) {
            temp = [temp substringToIndex:temp.length / 2];
            
            textHeight = [temp getStringHeight:font maxSize:CGSizeMake(width, INT_MAX)];
            
            if (textHeight <= font.lineHeight + 1.0) {
                for (NSInteger i = temp.length + 1; i < self.length; i++) {
                    temp = [self substringToIndex:i];
                    
                    textHeight = [temp getStringHeight:font maxSize:CGSizeMake(width, INT_MAX)];
                    
                    if (textHeight > font.lineHeight + 1.0) {
                        callback(YES,[self substringToIndex:i - 1]);
                        return ;
                    }
                }
            }
        }
    }
    
    
}

/**
 *  汉字转拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin
{
    if ([NSString isEmptyString:self]) {
        return @"";
    }
    CFStringRef cfstr = (__bridge CFStringRef)self;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, cfstr);
    if (CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO)&&CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO)) {
        return (__bridge NSString *)(string);
    }else{
        return self;
    }
}

-(NSArray *)stringSegmentation:(NSString *)separator
{
    return (NSArray *)[self componentsSeparatedByString:separator];
}

+(NSString *)ret32bitString:(int)length
{
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

-(BOOL) iscomperVersion:(NSString*)serverVersion;
{
    return ([self compare:serverVersion options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}


// Get IP Address
+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



@end
