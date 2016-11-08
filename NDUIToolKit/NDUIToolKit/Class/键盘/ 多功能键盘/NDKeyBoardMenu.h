//
//  NDKeyBoardMenu.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/6.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDKeyBoardMenuDelegate ;


@interface NDKeyBoardMenu : UIView

@property(nonatomic,assign)id<NDKeyBoardMenuDelegate>delegate;


/**
 *  初始化菜单
 *
 *  @param frame    位置信息
 *  @param funcFlag 功能配置  文本|摄像头|图片|表情|声音|GIF|更多|赞同
 *
 *  @return 初始化
 */
-(id)initWithFrame:(CGRect)frame funcFlag:(NSString *)funcFlag;


@end


@protocol NDKeyBoardMenuDelegate <NSObject>

@optional
/**
 *  文本输入点击
 *
 *  @param menu 菜单
 */
-(void)textDidClick:(NDKeyBoardMenu *)menu;

/**
 *  摄像头点击
 *
 *  @param menu 菜单
 */
-(void)cameraDidClick:(NDKeyBoardMenu *)menu;


/**
 *  图片点击
 *
 *  @param menu 菜单
 */
-(void)photoDidClick:(NDKeyBoardMenu *)menu;


/**
 *  表情点击
 *
 *  @param menu 菜单
 */
-(void)emotDidClick:(NDKeyBoardMenu *)menu;


/**
 *  声音点击
 *
 *  @param menu 菜单
 */
-(void)voiceDidClick:(NDKeyBoardMenu *)menu;

/**
 *  gif点击
 *
 *  @param menu 菜单
 */
-(void)gifDidClick:(NDKeyBoardMenu *)menu;

/**
 *  更多点击
 *
 *  @param menu 菜单
 */
-(void)moreDidClick:(NDKeyBoardMenu *)menu;

/**
 *  支持点击
 *
 *  @param menu 菜单
 */
-(void)supportDidClick:(NDKeyBoardMenu *)menu;


@end
