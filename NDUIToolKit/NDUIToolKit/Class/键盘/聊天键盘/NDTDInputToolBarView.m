//
//  NDTDInputToolBarView.m
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputToolBarView.h"
#import "NDTDInputMenuView.h"
#import "NDTDTextView.h"

@interface NDTDInputToolBarView ()<NDTDInputMenuViewDelegate,UITextViewDelegate>
{
    UIImageView *menulineImageView;
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}
@property (nonatomic) CGFloat version;
@end

@implementation NDTDInputToolBarView
@synthesize backgroundImageView;
@synthesize menuView;
@synthesize menuBtn;
@synthesize faceBtn;
@synthesize atButton;
@synthesize wordBtn;
@synthesize voiceBtn;
@synthesize recordVoiceBtn;
@synthesize extensionBtn;
@synthesize textView;
@synthesize maxTextInputViewHeight;
@synthesize toolBarType;
@synthesize currentActionType;
@synthesize delegate;
@synthesize isInputAt = _isInputAt;
@synthesize maxTextNumber = _maxTextNumber;
@synthesize isTrimmingCharactersInSet = _isTrimmingCharactersInSet;

-(instancetype)initWithFrame:(CGRect)frame inputToolBarType:(InputToolBarType)inputToolBarType
{
    self = [super initWithFrame:frame];
    if (self) {
        toolBarType = inputToolBarType;
        [self setupConfigure];
        //[self performSelector:@selector(createView) withObject:nil afterDelay:0.001];
        [self createView];
    }
    return self;
}

+(instancetype)inputToolBarWithType:(InputToolBarType)toolBarType
{
    NDTDInputToolBarView *toolBarView = [[NDTDInputToolBarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, InputToolBarHeight) inputToolBarType:toolBarType];
    return toolBarView;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        toolBarType = FACE_WORDS_VOICE_EXTENSION;
        [self setupConfigure];
        //[self performSelector:@selector(createView) withObject:nil afterDelay:0.001];
        [self createView];
    }
    return self;
}

-(void)setIsInputAt:(BOOL)isInputAt
{
    _isInputAt = isInputAt;
}

- (void)setupConfigure
{
    _isInputAt = NO;
    _maxTextNumber = -1;
    _isTrimmingCharactersInSet = NO;
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    currentActionType = InputBarActionTypeNone;
    [self addKeyboardObserve];
}


-(void)createView
{
    backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame), InputToolBarHeight)];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = [[UIImage imageInUIToolKitProject:backgroundImageName]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundImageView];
    
    menuView = [[NDTDInputMenuView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), InputToolBarHeight)];
    menuView.delegate = self;
    menuView.hidden = YES;
    menuView.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:menuView];
    
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8,(InputToolBarHeight-19)/2, 20, 19);
    [menuBtn addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setBackgroundImage:[UIImage imageInUIToolKitProject:menuBtnName] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageInUIToolKitProject:menuBtnName] forState:UIControlStateHighlighted];
    [backgroundImageView addSubview:menuBtn];
    
    menulineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuBtn.frame)+8, 5, 1, InputToolBarHeight-10)];
    menulineImageView.image = [UIImage imageInUIToolKitProject:@"底栏-内容输入栏TAB-分割线"];
    [backgroundImageView addSubview:menulineImageView];
    
    //语音与键盘按钮
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(CGRectGetMaxX(menulineImageView.frame)+5,(InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith,AllBtnHeight);
    [voiceBtn setImage:[UIImage imageInUIToolKitProject:voiceBtnNormalName] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageInUIToolKitProject:voiceBtnHighlightName] forState:UIControlStateHighlighted];
    [voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:voiceBtn];
    
    //扩展按钮
    extensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    extensionBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-ALLBtnWith-5, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith,AllBtnHeight);
    [extensionBtn setImage:[UIImage imageInUIToolKitProject:extensionBtnNormalName] forState:UIControlStateNormal];
    [extensionBtn setImage:[UIImage imageInUIToolKitProject:extensionBtnHighlightName] forState:UIControlStateHighlighted];
    [extensionBtn addTarget:self action:@selector(extensionAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:extensionBtn];
    
    //表情按钮
    faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(CGRectGetMinX(extensionBtn.frame)-8-ALLBtnWith, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith,AllBtnHeight);
    [faceBtn setImage:[UIImage imageInUIToolKitProject:faceBtnNormalName] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageInUIToolKitProject:faceBtnHighlightName] forState:UIControlStateHighlighted];
    [faceBtn addTarget:self action:@selector(expressionAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:faceBtn];
    
    //表情按钮
    atButton = [UIButton buttonWithType:UIButtonTypeCustom];
    atButton.frame = CGRectMake(CGRectGetMinX(extensionBtn.frame)-8-ALLBtnWith, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith,AllBtnHeight);
    [atButton setImage:[UIImage imageInUIToolKitProject:aTBtnNormalName] forState:UIControlStateNormal];
    [atButton setImage:[UIImage imageInUIToolKitProject:aTBtnHighlightName] forState:UIControlStateHighlighted];
    [atButton addTarget:self action:@selector(atAction) forControlEvents:UIControlEventTouchUpInside];
    [atButton setTitle:@"@" forState:UIControlStateNormal];
    [backgroundImageView addSubview:atButton];

    textView = [[NDTDTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(voiceBtn.frame)+8, 5, self.frame.size.width-CGRectGetMaxX(voiceBtn.frame)-ALLBtnWith*2-8-8-8-5, kInputTextViewMinHeight)];
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    textView.layer.borderWidth = 0.65f;
    textView.layer.cornerRadius = 4.0f;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically=YES;
    [backgroundImageView addSubview:textView];
    _previousTextViewContentHeight = [self getTextViewContentH:textView];
    
    recordVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordVoiceBtn setTitle:kTouchToRecord forState:UIControlStateNormal];
    recordVoiceBtn.hidden = YES;
    [recordVoiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
    recordVoiceBtn.backgroundColor = [UIColor clearColor];
    recordVoiceBtn.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    recordVoiceBtn.layer.borderWidth = 0.65f;
    recordVoiceBtn.layer.cornerRadius = 4.0f;
    [recordVoiceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"BBBBBB"] size:CGSizeMake(textView.frame.size.width, textView.frame.size.height)] forState:UIControlStateHighlighted];
    [backgroundImageView addSubview:recordVoiceBtn];
    
    //录音按钮事件
    [recordVoiceBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [recordVoiceBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [recordVoiceBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [recordVoiceBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [recordVoiceBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];

    [self differentTypesOfDisplay];
    [self customView];
    
}


-(void)setToolBarType:(InputToolBarType)toolBarTypes
{
    toolBarType = toolBarTypes;
    [self differentTypesOfDisplay];
}

//不同类型的展示
-(void)differentTypesOfDisplay
{
    switch (toolBarType) {
        case MENU_FACE_WORDS_VOICE_EXTENSION:
            atButton.hidden = YES;
            break;
        case FACE_WORDS_VOICE_EXTENSION:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            menuView.hidden = YES;
            voiceBtn.frame = CGRectMake(8, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            textView.frame = CGRectMake(CGRectGetMaxX(voiceBtn.frame)+8, 5, self.frame.size.width-CGRectGetMaxX(voiceBtn.frame)-ALLBtnWith*2-8-8-8-5, kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case FACE_WORDS_VOICE:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            extensionBtn.hidden = YES;
            menuView.hidden = YES;
            voiceBtn.frame = CGRectMake(8, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            faceBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-ALLBtnWith-8, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            textView.frame = CGRectMake(CGRectGetMaxX(voiceBtn.frame)+8, 5, self.frame.size.width-CGRectGetMaxX(voiceBtn.frame)-ALLBtnWith-8-8-8,kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case FACE_WORDS_EXTENSION:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            menuView.hidden = YES;
            textView.frame = CGRectMake(8, 5, self.frame.size.width-ALLBtnWith*2-8-8-8-5,kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case FACE_WORDS:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            menuView.hidden = YES;
            extensionBtn.hidden = YES;
            faceBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-ALLBtnWith-8, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            textView.frame = CGRectMake(8, 5, self.frame.size.width-ALLBtnWith-8-8-8,kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case WORDS_EXTENSION:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            faceBtn.hidden = YES;
            menuView.hidden = YES;
            extensionBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-ALLBtnWith-8, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            textView.frame = CGRectMake(8, 5, self.frame.size.width-ALLBtnWith-8-8-8,kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case FACE_AT:
            menuBtn.hidden = YES;
            atButton.hidden = NO;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            extensionBtn.hidden = YES;
            textView.hidden = YES;
            menuView.hidden = YES;
            faceBtn.frame = CGRectMake(20, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            atButton.frame = CGRectMake(faceBtn.frame.origin.x+faceBtn.width+10, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            //[self removeKeyboardObserve];
            break;

        case FACE:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            extensionBtn.hidden = YES;
            textView.hidden = YES;
            menuView.hidden = YES;
            faceBtn.frame = CGRectMake(20, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            //[self removeKeyboardObserve];

            break;
        case WORDS:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            extensionBtn.hidden = YES;
            faceBtn.hidden = YES;
            menuView.hidden = YES;
            textView.frame = CGRectMake(12, (InputToolBarHeight-kInputTextViewMinHeight)/2, self.frame.size.width-24, kInputTextViewMinHeight);
            recordVoiceBtn.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            break;
        case EXTENSION:
            menuBtn.hidden = YES;
            atButton.hidden = YES;
            menulineImageView.hidden = YES;
            voiceBtn.hidden = YES;
            faceBtn.hidden = YES;
            textView.hidden=YES;
            menuView.hidden = YES;
            extensionBtn.frame = CGRectMake(20, (InputToolBarHeight-AllBtnHeight)/2, ALLBtnWith, AllBtnHeight);
            //[self removeKeyboardObserve];
            break;
        default:
            break;
    }
}


-(void)customView
{
    
}


#pragma mark -事件相关

-(void)setText:(NSString *)text
{
    textView.text = text;
    [self textViewDidChange:textView];
}

-(void)menuAction
{
    [UIView animateWithDuration:0.25 animations:^{
        if (menuView.frame.origin.y == CGRectGetMaxY(self.frame)) {
            menuView.hidden = NO;
            self.hidden = YES;
            menuView.frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y-InputToolBarHeight, menuView.frame.size.width, menuView.frame.size.height);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+InputToolBarHeight, CGRectGetWidth(self.frame), self.frame.size.height);
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeMenu];
        }
        else
        {
            menuView.hidden = YES;
            self.hidden = NO;
            menuView.frame = CGRectMake(menuView.frame.origin.x,menuView.frame.origin.y+InputToolBarHeight, menuView.frame.size.width, menuView.frame.size.height);
             self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-InputToolBarHeight, self.frame.size.width, self.frame.size.height);
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeNone];

        }
        
    } completion:^(BOOL finished) {
        
    }];
}


//语音
-(void)voiceAction
{
    if (recordVoiceBtn.hidden==YES) {
        [self textAndVoiceIconSwitch:YES];
        [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeRecordAudio];
    }
    else
    {
        [self textAndVoiceIconSwitch:NO];
        [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeInputText];
    }
}



-(void)textAndVoiceIconSwitch:(BOOL)isVoice
{
    if (toolBarType!=FACE && toolBarType != EXTENSION) {
        textView.hidden = isVoice;
    }
    recordVoiceBtn.hidden = !isVoice;
    if (isVoice==YES) {
        [voiceBtn setImage:[UIImage imageInUIToolKitProject:keyboardNormalName] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageInUIToolKitProject:keyboardHighlightName] forState:UIControlStateHighlighted];
    }
    else
    {
        [voiceBtn setImage:[UIImage imageInUIToolKitProject:voiceBtnNormalName] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageInUIToolKitProject:voiceBtnHighlightName] forState:UIControlStateHighlighted];
    }
}

-(void)keyboardAndFaceIconSwitch:(BOOL)isFace
{
    if (isFace == YES || toolBarType == FACE) {
        [faceBtn setImage:[UIImage imageInUIToolKitProject:faceBtnNormalName] forState:UIControlStateNormal];
        [faceBtn setImage:[UIImage imageInUIToolKitProject:faceBtnHighlightName] forState:UIControlStateHighlighted];
    }
    else
    {
        [faceBtn setImage:[UIImage imageInUIToolKitProject:keyboardNormalName] forState:UIControlStateNormal];
        [faceBtn setImage:[UIImage imageInUIToolKitProject:keyboardHighlightName] forState:UIControlStateHighlighted];
    }
}

//@按钮事件
-(void)atAction
{
    if ([delegate respondsToSelector:@selector(didAtRane:)]) {
        [delegate didAtRane:NSMakeRange(textView.text.length, 1)];
    }
}

//表情按钮事件
-(void)expressionAction
{
    if (currentActionType==InputBarActionTypeChooseEmoji) {
        [self keyboardAndFaceIconSwitch:YES];
        if (toolBarType == FACE) {
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeNone];
        }
        else
        {
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeInputText];
        }
    }
    else
    {
        [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeChooseEmoji];
    }
}

//扩展按钮事件
-(void)extensionAction
{
    if (currentActionType==InputBarActionTypeExpandPanel) {
        if (toolBarType == EXTENSION) {
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeNone];
        }
        else
        {
            [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeInputText];
        }
    }
    else
    {
        [self inputBarChangeActionTypeDeal:currentActionType nowType:InputBarActionTypeExpandPanel];
    }
}


//状态变化处理
-(void)inputBarChangeActionTypeDeal:(InputBarActionType)originalType nowType:(InputBarActionType)nowType
{
    if (originalType!=nowType) {
        currentActionType = nowType;
        if (delegate && [delegate respondsToSelector:@selector(didToolBarChangeCurrentActionType:)]) {
            [delegate didToolBarChangeCurrentActionType:nowType];
        };
    }
}


#pragma mark - NDTDInputMenuViewDelegate
//点击菜单切换
-(void)didMenuActionSwitch:(NDTDInputMenuView *)menuView
{
    [self menuAction];
}

#pragma mark -键盘监听
-(void)addKeyboardObserve
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)removeKeyboardObserve
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    if (noti==nil || noti.userInfo.count==0) {
        return;
    }
    CGRect keyboardBeginFrame = [noti.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboardEndFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    if ([delegate respondsToSelector:@selector(didKeyboardChangeFrame:keyboardEndFrame:duration:isAnimation:)]) {
        [delegate didKeyboardChangeFrame:keyboardBeginFrame keyboardEndFrame:keyboardEndFrame duration:duration isAnimation:YES];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textViews
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textViews
{
    currentActionType =  InputBarActionTypeInputText;
    [self keyboardAndFaceIconSwitch:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textViews
{
    [textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textViews shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            NSString *string = @"";
            if (_isTrimmingCharactersInSet == YES) {
                string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            else
            {
                string = [self.textView.text copy];
            }
            [self.delegate didSendText:string];
            if (_maxTextNumber<=0 || string.length<_maxTextNumber) {
                self.textView.text = @"";
            }
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.textView]];;
        }
         return NO;
    }
    if ([text isEqualToString:@"@"] && _isInputAt == YES) {
        if ([delegate respondsToSelector:@selector(didAtRane:)]) {
            
            [delegate didAtRane:textView.selectedRange];
        }
    }

    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textViews
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textViews]];
    if ([delegate respondsToSelector:@selector(didTextViewDidChange:)]) {
        [delegate didTextViewDidChange:textViews.text];
    }
}


#pragma mark -文本高度变化

- (CGFloat)getTextViewContentH:(UITextView *)textViews
{
    if (self.version >= 7.0)
    {
        return ceilf([textViews sizeThatFits:textView.frame.size].height);
    } else {
        return textViews.contentSize.height;
    }

}

- (void)willShowInputCurrentTextView:(NDTDTextView *)textViews
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textViews]];
}


- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else
    {
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        textView.frame = CGRectMake(textView.frame.origin.x, 5, textView.frame.size.width, self.frame.size.height-10);
        
        if (self.version < 7.0) {
            [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        if (delegate && [delegate respondsToSelector:@selector(didToolBarChangeFrameToHeight:)]) {
            [delegate didToolBarChangeFrameToHeight:changeHeight];
        }

    }

}

#pragma mark -录音按钮事件
- (void)recordButtonTouchDown
{
    if (delegate && [delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:UIControlEventTouchDown];
    }
}

- (void)recordButtonTouchUpOutside
{
    if (delegate && [delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:UIControlEventTouchUpOutside];
    }
}

- (void)recordButtonTouchUpInside
{
    if (delegate && [delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:UIControlEventTouchUpInside];
    }
}

- (void)recordDragOutside
{
    if (delegate && [delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:UIControlEventTouchDragOutside];
    }
}

- (void)recordDragInside
{
    if (delegate && [delegate respondsToSelector:@selector(didChangeRecordVoiceAction:)]) {
        [delegate didChangeRecordVoiceAction:UIControlEventTouchDragInside];
    }
}


-(void)dealloc
{
    [self removeKeyboardObserve];
}



@end
