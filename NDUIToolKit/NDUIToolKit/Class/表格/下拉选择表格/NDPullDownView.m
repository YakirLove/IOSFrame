//
//  PullDownView.m
//  SelectServer
//
//  Created by 网龙技术部 on 15/8/6.
//  Copyright (c) 2015年 吴焰基. All rights reserved.
//

#import "NDPullDownView.h"

@implementation NDPullDownView

@synthesize delegateForSup;
@synthesize arrowImgView;
@synthesize dataArray;

- (instancetype)initWithFrame:(CGRect)frame dicKey:(NSString *)string showDefault:(BOOL)ifDefault color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if(self)
    {
        defaultValue = ifDefault;
        key = [NSString stringWithFormat:@"%@",string];
        lineColor = color;
        _textAlignment = NSTextAlignmentLeft;
        _selectedColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

-(void)setArray:(NSMutableArray *)array
{
    pullDownTextField.text = @"";
    dataArray = [[NSMutableArray alloc] initWithArray:array];
    if(defaultValue)
    {
        if([delegateForSup respondsToSelector:@selector(selectDic:dickey:pullDownView:)])
        {
            if(array.count > 0)
                [self selectDic:array[0]];
        }
    }
}


-(void)clearText
{
    pullDownTextField.text = @"";
}

-(void)createView
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 37);
    bgButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-37, 1, 37, 35)];
    bgButton.userInteractionEnabled = NO;
    bgButton.backgroundColor = lineColor;
    [self addSubview:bgButton];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPullDownTable:)]];
    
    arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake((bgButton.width - 20.0/3.)/2.0, (bgButton.height - 13.0/3)/2.0, 20.0/3.0, 13.0/3)];
    [bgButton addSubview:arrowImgView];
    
    pullDownTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, self.frame.size.width-2, 20)];
    pullDownTextField.font = [UIFont systemFontOfSize:14];
    pullDownTextField.textColor = lineColor;
    pullDownTextField.backgroundColor = [UIColor clearColor];
    pullDownTextField.textAlignment = NSTextAlignmentLeft;
    pullDownTextField.userInteractionEnabled = NO;
    [self addSubview:pullDownTextField];
    
    self.layer.borderColor = [lineColor CGColor];
    self.layer.borderWidth = 1;
//    self.userInteractionEnabled = NO;
//    [self addSubview:lineView];
    
}

/**
 *  是否有选中值
 *
 *  @return 是否有选择值
 */
-(BOOL)hadChoosedValue
{
    if ([NSString isEmptyString:pullDownTextField.text] || [pullDownTextField.text isEqualToString:pullDownTextField.placeholder]) {
        return NO;
    }
    return YES;
}


-(void)setArrowImage:(UIImage *)image size:(CGSize)size
{
    arrowImgView.image = image;
    arrowImgView.frame = CGRectMake((37-size.width)/2.0, (37-size.height)/2.0, size.width, size.height);
}

-(void)setArrowButtonBGColor:(UIColor *)color
{
    bgButton.backgroundColor = color;
}

-(void)setTableViewColor:(UIColor *)color
{
    _tableColor = color;
}


-(void)setTableViewSelectedColor:(UIColor *)color
{
    _tableSelectedColor = color;
}


-(void)setTableViewTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
}


-(void)setSelectedColor:(UIColor *)color
{
    _selectedColor = color;
}


-(void)setTextMargin:(CGFloat)margin
{
    pullDownTextField.frame = CGRectMake(margin, 8, self.frame.size.width-margin, 20);
}

-(void)addPullDownTable:(UIButton *)button
{
    if (dataArray.count == 0) {
        if ([self.delegateForSup respondsToSelector:@selector(noticeNoData:)]) {
            [self.delegateForSup noticeNoData:self];
        }
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VIEW_PULL_DOWN" object:nil];
        
        CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
        tableView = [[NDPullDownTableView alloc] initWithArray:dataArray dicKey:key color:self.layer.borderColor];
        tableView.delegateForSup = self;
        tableView.backgroundColor = _tableColor;
        tableView.selectedColor = _tableSelectedColor;
        tableView.textAlignment = _textAlignment;
        [self setPlaceholder:pullDownTextField.placeholder];
        double height = [UIApplication sharedApplication].keyWindow.frame.size.height-rect.origin.y-rect.size.height-40;
        
        NSInteger row = defaultValue ? dataArray.count : dataArray.count + 1;
        
        if(row * 40 < height)
        {
            height = row * 40;
        }
        
        height = height>0 ? height:40;
        
        UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 1)];
        parentView.clipsToBounds = YES;
        
        tableView.frame = CGRectMake(0, 0, rect.size.width, height);
        
        [parentView addSubview:tableView];
        
        [tapView removeFromSuperview];
        tapView = nil;
        tapView = [[UIView alloc] initWithFrame:self.window.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        [tapView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:tapView];
        [[UIApplication sharedApplication].keyWindow addSubview:parentView];
        
        [UIView animateWithDuration:0.3 animations:^
         {
             tableView.superview.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, height);
         }
                         completion:^(BOOL finished)
         {}];
    }
}

-(void)tapMethod:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^
     {
         tableView.superview.frame = CGRectMake(tableView.superview.left, tableView.superview.top, tableView.superview.width, 1);
     }
                     completion:^(BOOL finished)
     {
         [tapView removeFromSuperview];
         [tableView.superview removeFromSuperview];
         tableView = nil;
     }];
    
}

-(void)setPlaceholder:(NSString *)string
{
    pullDownTextField.placeholder = string;
    if(defaultValue)
    {
        [tableView setDefaultString:nil];
    }
    else
    {
        [tableView setDefaultString:pullDownTextField.placeholder];
    }
}

#pragma mark - SelectServerTableViewDelegate

-(void)selectDic:(NSDictionary *)dic
{
    pullDownTextField.text = [dic objectForKey:key];
    
    if ([self hadChoosedValue]) {
        pullDownTextField.textColor = _selectedColor;
    }else{
        pullDownTextField.textColor = lineColor;
    }
    
    if([delegateForSup respondsToSelector:@selector(selectDic:dickey:pullDownView:)])
    {
        [delegateForSup selectDic:dic dickey:key pullDownView:self];
    }
    [self tapMethod:nil];
}

#pragma mark -

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    pullDownTextField.frame = CGRectMake(pullDownTextField.left, (self.height - pullDownTextField.height)/2.0, self.width-pullDownTextField.left, pullDownTextField.height);
    bgButton.frame = CGRectMake(self.width - bgButton.width, 1, bgButton.width, self.height - 2);
    arrowImgView.frame = CGRectMake((bgButton.width - arrowImgView.width)/2.0, (bgButton.height - arrowImgView.height)/2.0, arrowImgView.width  , arrowImgView.height);
}


@end
