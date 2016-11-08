//
//  MJDIYHeader.m
//  NDUIToolKit
//
//  Created by wyj on 16/6/7.
//  Copyright © 2016年 nd. All rights reserved.
//

#import "MJDIYHeader.h"

@interface MJDIYHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *leftImgView;
@property (weak, nonatomic) UIImageView *rightImgView;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak, nonatomic) UIImageView *endImgView;
@property (weak, nonatomic) NSString *endString;
@end

@implementation MJDIYHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
//    self.backgroundColor = [UIColor redColor];
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text  = @"刷新完成";
    [self addSubview:label];
    self.label = label;
    
    UIImageView *leftImgView = [[UIImageView alloc] init];
    leftImgView.image = [UIImage imageNamed:@"头部刷新左边"];
    [self addSubview:leftImgView];
    self.leftImgView = leftImgView;
    
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = [UIImage imageNamed:@"头部刷新右边"];
    [self addSubview:rightImgView];
    self.rightImgView = rightImgView;
    
    UIImageView *endImgView = [[UIImageView alloc] init];
    endImgView.image = [UIImage imageNamed:@"头部刷新完成"];
    [self addSubview:endImgView];
    self.endImgView = endImgView;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] init];
    [loading startAnimating];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:loading];
    self.loading = loading;
    
  }

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.leftImgView.frame = CGRectMake(self.width/5.0, 10, 53, 31);
    self.rightImgView.frame = CGRectMake(self.width/5.0*4-55, 10, 55, 31);
    
    self.endImgView.frame = CGRectMake((self.rightImgView.left-self.leftImgView.right-20-85)/2.0+self.leftImgView.right, 15, 20, 20);
    self.loading.frame = self.endImgView.frame;
    self.label.frame = CGRectMake(self.endImgView.right+2, 15, 90, 20);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            
//            self.endImgView.alpha = 0;
//            self.loading.alpha = 1;
//            self.label.alpha = 1;
//            self.label.text = @"下拉刷新";
            
            break;
        case MJRefreshStatePulling:
            
            self.endImgView.alpha = 0;
            self.loading.alpha = 1;
            self.label.alpha = 1;
            self.label.text = @"松开刷新";
            
            break;
        case MJRefreshStateRefreshing:
            
            self.endImgView.alpha = 0;
            self.loading.alpha = 1;
            self.label.alpha = 1;
            self.label.text = @"刷新中";
            
            break;
            
        default:
            break;
    }
}

-(void)beginRefreshing
{
    [super beginRefreshing];
    
    self.endImgView.alpha = 0;
    self.loading.alpha = 1;
    self.label.alpha = 1;
    self.label.text = @"刷新中";
    self.endString = nil;
}

-(void)endRefreshing
{
    self.endImgView.alpha = 1;
    self.loading.alpha = 0;
    self.label.alpha = 1;
    
    if(self.endString == nil)
    {
        self.label.text = @"已刷新";
    }
    else
    {
        self.label.text = self.endString;
    }
    
    [self performSelector:@selector(endRefreshingAfter:) withObject:nil afterDelay:0.3];
}

-(void)endRefreshingAfter:(id)sender
{
    [super endRefreshing];
}

-(void)setHeaderEndText:(NSString *)string
{
    self.endString = string;
}


@end
