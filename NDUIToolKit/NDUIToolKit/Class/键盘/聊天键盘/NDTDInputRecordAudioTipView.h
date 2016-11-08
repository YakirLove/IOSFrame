//
//  NDTDInputRecordAudioTipView.h
//  NDTDChat
//
//  Created by 林 on 7/30/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  语音录制提示视图
 */

#import <UIKit/UIKit.h>

#define CancelSlideTipString @"手指上滑,取消发送"
#define CancelLoosenTipString @"手指松开,取消发送"
#define InsufficientTimeString @"说话时间太短"

@interface NDTDInputRecordAudioTipView : UIView

/**
 *  自定义视图
 *  1.自定义建议改变控件位置、样式，背景
 *  2.表情、文字、语音和扩展按钮事件方法不变
 */
-(void)customView;

/**
 *  显示录音提示
 */
-(void)showRecordAudioTipView;

/**
 *  滑动取消提示
 */
-(void)showSlideCancelTip;

/**
 *  隐藏录音提示
 *
 *  @param isTipInsufficientTime yes：提示时间不足  no:直接隐藏
 */
-(void)hiddenRecordAudioTipView:(BOOL)isTipInsufficientTime;

/**
 *  移除语音提示视图
 */
-(void)removeRecordAudioTipView;

//录音时的音量显示 0～1
-(void)setvolumeImageView:(double)voiceSound;

@end
