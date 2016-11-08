//
//  UIColor+Category.h
//  NDSDK
//
//  Created by 林 on 9/9/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/**
 *  渐变
 *
 *  @param c1     初始颜色
 *  @param c2     渐变到的颜色
 *  @param height 高度
 *
 *  @return 返回颜色值
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

#pragma mark -HEX
/**
 *  16进制转成颜色
 *
 *  @param hex
 *
 *  @return 返回颜色值
 */
+ (UIColor *)colorWithHex:(UInt32)hex;

/**
 *  16进制转成颜色,带透明
 *
 *  @param hex   16进制值
 *  @param alpha 透明度
 *
 *  @return 返回颜色值
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/**
 *  16进制转成颜色,字符串
 *
 *  @param hexString 16进制值
 *
 *  @return 返回颜色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;


/**
 *  颜色转换成16进制字符串
 *
 *  @return 返回16进制字符串
 */
- (NSString *)HEXString;

#pragma mark -Modify
/**
 *  取相反的颜色
 *
 *  @return 返回相反颜色
 */
- (UIColor *)invertedColor;

/**
 *  颜色半透明
 *
 *  @return 返回半透明颜色
 */
- (UIColor *)colorForTranslucency;

/**
 *  颜色高亮
 *
 *  @param lighten 高亮值
 *
 *  @return 返回高亮颜色
 */
- (UIColor *)lightenColor:(CGFloat)lighten;

/**
 *  颜色变暗
 *
 *  @param darken 变暗颜色值
 *
 *  @return 返回变暗的颜色
 */
- (UIColor *)darkenColor:(CGFloat)darken;

#pragma mark -随机颜色
/**
 *  随机颜色
 *
 *  @return 返回随机的颜色
 */
+ (UIColor *)RandomColor;

#pragma mark -web
/**
 *  获取canvas用的颜色字符串
 *
 *  @return 返回转换的字符串
 */
- (NSString *)canvasColorString;

/**
 *  获取网页颜色字串
 *
 *  @return 返回转换的字符串
 */
- (NSString *)webColorString;
@end
