//
//  NSString+Category.h
//  NDSDK
//
//  Created by 林 on 9/9/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

#pragma mark -判断
//判断字符串是否为nil,@"",[NSNull nil]
+ (BOOL) isEmptyString:(NSString *)str;

/**
 *  是否匹配正则表达式
 *
 *  @param regularStr 正则表达式
 *
 *  @return 是否匹配
 */
-(BOOL)isMatch:(NSString *)regularStr;

/**
 *  判断字符串是否包含汉字
 *
 *  @return 是否包含汉字
 */
-(BOOL)isHaveChineseFont;

/**
 *  判断是否全为数字
 *
 *  @return 返回时否匹配
 */
-(BOOL)isNumber;

/**
 * 判断是否合法的邮箱
 *
 *  @return 是否合法邮箱
 */
-(BOOL)isValidateEmail;

/**
 *  判断是否是合法的手机号码
 *
 *  @return 是否合法号码
 */
-(BOOL)isMobileNumber;

#pragma mark -获取
/**
 *  获取字符串长度
 *
 *  @param font      文字大小
 *  @param maxSize   字符的最大范围
 *
 *  @return 返回字符长度
 */
-(CGFloat)getStringWidth:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  获取字符串高度
 *
 *  @param font 文字大小
 *  @param Size 字符的最大范围
 *
 *  @return 返回字符高度
 */
-(CGFloat)getStringHeight:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark -处理
/**
 *  字符串endcode
 *
 *  @param encoding 编码格式
 *
 *  @return 返回endcode结果
 */
-(NSString *)stringFormatEndcode:(NSStringEncoding)encoding;

/**
 *  去除前后空格
 *
 *  @return 返回去除前后空格以后的字符串
 */
- (NSString *)trimString;

/**
 *  筛选出字符串中的网址
 *
 *  @return 返回网址结果
 */
-(NSMutableArray *)stringRegularSite;

/**
 *  字符串转换成时间
 *
 *  @param format 时间格式
 *
 *  @return 返回转换后的时间
 */
-(NSDate *)dateFromString:(NSString*)format;

/**
 *  取一段宽度的字符串
 *
 *  @param font     字体
 *  @param width    源字符串
 *  @param callback 回调
 *
 */
-(void)getWidthString:(UIFont *)font width:(CGFloat)width callback:(void (^)(BOOL a,NSString *result))callback;

/**
 *  汉字转拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

/**
 *  字符串分割
 *  @param separator    分割符号
 *  @return
 */
-(NSArray *)stringSegmentation:(NSString *)separator;


/**
 *  随机产生字符串
 *  @param length   产生多少长度的字符串
 *  @return
 */
+(NSString *)ret32bitString:(int)length;


/**
 *  版本号比较
 *
 *  @param serverVersion 服务端版本号
 *
 *  @return 是否需要更新
 */
-(BOOL) iscomperVersion:(NSString*)serverVersion;

/**
 *  判断字符串中是否含有emoji
 *
 *  @return 是否含有emoji
 */
- (BOOL)stringContainsEmoji;

+(NSString *)getIPAddress;

+(NSString *)deviceWANIPAdress;

@end
