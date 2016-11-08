//
//  NDKeyBoard.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/6.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDKeyBoard.h"
#import "NDKeyBoardMenu.h"
#import "NDKeyBoardPhotoPicker.h"

@interface NDKeyBoard()<NDKeyBoardMenuDelegate,NDKeyBoardPhotoPickerDelegate>{
    NDKeyBoardMenu *menu; //菜单
    UIView *contentView; //内容
    NDKeyBoardPhotoPicker *photoPicker;
}

@end

@implementation NDKeyBoard

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
        menu = [[NDKeyBoardMenu alloc ] initWithFrame:CGRectMake(0, 0, frame.size.width, NDUI_TOOL_BAR_HEIGHT) funcFlag:funcFlag];
        menu.delegate = self;
        [self addSubview:menu];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, menu.height, frame.size.width, frame.size.height - NDUI_TOOL_BAR_HEIGHT)];
        [self addSubview:contentView];
    }
    return self;
}

/**
 *  移除内容
 */
-(void)clearContentView
{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


/**
 *  文本输入点击
 *
 *  @param menu 菜单
 */
-(void)textDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"文本输入点击");
}

/**
 *  摄像头点击
 *
 *  @param menu 菜单
 */
-(void)cameraDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"摄像头点击");
}


/**
 *  图片点击
 *
 *  @param menu 菜单
 */
-(void)photoDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    if (photoPicker == nil) {
        photoPicker = [[NDKeyBoardPhotoPicker alloc] initWithFrame:contentView.bounds];
        photoPicker.delegate = self;
    }
    [contentView addSubview:photoPicker];
}

#pragma mark - NDKeyBoardPhotoPicker delegate
-(void)didPickedImages:(NSArray *)images pickerView:(NDKeyBoardPhotoPicker *)pickerView
{
    for (NDAsset *asset in images) {
        NSLog(@"%@",[asset fullScreenImage]);
    }
}


/**
 *  表情点击
 *
 *  @param menu 菜单
 */
-(void)emotDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"表情点击");
}


/**
 *  声音点击
 *
 *  @param menu 菜单
 */
-(void)voiceDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"声音点击");
}

/**
 *  gif点击
 *
 *  @param menu 菜单
 */
-(void)gifDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"gif点击");
}

/**
 *  更多点击
 *
 *  @param menu 菜单
 */
-(void)moreDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"更多点击");
}

/**
 *  支持点击
 *
 *  @param menu 菜单
 */
-(void)supportDidClick:(NDKeyBoardMenu *)menu
{
    [self clearContentView];
    NSLog(@"支持点击");
}


@end
