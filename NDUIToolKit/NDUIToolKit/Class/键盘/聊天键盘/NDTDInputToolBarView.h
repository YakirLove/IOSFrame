//
//  NDTDInputToolBarView.h
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  类说明：
 *  1、推荐使用inputToolBarWithType方法进行初始化
 *  2、提供默认的录音，表情，更多按钮
 *  3、可扩展方法customView自定义视图
 */

/**
 *  工具栏类型
 */
typedef enum{
    /* 支持菜单切换,表情、文字、语音和扩展 */
    MENU_FACE_WORDS_VOICE_EXTENSION = 0,
    
    /* 支持表情、文字、语音和扩展*/
    FACE_WORDS_VOICE_EXTENSION,
    
    /* 支持表情、文字、语音 */
    FACE_WORDS_VOICE,
    
    /* 支持表情、文字、扩展 */
    FACE_WORDS_EXTENSION,
    
    /* 支持表情，文字 */
    FACE_WORDS,
    
    /* 支持文字，扩展 */
    WORDS_EXTENSION,
    
    /* 支持表情,@ */
    FACE_AT,
    /* 只支持表情 */
    FACE,
    
    /* 只支持文字 */
    WORDS,
    
    /* 只支持扩展 */
    EXTENSION                               
}InputToolBarType;


/**
 *  工具栏动作类型
 */
typedef NS_ENUM(NSUInteger, InputBarActionType) {
    
    /* 无动作 */
    InputBarActionTypeNone,
    
    /* 菜单动作 */
    InputBarActionTypeMenu,
    
    /* 录音动作 */
    InputBarActionTypeRecordAudio,
    
    /* 文本输入动作 */
    InputBarActionTypeInputText,
    
    /* 选择表情动作 */
    InputBarActionTypeChooseEmoji,
    
    /* 点击@按钮动作 */
    InputBarActionTypeChooseAt,
    
    /* 选择扩展面板动作 */
    InputBarActionTypeExpandPanel,
};


#import <UIKit/UIKit.h>
#import "NDTDTextView.h"

#define backgroundImageName @"底栏-内容输入栏"
#define menuBtnName @"底栏-内容输入栏-返回tab-正常"
#define voiceBtnNormalName @"底栏-内容输入栏-语音-正常"
#define voiceBtnHighlightName @"底栏-内容输入栏-语音-点击"
#define extensionBtnNormalName @"底栏-内容输入栏-添加-正常"
#define extensionBtnHighlightName @"底栏-内容输入栏-添加-点击"
#define faceBtnNormalName @"底栏-内容输入栏-表情-正常"
#define faceBtnHighlightName @"底栏-内容输入栏-表情-点击"
#define aTBtnNormalName @"底栏-内容输入栏-表情-正常"
#define aTBtnHighlightName @"底栏-内容输入栏-表情-点击"
#define keyboardNormalName @"底栏-内容输入栏-键盘-正常"
#define keyboardHighlightName @"底栏-内容输入栏-键盘-点击"

#define InputToolBarHeight  46.0                //工具栏的默认高度
#define AllBtnHeight        27                  //所有按钮的高度
#define ALLBtnWith          27                  //所有按钮的宽度
#define kInputTextViewMinHeight 36              //默认输入时文本框最小高度
#define kInputTextViewMaxHeight 78              //默认输入时文本框最大高度
#define NavigationHeight    64

#define kTouchToRecord @"按住 说话"              //录音按钮的文字
#define kTouchToFinish @"松开 发送"

@class NDTDInputMenuView;

@protocol NDTDInputToolBarViewDelegate <NSObject>

/**
 *  键盘高度变化通知
 *
 *  @param keyboardBeginFrame 初始位置
 *  @param keyboardEndFrame   结束位置
 *  @param duration           动画时间
 *  @param isAnimation        是否需要动画
 */
-(void)didKeyboardChangeFrame:(CGRect)keyboardBeginFrame keyboardEndFrame:(CGRect)keyboardEndFrame duration:(NSTimeInterval)duration isAnimation:(BOOL)isAnimation;

/**
 *  工具栏高度变化回调
 *
 *  @param toHeight  高度变到toHeight
 */
- (void)didToolBarChangeFrameToHeight:(CGFloat)changeHeight;

/**
 *  文本变化的回调
 *
 *  @param text 当前文本
 */
-(void)didTextViewDidChange:(NSString *)texts;

/**
 *  工具栏状态变化回调
 *
 *  @param actionType 当前状态
 */
-(void)didToolBarChangeCurrentActionType:(InputBarActionType)actionType;

/**
 *  语音按钮事件变化
 *  @param controlEvents 按钮状态
    UIControlEventTouchDown          : 按下录音按钮开始录音
    UIControlEventTouchUpOutside     : 手指向上滑动取消录音
    UIControlEventTouchUpInside      : 松开完成录音
    UIControlEventTouchDragOutside   : 手指离开按钮的范围
    UIControlEventTouchDragInside    : 手指再次进入按钮的范围
 */
-(void)didChangeRecordVoiceAction:(UIControlEvents)controlEvents;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  输入@的时候的回调，只有isAt=YES才会回调
 *
 *  @param rane @的位置
 */
- (void)didAtRane:(NSRange)rane;

@end

@interface NDTDInputToolBarView : UIView


/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property(nonatomic) CGFloat maxTextInputViewHeight;                   //默认200

@property (nonatomic) InputToolBarType   toolBarType;                   //工具栏的样式
@property (nonatomic) InputBarActionType currentActionType;             //当前操作类型
@property (nonatomic,assign) BOOL isInputAt;

@property (nonatomic,strong) UIImageView *backgroundImageView;          //背景图片

@property (nonatomic,strong) NDTDInputMenuView *menuView;               //菜单视图
@property (nonatomic,strong) UIButton          *menuBtn;                //菜单切换按钮
@property (nonatomic,strong) UIButton          *faceBtn;                //表情按钮
@property (nonatomic,strong) UIButton          *wordBtn;                //文字按钮
@property (nonatomic,strong) UIButton                   *atButton;               //@按钮
@property (nonatomic,strong) UIButton          *voiceBtn;               //语音和键盘切换按钮
@property (nonatomic,strong) UIButton          *recordVoiceBtn;         //长按按钮
@property (nonatomic,strong) UIButton          *extensionBtn;           //扩展按钮
@property (nonatomic,strong) NDTDTextView      *textView;               //文本输入框
@property (nonatomic, assign) NSInteger maxTextNumber; //**> 文本最大的字数，默认无限制
@property (nonatomic, assign) BOOL isTrimmingCharactersInSet; //文本是否除去前后空格，默认不去除

@property(nonatomic,assign) id<NDTDInputToolBarViewDelegate>delegate;

+(instancetype)inputToolBarWithType:(InputToolBarType)toolBarType;

/**
 *  自定义视图
 *  1.自定义建议改变控件位置、样式，背景
 *  2.表情、文字、语音和扩展按钮事件方法不变
 */
-(void)customView;

/**
 *  设置文本
 *
 *  @param text 文本值
 */
-(void)setText:(NSString *)text;

/**
 *  添加键盘观察
 */
-(void)addKeyboardObserve;
/**
 *  移除键盘观察
 */
- (void)removeKeyboardObserve;

/**
 *  文本和语音图标切换
 *
 *  @param isVoice yes:切换成语音，no：切换成文本
 */
-(void)textAndVoiceIconSwitch:(BOOL)isVoice;

/**
 *  键盘和表情图标切换
 *
 *  @param isFace yes:切换成表情，no：切换成键盘
 */
-(void)keyboardAndFaceIconSwitch:(BOOL)isFace;

/**
 *  设置当前文本框的高度，文本框赋值时，调用此方法调整高度
 *
 *  @param textViews
 */
- (void)willShowInputCurrentTextView:(NDTDTextView *)textViews;


@end
