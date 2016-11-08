//
//  UIColor+Gradient.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Gradient)
/**
 *  渐变的颜色
 *
 *  @param c1     起始色
 *  @param c2     结束色
 *  @param height 高度
 *
 *  @return 颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
@end
