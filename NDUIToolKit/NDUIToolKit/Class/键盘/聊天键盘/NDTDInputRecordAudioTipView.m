//
//  NDTDInputRecordAudioTipView.m
//  NDTDChat
//
//  Created by 林 on 7/30/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputRecordAudioTipView.h"

@implementation NDTDInputRecordAudioTipView
{
    UIImageView *microphoneImageView;
    UIImageView *volumeImageView;
    UIImageView *cancelImageView;
    UILabel *tipLabel;
    UILabel *excalmatoryMarkLabel;
    UIView *backgroundView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackgroundFlowMonitor) name:UIApplicationDidEnterBackgroundNotification object:nil];

        [self performSelector:@selector(createView) withObject:nil afterDelay:0.001];
    }
    return self;
}

-(void)dealloc
{
    
}


-(void)removeRecordAudioTipView
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    microphoneImageView = nil;
    volumeImageView = nil;
    cancelImageView = nil;
    tipLabel = nil;
    excalmatoryMarkLabel = nil;
    [self removeFromSuperview];
}


-(void)createView
{
    backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
    [self addSubview:backgroundView];
     [[backgroundView layer]setCornerRadius:6.0];//圆角
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 160));
        make.center.equalTo(self);
    }];
    
    microphoneImageView = [[UIImageView alloc]init];
    microphoneImageView.image = [UIImage imageInUIToolKitProject:@"聊天语音-icon-话筒.png"];
    [backgroundView addSubview:microphoneImageView];
    
    [microphoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 90));
        make.left.equalTo(backgroundView.mas_left).offset(8);
        make.centerY.equalTo(backgroundView.mas_centerY);
    }];
    
    volumeImageView = [[UIImageView alloc]init];
    volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-1.png"];
    [backgroundView addSubview:volumeImageView];
    [volumeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 75));
        make.right.equalTo(backgroundView.mas_right).offset(-8);
        make.centerY.equalTo(microphoneImageView.mas_centerY);
    }];

    
    cancelImageView = [[UIImageView alloc]init];
    cancelImageView.image = [UIImage imageInUIToolKitProject:@"聊天语音-icon-取消.png"];
    [backgroundView addSubview:cancelImageView];
    
    [cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 90));
        make.center.equalTo(backgroundView);
    }];
    
    excalmatoryMarkLabel = [[UILabel alloc]init];
    excalmatoryMarkLabel.font = [UIFont boldSystemFontOfSize:56];
    excalmatoryMarkLabel.backgroundColor = [UIColor clearColor];
    excalmatoryMarkLabel.textColor = [UIColor whiteColor];
    excalmatoryMarkLabel.text = @"!";
    excalmatoryMarkLabel.textAlignment = NSTextAlignmentCenter;
    excalmatoryMarkLabel.hidden = YES;
    [backgroundView addSubview:excalmatoryMarkLabel];
    
    [excalmatoryMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(backgroundView);
    }];
    
    tipLabel = [[UILabel alloc]init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = CancelSlideTipString;
    [backgroundView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.width.equalTo(backgroundView);
        make.left.equalTo(backgroundView.mas_left).offset(0);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(0);
    }];
    [self customView];
}

-(void)customView
{
    
}

-(void)showRecordAudioTipView
{
    microphoneImageView.hidden = NO;
    volumeImageView.hidden=NO;
    cancelImageView.hidden = YES;
    excalmatoryMarkLabel.hidden = YES;
    tipLabel.text = CancelSlideTipString;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showSlideCancelTip
{
    microphoneImageView.hidden = YES;
    volumeImageView.hidden=YES;
    cancelImageView.hidden = NO;
    excalmatoryMarkLabel.hidden = YES;
    tipLabel.text = CancelLoosenTipString;
}

-(void)hiddenRecordAudioTipView:(BOOL)isTipInsufficientTime
{
    if (isTipInsufficientTime==YES) {
        microphoneImageView.hidden = YES;
        volumeImageView.hidden=YES;
        cancelImageView.hidden = YES;
        excalmatoryMarkLabel.hidden = NO;
        tipLabel.text = InsufficientTimeString;
        [self performSelector:@selector(hiddenRecordAudioView) withObject:nil afterDelay:1.25];
    }
    else
    {
        [self hiddenRecordAudioView];
    }
}

-(void)hiddenRecordAudioView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)applicationDidEnterBackgroundFlowMonitor
{
    [self hiddenRecordAudioTipView:NO];
}

//录音时的音量显示 0～1
-(void)setvolumeImageView:(double)voiceSound
{
    if (voiceSound<0.2) {
        volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-1.png"];
    }
    else if (voiceSound>=0.2 && voiceSound<0.4)
    {
        volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-2.png"];
    }
    else if (voiceSound>=0.4 && voiceSound<0.6)
    {
        volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-3.png"];
    }
    else if (voiceSound>=0.6 && voiceSound<0.8)
    {
        volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-4.png"];
    }
    else
    {
        volumeImageView.image = [UIImage imageInUIToolKitProject:@"音量-5.png"];
    }
}

@end
