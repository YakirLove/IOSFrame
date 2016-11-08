//
//  MySearchBar.m
//  SearchBarTest
//
//  Created by 林 on 4/29/14.
//  Copyright (c) 2014 福建网龙科技有限公司. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar
@synthesize myBackgroundImage;
@synthesize myDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customSearchBar];
    }
    return self;
}


-(void)customSearchBar
{
    self.backgroundColor=[UIColor clearColor];
    
    //去掉搜索框背景
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self layoutSubviews];
}

- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColors
{
    self=[super initWithFrame:frame];
    if (self) {
        textColor=textColors;
         [self customSearchBar];
    }
    return self;
}


- (void)layoutSubviews {
    
    
    UITextField *searchField;

    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField *)subview;
            break;
        }
        else
        {
            for (UIView *subviewChild in subview.subviews) {
                
                if ([subviewChild isKindOfClass:[UITextField class]])
                {
                    searchField = (UITextField *)subviewChild;
                    break;

                }
                else
                {
                    [subviewChild removeFromSuperview];
                }
            }

        }

    }

	if(!(searchField == nil)) {
        [searchField setBackground:nil];
        [searchField  setBackgroundColor:[UIColor clearColor]];
        searchField.layer.borderColor=[[UIColor clearColor]CGColor];
        searchField.delegate = self;
		[searchField setBorderStyle:UITextBorderStyleNone];
        searchField.textAlignment=NSTextAlignmentLeft;
        searchField.returnKeyType=UIReturnKeyDone;
        if (textColor!=nil) {
            searchField.textColor=textColor;
            searchField.enablesReturnKeyAutomatically=NO;
        }
        searchField.rightView=nil;
		searchField.leftView = nil;
	}
	[super layoutSubviews];
    
}


-(void)setMyBackgroundImage:(UIImageView *)myBackgroundImages
{
    myBackgroundImage=myBackgroundImages;
    [self insertSubview:myBackgroundImages atIndex:1];
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (myDelegate && [myDelegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [myDelegate searchBarCancelButtonClicked:self];
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
