//
//  NDViewController.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/25.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Category.h"
#import "UINavigationController+FDFullscreenPopGesture.h" //右滑返回手势

/**
 *  vc的公用父类
 */
@interface NDViewController : UIViewController

@property(nonatomic,assign)BOOL navigationBarHidden; ///< 导航条隐藏

/**
 *  使用autolayout在这个方法当中可以获取到当前view具体宽高
 */
- (void)autoLayoutViewDidLoad;

/**
 *  启用返回手势
 */
- (void)enableBackGesture;

/**
 *  禁用返回手势
 */
- (void)disableBackGesture;

/**
 *  返回按钮事件
 *
 *  @param btn 按钮
 */
- (void)backAction:(UIButton *)btn;

/**
 *  设置导航条背景色
 *
 *  @param color 颜色值
 */
- (void)setNavigationBarBackgroundColor:(UIColor *)color;

/**
 *  设置导航条title颜色和字体大小
 *
 *  @param color 颜色值
 *  @param font  字体大小
 */
- (void)setNavigationBarTitleColor:(UIColor *)color font:(UIFont *)font;

@end
