//
//  MJDIYAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYAutoFooter.h"
#import "POP.h"
#import "TableFooterView.h"


@interface MJDIYAutoFooter()
{

    TableFooterView *footView;

}

@end

@implementation MJDIYAutoFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    

}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    

    
    
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
            
            [footView removeFromSuperview];
            
            break;
        case MJRefreshStateRefreshing:
            
            footView = [[TableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.height)];
            footView.backgroundColor = [UIColor clearColor];
            [self addSubview:footView];
            
            break;
        case MJRefreshStateNoMoreData:
            
            [footView removeFromSuperview];
            
            break;
        default:
            break;
    }
}


-(void)clearFooter
{
    
    
    
}

@end
