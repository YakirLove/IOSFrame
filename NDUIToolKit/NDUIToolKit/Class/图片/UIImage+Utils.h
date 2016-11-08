//
//  UIImage+Utils.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/3.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

/**
 *  图片压缩
 *
 *  @param img  原始图
 *  @param size 目的大小
 *
 *  @return 目的图
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  修改饱和度、亮度、对比度
 *
 *  @param saturation 饱和度      0---2
 *  @param brightness 亮度  10   -1---1
 *  @param contrast   对比度 -11  0---4
 *
 *  @return 图片
 */
- (UIImage *)imageWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast;
/**
 *  修改饱和度
 *
 *  @param saturation 饱和度
 *
 *  @return 图片
 */
- (UIImage *)imageWithSaturation:(CGFloat)saturation;
/**
 *  修改亮度
 *
 *  @param brightness 亮度
 *
 *  @return 图片
 */
- (UIImage *)imageWithBrightness:(CGFloat)brightness;
/**
 *  修改对比度
 *
 *  @param contrast 对比度
 *
 *  @return 图片
 */
- (UIImage *)imageWithContrast:(CGFloat)contrast;

/**
 *  获取某个像素颜色
 *
 *  @param point 位置
 *  @param image 图片
 *
 *  @return 颜色
 */
- (UIColor*) getPixelColorAtLocation:(CGPoint)point;

/**
 *  用指定颜色生成图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  模糊小姑
 *
 *  @param blur 模糊度
 *
 *  @return 模糊后的图
 */
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end
