//
//  NDKeyBoardMenu.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/6.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDKeyBoardMenu.h"
#import "UIImage+Resource.h"

@interface NDKeyBoardMenu(){
    UIButton *_btnText;  ///< 文字
    UIButton *_btnCamera;  ///< 拍照
    UIButton *_btnPhoto;  ///< 图片
    UIButton *_btnEmot;  ///< 表情
    UIButton *_btnVoice;  ///< 声音
    UIButton *_btnGif;  ///< gif
    UIButton *_btnMore;  ///< 更多
    UIButton *_btnSupport;  ///< 支持
    NSMutableArray *btnArray;
}




@end

@implementation NDKeyBoardMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame funcFlag:(NSString *)funcFlag
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
        if ([funcFlag isMatch:@"[0-1](\\|[0-1])*"]) {
            NSArray *funcFlags = [funcFlag componentsSeparatedByString:@"|"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0 ; i < funcFlags.count ; i++) {
                if ([funcFlags[i] boolValue] == YES) {
                    [tempArray addObject:btnArray[i]];
                }
            }
            
            [btnArray removeAllObjects];
            btnArray = tempArray;
            
            CGFloat itemWidth = self.width / 8.0;
            CGFloat itemHeight = self.height;
            CGFloat tb = (itemHeight - 32.0)/2.0;
            CGFloat fr = (itemWidth - 32.0)/2.0;
            UIButton *menuBtn = nil;
            for ( NSInteger i = 0 ; i < btnArray.count ; i++) {
                menuBtn = btnArray[i];
                menuBtn.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
                [menuBtn setImageEdgeInsets:UIEdgeInsetsMake(tb, fr, tb, fr)];
                [self addSubview:menuBtn];
            }
        }
    }
    return self;
}

-(void)createView
{
    _btnText = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnText addTarget:self action:@selector(textClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCamera addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnPhoto addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnEmot = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnEmot addTarget:self action:@selector(emotClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnVoice addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnGif = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnGif addTarget:self action:@selector(gifClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMore addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnSupport = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSupport addTarget:self action:@selector(supportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnText setImage:[UIImage imageInUIToolKitProject:@"composerTabBarText"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarTextSelected"]];
    [_btnCamera setImage:[UIImage imageInUIToolKitProject:@"composerTabBarCamera"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarCameraSelected"]];
    [_btnPhoto setImage:[UIImage imageInUIToolKitProject:@"composerTabBarPhotos"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarPhotosSelected"]];
    [_btnEmot setImage:[UIImage imageInUIToolKitProject:@"composerTabBarStickers"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarStickersSelected"]];
    [_btnVoice setImage:[UIImage imageInUIToolKitProject:@"composerTabBarAudio"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarAudioSelected"]];
    [_btnGif setImage:[UIImage imageInUIToolKitProject:@"composerTabBarGIF"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarGIFSelected"]];
    [_btnMore setImage:[UIImage imageInUIToolKitProject:@"composerTabBarMore"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarMoreSelected"]];
    [_btnSupport setImage:[UIImage imageInUIToolKitProject:@"composerTabBarLikeDisabled"] highLightImage:[UIImage imageInUIToolKitProject:@"composerTabBarLike"]];
    
    btnArray = [[NSMutableArray alloc] init];
    [btnArray addObject:_btnText];
    [btnArray addObject:_btnCamera];
    [btnArray addObject:_btnPhoto];
    [btnArray addObject:_btnEmot];
    [btnArray addObject:_btnVoice];
    [btnArray addObject:_btnGif];
    [btnArray addObject:_btnMore];
    [btnArray addObject:_btnSupport];
    
}

#pragma mark 文本输入点击
-(void)textClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(textDidClick:)]) {
        [self.delegate textDidClick:self];
    }
}

#pragma mark 摄像头点击
-(void)cameraClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cameraDidClick:)]) {
        [self.delegate cameraDidClick:self];
    }
}

#pragma mark 图片点击
-(void)photoClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(photoDidClick:)]) {
        [self.delegate photoDidClick:self];
    }
}

#pragma mark 表情点击
-(void)emotClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(emotDidClick:)]) {
        [self.delegate emotDidClick:self];
    }
}

#pragma mark 声音点击
-(void)voiceClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(voiceDidClick:)]) {
        [self.delegate voiceDidClick:self];
    }
}

#pragma mark gif点击
-(void)gifClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(gifDidClick:)]) {
        [self.delegate gifDidClick:self];
    }
}

#pragma mark 更多点击
-(void)moreClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(moreDidClick:)]) {
        [self.delegate moreDidClick:self];
    }
}

#pragma mark 支持点击
-(void)supportClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(supportDidClick:)]) {
        [self.delegate supportDidClick:self];
    }
}

@end
