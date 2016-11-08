//
//  NDPhotoEditToolbar.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoEditToolbar.h"

@interface NDPhotoEditToolbar(){
    UIButton *textBtn;  ///< 文本输入
    UIButton *handWriteBtn;  ///< 手写输入
}

@end

@implementation NDPhotoEditToolbar

@synthesize toolbarStatus;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:NDUI_COLOR_F8F8F8];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"ADADAD"];
        [self addSubview:line];
        
        textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        textBtn.frame = CGRectMake((self.width / 2.0 - self.height)/2.0, 0, self.height, self.height);
        [textBtn addTarget:self action:@selector(textClick:) forControlEvents:UIControlEventTouchUpInside];
        [textBtn setImage:[UIImage imageInUIToolKitProject:@"tools_text_icon"] highLightImage:[UIImage imageInUIToolKitProject:@"tools_text_icon_selected"]];
        [self addSubview:textBtn];
        
        
        handWriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        handWriteBtn.frame = CGRectMake(self.width / 2.0  + (self.width / 2.0 - self.height)/2.0, 0, self.height, self.height);
        [handWriteBtn addTarget:self action:@selector(handWriteClick:) forControlEvents:UIControlEventTouchUpInside];
        [handWriteBtn setImage:[UIImage imageInUIToolKitProject:@"tools_draw_icon"] highLightImage:[UIImage imageInUIToolKitProject:@"tools_draw_icon_selected"]];
        [self addSubview:handWriteBtn];
        
        textBtn.NDHighLight = YES;
        
        toolbarStatus = NDUI_EDIT_TOOLBAR_STATUS_TEXT; //初始默认文本输入
    }
    return self;
}

#pragma mark 文本输入点击
-(void)textClick:(id)sender
{
    if (toolbarStatus != NDUI_EDIT_TOOLBAR_STATUS_TEXT) {
        textBtn.NDHighLight = YES;
        handWriteBtn.NDHighLight = NO;
        if ([self.delegate respondsToSelector:@selector(didEditToolbarStatusChange:)]) {
            [self.delegate didEditToolbarStatusChange:NDUI_EDIT_TOOLBAR_STATUS_TEXT];
        }
    }
    toolbarStatus = NDUI_EDIT_TOOLBAR_STATUS_TEXT;
}

#pragma mark 手写输入点击
-(void)handWriteClick:(id)sender
{
    if (toolbarStatus != NDUI_EDIT_TOOLBAR_STATUS_HANDWRITE) {
        textBtn.NDHighLight = NO;
        handWriteBtn.NDHighLight = YES;
        if ([self.delegate respondsToSelector:@selector(didEditToolbarStatusChange:)]) {
            [self.delegate didEditToolbarStatusChange:NDUI_EDIT_TOOLBAR_STATUS_HANDWRITE];
        }
    }
    toolbarStatus = NDUI_EDIT_TOOLBAR_STATUS_HANDWRITE;
}


@end
