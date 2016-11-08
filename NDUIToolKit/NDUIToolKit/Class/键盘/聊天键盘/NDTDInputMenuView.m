//
//  NDTDInputMenuView.m
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputMenuView.h"

@implementation NDTDInputMenuView
@synthesize delegate;
@synthesize backgroundImageView;
@synthesize menuBtn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(createView) withObject:nil afterDelay:0.001];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self performSelector:@selector(createView) withObject:nil afterDelay:0.001];
    }
    return self;
}

-(void)createView
{
    backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame), InputMenuView)];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = [[UIImage imageNamed:@"底栏-内容输入栏.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundImageView];

    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8,(InputMenuView-19)/2, 20, 19);
    [menuBtn addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"底栏-内容输入栏-键盘-正常.png"] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"底栏-内容输入栏-键盘-点击.png"] forState:UIControlStateHighlighted];
    [backgroundImageView addSubview:menuBtn];
    
    UIImageView *menulineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuBtn.frame)+8, 5, 1, InputMenuView-10)];
    menulineImageView.image = [UIImage imageNamed:@"底栏-内容输入栏TAB-分割线.png"];
    [backgroundImageView addSubview:menulineImageView];

}

-(void)menuAction
{
    if ([delegate respondsToSelector:@selector(didMenuActionSwitch:)]) {
        [delegate didMenuActionSwitch:self];
    }
}

@end
