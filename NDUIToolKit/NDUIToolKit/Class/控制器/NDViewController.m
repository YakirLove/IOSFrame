//
//  NDViewController.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/25.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDViewController.h"

@interface NDViewController(){
    BOOL hadLoadView; ///< 是否已经加载过view了
}

@end

@implementation NDViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view layoutSubviews];
}


#pragma mark 返回按钮事件
- (void)backAction:(UIButton *)btn {
    
    if ([self.navigationController popViewControllerAnimated:YES]) {
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^
         {
             
         }];
    }
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (hadLoadView == NO) {
        hadLoadView = YES;
        [self autoLayoutViewDidLoad];
    }
}

/**
 *  使用autolayout在这个方法当中可以获取到当前view具体宽高
 */
-(void)autoLayoutViewDidLoad
{
    
}

#pragma mark 设置导航条是否可见
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBarHidden = navigationBarHidden;
    self.fd_prefersNavigationBarHidden = navigationBarHidden;
}

#pragma mark 启用返回手势
-(void)enableBackGesture
{
    self.fd_interactivePopDisabled = NO;
}

#pragma mark 禁用返回手势
-(void)disableBackGesture
{
    self.fd_interactivePopDisabled = YES;
}

/**
 *  设置导航条背景色
 *
 *  @param color 颜色值
 */
- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    self.navigationController.navigationBar.barTintColor = color;
}

/**
 *  设置导航条title颜色和字体大小
 *
 *  @param color 颜色值
 *  @param font  字体大小
 */
- (void)setNavigationBarTitleColor:(UIColor *)color font:(UIFont *)font
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,font,NSFontAttributeName,nil]];
}

@end
