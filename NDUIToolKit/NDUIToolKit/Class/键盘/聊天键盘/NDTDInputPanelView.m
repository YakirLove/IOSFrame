//
//  NDTDInputPanelView.m
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputPanelView.h"

@interface NDTDInputPanelView ()<NDTDInputToolBarViewDelegate,NDTDInputFacePanelViewDelegate,NDTDInputMoreViewDelegate>
{
    InputToolBarType toolBarType;
}

@end

@implementation NDTDInputPanelView
@synthesize toolBarView;
@synthesize moreView;
@synthesize faceView;
@synthesize recordAudioTipView;
@synthesize placeHolder;
@synthesize delegate;
@synthesize text;
@synthesize isInputAt = _isInputAt;
@synthesize maxTextNumber = _maxTextNumber;
@synthesize isTrimmingCharactersInSet = _isTrimmingCharactersInSet;

-(instancetype)initWithFrame:(CGRect)frame toolBarType:(InputToolBarType)toolBarTypes
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setObserver];
        _isInputAt = NO;
        _maxTextNumber = -1;
        _isTrimmingCharactersInSet = NO;
        toolBarType = toolBarTypes;
        placeHolder = @"";
        [self createView:toolBarTypes];
    }
    return self;
}

-(void)setPlaceHolder:(NSString *)placeHolders
{
    placeHolder = placeHolders;
    toolBarView.textView.placeHolder = placeHolder;
}

-(void)setText:(NSString *)texts
{
    text = texts;
    [toolBarView setText:text];
}

-(void)setIsInputAt:(BOOL)isInputAt
{
    _isInputAt = isInputAt;
    [toolBarView setIsInputAt:_isInputAt];
}

-(void)setMaxTextNumber:(NSInteger)maxTextNumber
{
    _maxTextNumber = maxTextNumber;
    toolBarView.maxTextNumber = _maxTextNumber;
}

-(void)setIsTrimmingCharactersInSet:(BOOL)isTrimmingCharactersInSet
{
    _isTrimmingCharactersInSet = isTrimmingCharactersInSet;
    toolBarView.isTrimmingCharactersInSet = _isTrimmingCharactersInSet;
}


-(void)setObserver
{
    //添加self.frame变化监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
}

+(instancetype)inputPanelViewWithType:(InputToolBarType)toolBarType
{
    NDTDInputPanelView *inputPanelView = [[NDTDInputPanelView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-InputToolBarHeight-NavigationHeight, [UIScreen mainScreen].bounds.size.width, InputToolBarHeight+216) toolBarType:toolBarType];
    return inputPanelView;
}


-(void)createView:(InputToolBarType)toolBarTypes
{
    toolBarView = [NDTDInputToolBarView inputToolBarWithType:toolBarTypes];
    toolBarView.isInputAt = _isInputAt;
    toolBarView.maxTextNumber = _maxTextNumber;
    toolBarView.isTrimmingCharactersInSet = _isTrimmingCharactersInSet;
    toolBarView.delegate = self;
    [self addSubview:toolBarView];
    
    moreView = [[NDTDInputMoreView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(toolBarView.frame)+216, self.frame.size.width, 216)];
    moreView.delegate = self;
    moreView.backgroundColor = [UIColor whiteColor];
    [self addSubview:moreView];
    
    faceView = [[NDTDInputFacePanelView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(toolBarView.frame), self.frame.size.width, 216)];
    faceView.delegate = self;
    faceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:faceView];

    recordAudioTipView = [[NDTDInputRecordAudioTipView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    recordAudioTipView.backgroundColor = [UIColor clearColor];
    recordAudioTipView.alpha = 0.0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:recordAudioTipView];
    [self differentTypesOfDisplay];

}

//不同类型的展示
-(void)differentTypesOfDisplay
{
    switch (toolBarType) {
        case MENU_FACE_WORDS_VOICE_EXTENSION:
            
            break;
        case FACE_WORDS_VOICE_EXTENSION:
            break;
        case FACE_WORDS_VOICE:
 
            break;
        case FACE_WORDS_EXTENSION:
            [recordAudioTipView removeFromSuperview];
            break;
        case FACE_WORDS:
            [recordAudioTipView removeFromSuperview];
            [moreView removeFromSuperview];
            break;
        case WORDS_EXTENSION:
            [faceView removeFromSuperview];
            [recordAudioTipView removeFromSuperview];
            break;
        case FACE:
            [recordAudioTipView removeFromSuperview];
            [moreView removeFromSuperview];
            break;
        case WORDS:
            [faceView removeFromSuperview];
            [recordAudioTipView removeFromSuperview];
            [moreView removeFromSuperview];
            break;
        case EXTENSION:
            [faceView removeFromSuperview];
            [recordAudioTipView removeFromSuperview];
            break;
        default:
            break;
    }

}

-(void)showKeyboard:(BOOL)isAnimation
{
    [toolBarView.textView becomeFirstResponder];
}

-(void)showPanelView:(BOOL)isAnimation
{
    NSTimeInterval time = 0.0;
    if (isAnimation == YES) {
        time = 0.25;
    }
    __weak typeof(self) weakSelf = self;
    float systemScreenHeight = [UIScreen mainScreen].bounds.size.height-NavigationHeight;
    [UIView animateWithDuration:time animations:^{
        weakSelf.frame = CGRectMake(CGRectGetMinX(weakSelf.frame), systemScreenHeight-InputToolBarHeight-MAX(moreView.frame.size.height, faceView.frame.size.height), weakSelf.frame.size.width, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

-(void)showMoreView:(BOOL)isAnimation
{
    faceView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        moreView.frame = CGRectMake(moreView.frame.origin.x, CGRectGetMaxY(toolBarView.frame), moreView.frame.size.width, moreView.frame.size.height);
    } completion:^(BOOL finished) {
        faceView.frame = CGRectMake(faceView.frame.origin.x,CGRectGetMaxY(toolBarView.frame)+moreView.frame.size.height, moreView.frame.size.width, moreView.frame.size.height);
    }];
}

-(void)hiddenMoreView:(BOOL)isAnimation
{
    faceView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        faceView.frame = CGRectMake(faceView.frame.origin.x,CGRectGetMaxY(toolBarView.frame), moreView.frame.size.width, moreView.frame.size.height);
    } completion:^(BOOL finished) {
         moreView.frame = CGRectMake(moreView.frame.origin.x, CGRectGetMaxY(toolBarView.frame)+moreView.frame.size.height, moreView.frame.size.width, moreView.frame.size.height);
    }];

}

-(void)hiddenPanelAndKeyboard:(BOOL)isAnimation
{
    [self hiddenKeyboard:isAnimation];
    [self hiddenPanelView:isAnimation];
    self.toolBarView.currentActionType = InputBarActionTypeNone;
}

-(void)hiddenKeyboard:(BOOL)isAnimation
{
    [toolBarView.textView resignFirstResponder];
}

-(void)hiddenPanelView:(BOOL)isAnimation
{
    __weak typeof(self) weakSelf = self;
    [self.toolBarView keyboardAndFaceIconSwitch:YES];
    float systemScreenHeight = [UIScreen mainScreen].bounds.size.height-NavigationHeight;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = CGRectMake(CGRectGetMinX(weakSelf.frame), systemScreenHeight-InputToolBarHeight, weakSelf.frame.size.width, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
    }];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"] && object == self) {
        if (delegate && [delegate respondsToSelector:@selector(didInputPanelViewChangeFrame:oldFrame:newFrame:)]) {
            CGRect oldRect = [[change objectForKey:@"old"] CGRectValue];
            [delegate didInputPanelViewChangeFrame:self oldFrame:oldRect newFrame:self.frame];
        }
    }
}

#pragma mark -NDTDInputToolBarViewDelegate

/**
 *  输入@的时候的回调，只有isAt=YES才会回调
 *
 *  @param rane @的位置
 */
- (void)didAtRane:(NSRange)rane
{
    if ([delegate respondsToSelector:@selector(didInputAtInputPanelView:rane:text:)]) {
        [delegate didInputAtInputPanelView:self rane:rane text:toolBarView.textView.text];
    }
}

-(void)didTextViewDidChange:(NSString *)texts
{
    if ([NSString isEmptyString:texts]==YES) {
        [faceView setSendButton:UIControlStateNormal];
    }else
    {
        [faceView setSendButton:UIControlStateSelected];
    }
    text = texts;
    if ([delegate respondsToSelector:@selector(didTextViewDidChange:)]) {
        [delegate didTextViewDidChange:text];
    }
    
}

//设置表情发出按钮文字，默认发出
-(void)setFaceSendButtonTitle:(NSString *)title
{
    [faceView setSendButtonTitle:title];
}

-(void)didKeyboardChangeFrame:(CGRect)keyboardBeginFrame keyboardEndFrame:(CGRect)keyboardEndFrame duration:(NSTimeInterval)duration isAnimation:(BOOL)isAnimation
{
    if (isAnimation==NO) {
        duration =0.0;
    }
    __weak typeof(self) weakSelf = self;
    float systemScreenHeight = [UIScreen mainScreen].bounds.size.height-NavigationHeight;
    [UIView animateWithDuration:duration animations:^{
        if (keyboardEndFrame.origin.y == [UIScreen mainScreen].bounds.size.height) {
            if (self.toolBarView.currentActionType == InputBarActionTypeChooseEmoji || self.toolBarView.currentActionType == InputBarActionTypeExpandPanel) {
                weakSelf.frame = CGRectMake(CGRectGetMinX(weakSelf.frame), systemScreenHeight-InputToolBarHeight-MAX(moreView.frame.size.height, faceView.frame.size.height), weakSelf.frame.size.width, weakSelf.frame.size.height);
            }
            else
            {
                weakSelf.frame = CGRectMake(CGRectGetMinX(weakSelf.frame), systemScreenHeight-InputToolBarHeight , weakSelf.frame.size.width, weakSelf.frame.size.height);
            }
        }
        else
        {

            weakSelf.frame = CGRectMake(CGRectGetMinX(weakSelf.frame),systemScreenHeight-InputToolBarHeight-keyboardEndFrame.size.height, weakSelf.frame.size.width, weakSelf.frame.size.height);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didToolBarChangeFrameToHeight:(CGFloat)changeHeight
{
    
}

-(void)didToolBarChangeCurrentActionType:(InputBarActionType)actionType
{
    switch (actionType) {
        case InputBarActionTypeNone:
            [self hiddenPanelAndKeyboard:YES];
            break;
        case InputBarActionTypeMenu:
            [self hiddenKeyboard:YES];
            [self hiddenPanelView:YES];
            break;
        case InputBarActionTypeRecordAudio:
            [self hiddenKeyboard:YES];
            [self hiddenPanelView:YES];
            break;
        case InputBarActionTypeInputText:
            [self.toolBarView textAndVoiceIconSwitch:NO];
            [self.toolBarView keyboardAndFaceIconSwitch:YES];
            [self showKeyboard:YES];
            break;
        case InputBarActionTypeChooseEmoji:
            [self.toolBarView textAndVoiceIconSwitch:NO];
            [self hiddenKeyboard:YES];
            [self.toolBarView keyboardAndFaceIconSwitch:NO];
            [self showPanelView:YES];
            [self hiddenMoreView:YES];
            break;
        case InputBarActionTypeChooseAt:
        
            break;

        case InputBarActionTypeExpandPanel:
            [self.toolBarView textAndVoiceIconSwitch:NO];
            [self.toolBarView keyboardAndFaceIconSwitch:YES];
            [self hiddenKeyboard:YES];
            [self showPanelView:YES];
            [self showMoreView:YES];
            break;
        default:
            break;
    }
    if ([delegate respondsToSelector:@selector(didToolBarChangeCurrentActionType:)]) {
        [delegate didToolBarChangeCurrentActionType:actionType];
    }
}

-(void)didChangeRecordVoiceAction:(UIControlEvents)controlEvents
{
    switch (controlEvents) {
        case UIControlEventTouchDown:
            //按下录音按钮开始录音
            NSLog(@"按下录音按钮开始录音");
            [recordAudioTipView showRecordAudioTipView];
            break;
        case UIControlEventTouchUpOutside:
            //手指向上滑动取消录音
            NSLog(@"手指向上滑动取消录音");
            [recordAudioTipView hiddenRecordAudioTipView:NO];
            break;
        case UIControlEventTouchUpInside:
            //松开完成录音
            NSLog(@"松开完成录音");
            //[recordAudioTipView hiddenRecordAudioTipView:NO];
            break;
        case UIControlEventTouchDragOutside:
            //手指离开按钮的范围
            NSLog(@"手指离开按钮的范围");
            [recordAudioTipView showSlideCancelTip];
            break;
        case UIControlEventTouchDragInside:
            //手指再次进入按钮的范围
            NSLog(@"手指再次进入按钮的范围");
            [recordAudioTipView showRecordAudioTipView];
            break;
            
        default:
            break;
    }
    
    if ([delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:controlEvents];
    }
}

- (void)didSendText:(NSString *)texts
{
    NSString *string = [toolBarView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (_maxTextNumber<=0 || string
        .length<=_maxTextNumber) {
        [toolBarView setText:@""];
        if (delegate && [delegate respondsToSelector:@selector(didClickSendBtnInputFaceMenuView:text:)]) {
            [delegate didClickSendBtnInputFaceMenuView:self text:[NDEmojiUtils emojiEncode:texts]];
        }
    }
    else
    {
        [self hiddenKeyboard:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"输入内容不能超过%ld个字",(NSInteger)_maxTextNumber] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
//        [OMGToast showWithText:[NSString stringWithFormat:@"输入内容不能超过%ld个字",_maxTextNumber] bottomOffset:50.0];
        
    }
}

#pragma mark - NDTDInputFacePanelViewDelegate
//点击删除按钮的回调
-(void)didClickDelete:(NDTDInputFacePictureView *)facePictureView
{
    NSString *texts = toolBarView.textView.text;
    if (texts!=nil && texts.length>0) {
        if ([texts hasSuffix:@"]"]) {
            BOOL isExist=NO;
            for (NSInteger i = texts.length - 1; i>=0; i--) {
                NSString *temp = [texts substringWithRange:NSMakeRange(i, 1)];
                if ([temp isEqualToString:@"["]) { 
                    toolBarView.textView.text=[texts substringToIndex:i];
                    isExist=YES;
                    break;
                }
                else if ([temp isEqualToString:@"]"] && i!=texts.length-1)
                {
                    toolBarView.textView.text=[texts substringToIndex:texts.length-1];
                    break;
                }
            }
            if (isExist==NO) {
                toolBarView.textView.text=[texts substringToIndex:texts.length-1];
            }
        }
        else
        {
            NSInteger index = texts.length-1;
            if (index>=0) {
                toolBarView.textView.text=[texts substringToIndex:index];
            }

        }
        [toolBarView willShowInputCurrentTextView:toolBarView.textView];
    }
}
//点击发送按钮的回调
-(void)didClickSendBtnInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView
{
    NSString *string = @"";
    if (_isTrimmingCharactersInSet == YES) {
        string = [toolBarView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else
    {
        string = [toolBarView.textView.text copy];
    }
    
    if (_maxTextNumber<=0 || string.length<=_maxTextNumber) {
        if (delegate && [delegate respondsToSelector:@selector(didClickSendBtnInputFaceMenuView:text:)]) {
            [delegate didClickSendBtnInputFaceMenuView:self text:[NDEmojiUtils emojiEncode:toolBarView.textView.text]];
        }
        [toolBarView setText:@""];
    }
    else
    {
        [self hiddenKeyboard:YES];
//        [OMGToast showWithText:[NSString stringWithFormat:@"输入内容不能超过%ld个字",_maxTextNumber] bottomOffset:50.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"输入内容不能超过%ld个字",(NSInteger)_maxTextNumber] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//点击表情的回调
-(void)didClickPictureface:(NDTDInputFacePictureView *)facePictureView imagePath:(NSString *)imagePath imageName:(NSString *)imageName
{
    [self setText:[NSString stringWithFormat:@"%@%@",toolBarView.textView.text,imageName]];
    [toolBarView willShowInputCurrentTextView:toolBarView.textView];
    if (delegate && [delegate respondsToSelector:@selector(didClickPictureface:imagePath:imageName:)]) {
        [delegate didClickPictureface:self imagePath:imagePath imageName:imageName];
    }
    if ([NSString isEmptyString:text]==YES) {
        [faceView setSendButton:UIControlStateNormal];
    }else
    {
        [faceView setSendButton:UIControlStateSelected];
    }
}

#pragma mark - NDTDInputMoreViewDelegate
-(void)didPickedImagePaths:(NDTDInputMoreView *)inputMoreView imagePaths:(NSMutableArray *)imagePaths
{
    if([delegate respondsToSelector:@selector(didPickedImagePaths:imagePaths:)])
    {
        [delegate didPickedImagePaths:self imagePaths:imagePaths];
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame" context:nil];
    [recordAudioTipView removeRecordAudioTipView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint toolBarPoint = [toolBarView convertPoint:point fromView:self];
    if ([toolBarView pointInside:toolBarPoint withEvent:event]) {
        return YES;
    }
    BOOL isPoint=[super pointInside:point withEvent:event];
    return isPoint;
}



@end
