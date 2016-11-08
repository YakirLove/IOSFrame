//
//  NDTDInputPanelView.h
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  类说明：
 *  1、推荐使用inputPanelViewWithType方法进行初始化
 *  2、提供默认的录音，表情，更多按钮的附加页面
 *  3、可自定义以上的附加页面
 */

#import <UIKit/UIKit.h>
#import "NDTDInputToolBarView.h"
#import "NDTDInPutMoreView.h"
#import "NDTDInputFacePanelView.h"
#import "NDTDInputRecordAudioTipView.h"

@class NDTDInputPanelView;
@protocol NDTDInputPanelViewDelegate <NSObject>

@optional
/**
 *  点击发送按钮的回调
 *
 *  @param inputPanelView 输入视图
 *  @param text           当前文本框的文字
 */

-(void)didClickSendBtnInputFaceMenuView:(NDTDInputPanelView *)inputPanelView text:(NSString *)text;

/**
 *  输入@的回调
 *
 *  @param inputPanelView 输入视图
 *  @param rane           需要插入@文字的位置
 *  @param text           当前文本框的文字
 */
-(void)didInputAtInputPanelView:(NDTDInputPanelView *)inputPanelView rane:(NSRange)rane text:(NSString *)text;

/**
 *  工具栏状态变化回调
 *
 *  @param actionType 当前状态
 */
-(void)didToolBarChangeCurrentActionType:(InputBarActionType)actionType;

/**
 *  文本变化回调
 *
 *  @param text       最新的文字
 */
-(void)didTextViewDidChange:(NSString *)text;

/**
 *  self.frame变化回调
 *
 *  @param inputPanelView 输入视图
 *  @param oldFrame       原先的Frame
 *  @param newFrame       新的Frame
 */
-(void)didInputPanelViewChangeFrame:(NDTDInputPanelView *)inputPanelView oldFrame:(CGRect)oldFrame newFrame:(CGRect)newFrame;

/**
 *  点击表情的回调
 *
 *  @param facePictureView 输入视图
 *  @param imagePath       表情的地址
 *  @param imageName       表情的名字
 */
-(void)didClickPictureface:(NDTDInputPanelView *)facePictureView imagePath:(NSString *)imagePath imageName:(NSString *)imageName;

/**
 *  选择完图片的回调
 *
 *  @param inputMoreView 输入视图
 *  @param imagePaths    图片的地址
 */
-(void)didPickedImagePaths:(NDTDInputPanelView *)inputMoreView imagePaths:(NSMutableArray *)imagePaths;

/**
 *  语音按钮事件变化
 *  @param controlEvents 按钮状态
 UIControlEventTouchDown          : 按下录音按钮开始录音
 UIControlEventTouchUpOutside     : 手指向上滑动取消录音
 UIControlEventTouchUpInside      : 松开完成录音
 UIControlEventTouchDragOutside   : 手指离开按钮的范围
 UIControlEventTouchDragInside    : 手指再次进入按钮的范围
 *
 */
-(void)didChangeRecordVoiceAction:(UIControlEvents)controlEvents;

@end

@interface NDTDInputPanelView : UIView

@property (nonatomic, assign)id<NDTDInputPanelViewDelegate>delegate;

@property (nonatomic, strong) NDTDInputToolBarView        *toolBarView;          //**> 工具栏/
@property (nonatomic, strong) NDTDInputMoreView           *moreView;             //**> 附加页面/
@property (nonatomic, strong) NDTDInputFacePanelView      *faceView;             //**> 表情页面/
@property (nonatomic, strong) NDTDInputRecordAudioTipView *recordAudioTipView;   //**> 语音提示页面/

@property (nonatomic, strong) NSString *placeHolder;                             //**> 提醒文字

@property (nonatomic, strong) NSString *text;                                    //**> 文本文字

@property (nonatomic, assign) BOOL isInputAt; //**> 是否需要支持输入@，默认NO不需要
@property (nonatomic, assign) NSInteger maxTextNumber; //**> 文本最大的字数，默认无限制
@property (nonatomic, assign) BOOL isTrimmingCharactersInSet; //文本是否除去前后空格，默认不去除

+(instancetype)inputPanelViewWithType:(InputToolBarType)toolBarType;

-(instancetype)initWithFrame:(CGRect)frame toolBarType:(InputToolBarType)toolBarTypes;


/**
 *  显示键盘
 *
 *  @param isAnimation 是否需要动画
 */
-(void)showKeyboard:(BOOL)isAnimation;

/**
 *  显示面板
 *
 *  @param isAnimation 是否需要动画
 */
-(void)showPanelView:(BOOL)isAnimation;

/**
 *  隐藏面板和键盘
 *
 *  @param isAnimation 是否需要动画
 */
-(void)hiddenPanelAndKeyboard:(BOOL)isAnimation;

//设置表情发出按钮文字，默认"发出"
-(void)setFaceSendButtonTitle:(NSString *)title;

@end
