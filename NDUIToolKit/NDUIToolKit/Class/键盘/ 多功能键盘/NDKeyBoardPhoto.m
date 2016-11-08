//
//  NDKeyBoardPhoto.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDKeyBoardPhoto.h"
#import "UIImageView+LBBlurredImage.h"

#define ND_KEYBOARD_PHOTO_SCALE_SIZE 1.5
#define ND_KEYBOARD_PHOTO_BTN_SIZE 60
#define ND_KEYBOARD_PHOTO_BTN_SPACE 30

@interface NDKeyBoardPhoto(){
    UIImageView *backView; ///< 背景图
    UIView *editView;  ///< 编辑蒙版
}

@end

@implementation NDKeyBoardPhoto

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        
        backView = [[UIImageView alloc] initWithFrame:self.bounds];
        backView.contentMode = UIViewContentModeScaleAspectFill;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        
    }
    return self;
}

/**
 *  处理按钮
 *
 *  @param frame 位置信息
 *
 *  @return 处理按钮
 */
-(UIButton *)dealBtn:(CGRect)frame
{
    UIButton *dealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dealBtn.frame = frame;
    [dealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dealBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    dealBtn.layer.cornerRadius = dealBtn.width / 2.0;
    dealBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    dealBtn.layer.borderWidth = 1.0f;
    return dealBtn;
}

#pragma mark 移除编辑视图
-(void)removeEditView
{
    [self removeEditViewWithBlock:^{}];
}


#pragma mark 移除编辑视图
-(void)removeEditViewWithBlock:(void (^)(void))block
{
    [UIView animateWithDuration:0.3 animations:^{
        editView.transform = CGAffineTransformMakeScale(ND_KEYBOARD_PHOTO_SCALE_SIZE, ND_KEYBOARD_PHOTO_SCALE_SIZE);
        [editView setAlpha:0.2];
    } completion:^(BOOL finished) {
        [editView removeFromSuperview];
        editView = nil;
        block();
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

/**
 *  图片点击
 *
 *  @param tgr 手势
 */
-(void)photoClick:(UITapGestureRecognizer *)tgr
{
    if (tgr.view == self) {
        if ([self.delegate respondsToSelector:@selector(didBecomeEditStatus:)]) {
            [self.delegate didBecomeEditStatus:self];
        }
        [self createEditView];
        [self addSubview:editView];
        editView.transform = CGAffineTransformMakeScale(ND_KEYBOARD_PHOTO_SCALE_SIZE, ND_KEYBOARD_PHOTO_SCALE_SIZE);
        [UIView animateWithDuration:0.2 animations:^{
            backView.transform = CGAffineTransformMakeScale(ND_KEYBOARD_PHOTO_SCALE_SIZE, ND_KEYBOARD_PHOTO_SCALE_SIZE);
            editView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else{
        [self removeEditView];
    }
}

#pragma mark 创建视图
-(void)createEditView
{
    editView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *editBg = [[UIImageView alloc] initWithFrame:editView.bounds];
    editBg.contentMode = UIViewContentModeScaleAspectFill;
    editBg.clipsToBounds = YES;
    [editView addSubview:editBg];
    UIButton *editBtn = [self dealBtn:CGRectMake((self.width - 2*ND_KEYBOARD_PHOTO_BTN_SIZE - ND_KEYBOARD_PHOTO_BTN_SPACE) / 2.0, (self.height - ND_KEYBOARD_PHOTO_BTN_SIZE)/2.0, ND_KEYBOARD_PHOTO_BTN_SIZE, ND_KEYBOARD_PHOTO_BTN_SIZE)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.backgroundColor = [UIColor colorWithHexString:@"80DBDBDB"];
    [editView addSubview:editBtn];
    
    
    UIButton *sendBtn = [self dealBtn:CGRectMake(editBtn.right + ND_KEYBOARD_PHOTO_BTN_SPACE, editBtn.top, ND_KEYBOARD_PHOTO_BTN_SIZE, ND_KEYBOARD_PHOTO_BTN_SIZE)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"80DBDBDB"];
    [editView addSubview:sendBtn];
    [editView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
    UIView *blurView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *maskBg = [[UIImageView alloc] initWithFrame:blurView.bounds];
    maskBg.contentMode = UIViewContentModeScaleAspectFill;
    maskBg.clipsToBounds = YES;
    maskBg.image = backView.image;
    [blurView addSubview:maskBg];
    UIView *maskView = [[UIView alloc] initWithFrame:blurView.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [blurView addSubview:maskView];
    [editBg setImageToBlur:[blurView shot] blurRadius:20.0 completionBlock:^{
        
    }];
    [blurView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    blurView = nil;
}

#pragma mark 设置背景图
-(void)setImage:(UIImage * )image
{
    backView.image = image;
}

#pragma mark 获取背景图
-(UIImage *)backgroundImage
{
    return backView.image;
}

#pragma mark 编辑按钮点击
-(void)editClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didEditBtnClick:)]) {
        [self.delegate didEditBtnClick:self];
    }
}

#pragma mark 发送按钮点击
-(void)sendClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSendBtnClick:)]) {
        [self.delegate didSendBtnClick:self];
    }
}

@end
