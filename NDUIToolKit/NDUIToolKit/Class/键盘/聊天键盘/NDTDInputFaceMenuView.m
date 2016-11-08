//
//  NDTDInputFaceMenuView.m
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputFaceMenuView.h"

@implementation NDTDInputFaceMenuView
{
    NSMutableArray *emojiArray;
    UIScrollView *scrollView;
    UIButton *sendBtn;
    NSString *sendTitle;
}

@synthesize selectIndex;
@synthesize delegate;
@synthesize sendBtn;

-(instancetype)initWithFrame:(CGRect)frame
         emojiResourcesArray:(NSMutableArray *)emojiResourcesArray
                 selectIndex:(NSInteger)selectIndexs;
{
    self = [super initWithFrame:frame];
    if (self) {
        sendTitle = @"发送";
        emojiArray = emojiResourcesArray;
        self.selectIndex = selectIndexs;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-ITEMBTNWITH, self.frame.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //因为还没有自定义表情的需求，所以隐藏+号
    for (int i=0; i<emojiArray.count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.backgroundColor = [UIColor clearColor];
        itemBtn.frame = CGRectMake(i*ITEMBTNWITH, 0,ITEMBTNWITH,self.frame.size.height);
        itemBtn.tag = 100+i;
        [itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setBackgroundImage:[[UIImage imageNamed:@"按钮-灰色按钮-点击"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
        [itemBtn setBackgroundImage:[[UIImage imageNamed:@"按钮-灰色按钮-点击"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateSelected];
        if (i==selectIndex) {
            itemBtn.selected = YES;
        }
        [scrollView addSubview:itemBtn];
        
        UIView *itemRightLineView = [[UIView alloc]initWithFrame:CGRectMake(ITEMBTNWITH+(i*ITEMBTNWITH), 0, 0.5, self.frame.size.height)];
        itemRightLineView.backgroundColor = [UIColor grayColor];
        itemRightLineView.alpha = 0.5;
        [scrollView addSubview:itemRightLineView];
        
        if (emojiArray.count>i) {
            NSDictionary *dic = [emojiArray objectAtIndex:i];
            [itemBtn setImage:[UIImage imageWithContentsOfFile:[[dic objectForKey:@"path"] stringByAppendingPathComponent:[dic objectForKey:@"iconImage"]]] forState:UIControlStateNormal];
            itemBtn.tag = 100+i;
        }
        else
        {
            itemBtn.hidden = YES; //因为还没有自定义表情的需求，所以隐藏+号
            [itemBtn setTitle:@"+"  forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35];
        }
        scrollView.contentSize = CGSizeMake(itemRightLineView.frame.origin.x+itemRightLineView.frame.size.width, scrollView.frame.size.height);
    }
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topLineView.alpha = 0.5;
    topLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:topLineView];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.frame.size.width-ITEMBTNWITH, 1, ITEMBTNWITH, self.frame.size.height);
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = [UIColor whiteColor];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:sendTitle forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ITEMBTNWITH, self.frame.size.height)] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"按钮-灰色按钮-点击"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(ITEMBTNWITH, self.frame.size.height)] forState:UIControlStateSelected];
    [self addSubview:sendBtn];
    
    UIView *sendLineView = [[UIView alloc]initWithFrame:CGRectMake(sendBtn.frame
                                                                   .origin.x, 0, 0.5, self.frame.size.height-1)];
    sendLineView.backgroundColor = [UIColor grayColor];
    sendLineView.alpha = 0.5;
    [self addSubview:sendLineView];
}

-(void)setSendBtnTitle:(NSString *)title
{
    sendTitle = title;
    [sendBtn setTitle:sendTitle forState:UIControlStateNormal];
}

-(void)refreshView
{
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<emojiArray.count+1; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.backgroundColor = [UIColor clearColor];
        itemBtn.frame = CGRectMake(i*ITEMBTNWITH, 0,ITEMBTNWITH,self.frame.size.height);
        itemBtn.tag = 100+i;
        [itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setBackgroundImage:[[UIImage imageNamed:@"按钮-灰色按钮-点击"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
        [itemBtn setBackgroundImage:[[UIImage imageNamed:@"按钮-灰色按钮-点击"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateSelected];
        if (i==selectIndex) {
            itemBtn.selected = YES;
        }
        [scrollView addSubview:itemBtn];
        
        UIView *itemRightLineView = [[UIView alloc]initWithFrame:CGRectMake(ITEMBTNWITH+(i*ITEMBTNWITH), 0, 0.5, self.frame.size.height)];
        itemRightLineView.backgroundColor = [UIColor grayColor];
        itemRightLineView.alpha = 0.5;
        [scrollView addSubview:itemRightLineView];
        
        if (emojiArray.count>i) {
            NSDictionary *dic = [emojiArray objectAtIndex:i];
            [itemBtn setImage:[UIImage imageWithContentsOfFile:[[dic objectForKey:@"path"] stringByAppendingPathComponent:[dic objectForKey:@"iconImage"]]] forState:UIControlStateNormal];
        }
        else
        {
            [itemBtn setTitle:@"+"  forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35];
        }
        scrollView.contentSize = CGSizeMake(itemRightLineView.frame.origin.x+itemRightLineView.frame.size.width, scrollView.frame.size.height);
    }

    
}

-(void)itemAction:(UIButton *)send
{
    if (selectIndex == send.tag-100) {
        return;
    }
    for (int i=0; i<emojiArray.count; i++) {
        UIButton *sBtn = (UIButton *)[scrollView viewWithTag:i+100];
        if (send.tag-100 == i) {
            sBtn.selected= YES;
        }
        else
        {
            sBtn.selected = NO;
        }
    }
    selectIndex = send.tag -100;
    if (emojiArray.count>send.tag-100) {
        NSDictionary *dic = [emojiArray objectAtIndex:selectIndex];
        NSString *type = [dic objectForKey:@"type"];
        if ([type rangeOfString:@"png"].length>0 || [type rangeOfString:@"jpg"].length>0) {
            sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        }
        else
        {
            sendBtn.titleLabel.font = [UIFont systemFontOfSize:35];
            [sendBtn setTitle:@"+" forState:UIControlStateNormal];
        }
        
        if (delegate && [delegate respondsToSelector:@selector(didClickItemBtnInputFaceMenuView:selectIndex:)]) {
            [delegate didClickItemBtnInputFaceMenuView:self selectIndex:selectIndex];
        }

    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(didClickAddInputFaceMenuView:)]) {
            [delegate didClickAddInputFaceMenuView:self];
        }
    }

}

-(void)sendAction:(UIButton *)send
{
    if ([sendBtn.titleLabel.text isEqualToString:sendTitle]) {
        if (delegate && [delegate respondsToSelector:@selector(didClickSendBtnInputFaceMenuView:)]) {
            [delegate didClickSendBtnInputFaceMenuView:self];
        }
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(didClickAddInputFaceMenuView:)]) {
            [delegate didClickAddInputFaceMenuView:self];
        }
    }

}

@end
