//
//  NDTDInputMenuView.h
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define InputMenuView  46                       //菜单栏的默认高度

@class NDTDInputMenuView;
@protocol NDTDInputMenuViewDelegate <NSObject>

//点击菜单切换
-(void)didMenuActionSwitch:(NDTDInputMenuView *)menuView;

@end

@interface NDTDInputMenuView : UIView

@property(nonatomic,assign) id<NDTDInputMenuViewDelegate>delegate;

@property(nonatomic,strong) UIImageView *backgroundImageView;  //背景图片
@property(nonatomic,strong) UIButton          *menuBtn;        //菜单切换按钮

@end
