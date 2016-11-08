 //
//  NDTableView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDTableView.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYHeader.h"

@interface NDTableView()<SRRefreshDelegate>{

    UIImageView *noDataImage;
    BOOL hadAddNotification;
}

@end

@implementation NDTableView
@synthesize refreshType;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)init
{
    self = [super init];
    if (self) {
        [self tableDefaultSet];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tableDefaultSet];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    //frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self tableDefaultSet];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self tableDefaultSet];
    }
    return self;
}

-(CGRect)subViewWidth:(CGFloat)width withHeight:(CGFloat)height forSupView:(UIView *)view
{
    if (view == nil || view.width == 0 || view.height == 0)
    {
        return CGRectZero;
    }
    
    CGFloat maxScreenWidth = view.frame.size.width;
    CGFloat maxScreenHeight = view.frame.size.height;
    
    if(width > maxScreenWidth || height > maxScreenHeight)
    {
        CGFloat scale_width = width/maxScreenWidth;
        CGFloat scale_height = height/maxScreenHeight;
        if(scale_height > scale_width)
        {
            height = maxScreenHeight;
            width = maxScreenHeight/height * width;
        }
        else
        {
            width = maxScreenWidth;
            height = maxScreenWidth/width*height;
        }
    }
    CGRect rect = CGRectMake((maxScreenWidth-width)/2, (maxScreenHeight-height)/2, width,height);
    return rect;
}


- (void)tableDefaultSet
{
    if (hadAddNotification == NO) {
        self.enableMore = YES;
        self.enableRefresh = YES;
        refreshType = QQTableRefreshType;
        [self performSelector:@selector(delayAddRefreshView) withObject:nil afterDelay:0.01];
        
        noDataImage = [[UIImageView alloc] init];
        noDataImage.image = [UIImage imageNamed:@"暂无数据"];
        noDataImage.frame = [self subViewWidth:155 withHeight:50 forSupView:self];
    }
}


-(void)setRefreshType:(NDTableRefreshType)refreshTypes
{
    refreshType = refreshTypes;
    [self performSelector:@selector(delayAddRefreshView) withObject:nil afterDelay:0.01];
}

-(void)delayAddRefreshView
{
    if (self.mj_header != nil)
    {
        self.mj_header = nil;
    }
    
    if (_enableRefresh)
    {
        if (self.mj_header==nil)
        {
            self.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
                if (self.isLoadingMore == NO) {
                    if([self.eventDelegate respondsToSelector:@selector(pllDown:)])
                    {
                        [self.eventDelegate pllDown:self];
                    }
                }
                else
                {
                    [self endRefreshing];
                }
            }];
        }
    }
    else
    {
        self.mj_header = nil;
    }
}

#pragma mark 启用/禁用下拉刷新
-(void)setEnableRefresh:(BOOL)enable
{
    if (_enableRefresh == enable)
    {
        return;
    }
    
    _enableRefresh = enable;
    
    if (_enableRefresh)
    {
        self.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
            if (self.isLoadingMore == NO )
            {
                if([self.eventDelegate respondsToSelector:@selector(pllDown:)])
                {
                    [self.eventDelegate pllDown:self];
                }
            }
            else
            {
                [self endRefreshing];
            }
        }];
    }
    else
    {
        self.mj_header = nil;
    }
}

#pragma mark 启用/禁用上拉更多
-(void)setEnableMore:(BOOL)enable
{
    if (_enableMore == enable) {
        return;
    }
    
    _enableMore = enable;
    
    if (_enableMore) {
        self.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
            if (self.isRefreshing == NO ) {
                if([self.eventDelegate respondsToSelector:@selector(pllUp:)]){
                    [self.eventDelegate pllUp:self];
                }
            }else{
                [self endLoadMore];
            }
        }];
    }else{
        self.mj_footer = nil;
    }
}

#pragma mark 下拉刷新头部
- (UIView *)ndHeader
{
    return self.mj_header;
}

#pragma mark 下拉刷新尾部
- (UIView *)ndFooter
{
    return self.mj_footer;
}

#pragma mark 提示没有更多的数据
- (void)noticeNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark 重置没有更多的数据（消除没有更多数据的状态）
- (void)resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    [self.mj_header beginRefreshing];
}

-(void)beginRefreshing:(BOOL)isAnimation
{
    [self beginRefreshing];
}


-(void)removeUserInteractionEnabled
{
    self.userInteractionEnabled = YES;
}

#pragma mark  头部刷新结束提示语设置

-(void)setHeaderEndText:(NSString *)string;
{
    [(MJDIYHeader *)self.mj_header setHeaderEndText:string];
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    [noDataImage removeFromSuperview];
    [self resetNoMoreData];
    [self.mj_header endRefreshing];
}



#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return [self.mj_header isRefreshing];
}

#pragma mark 进入加载更多状态
- (void)beginLoadMore
{
    [self.mj_footer beginRefreshing];
}

#pragma mark 结束加载更多状态
- (void)endLoadMore
{
    [noDataImage removeFromSuperview];
    [self.mj_footer endRefreshing];
}

#pragma mark 是否正在加载更多
- (BOOL)isLoadingMore
{
    return [self.mj_footer isRefreshing];
}

#pragma mark - 清除底部显示所有视图
-(void)clearFooter
{
    if([self.mj_footer isKindOfClass:[MJDIYAutoFooter class]])
        [(MJDIYAutoFooter *)self.mj_footer clearFooter];
}

#pragma mark - 没有任何数据提示
-(void)noticeNoAnyData
{
    noDataImage.frame = [self subViewWidth:155 withHeight:50 forSupView:self];
    [self addSubview:noDataImage];
}
#pragma mark - 脚部增加没有任何数据提示(通常在tableview有headView的情况下才使用，防止因为headview导致剩下的区域不足于显示提示的图片)
-(void)tableFootNoAnyData
{
    [self clearFooter];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footView;
    noDataImage.frame = [self subViewWidth:155 withHeight:50 forSupView:footView];
    [footView addSubview:noDataImage];
}
#pragma mark - 清除脚部的没有数据提示
-(void)clearTableFootNoData
{
    [noDataImage removeFromSuperview];
    self.tableFooterView = nil;
}

#pragma mark UIScrollViewDelegate Methods


//用户拖动scrollView时调用。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

//用户拖动scrollView放开时调用。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   
}

////刷新列表
//- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
//{
//    if (self.isLoadingMore == NO ) {
//        if ([self.eventDelegate respondsToSelector:@selector(pllDown:)]) {
//            [self.eventDelegate pllDown:self];
//        }
//    }else{
//        [self endRefreshing];
//    }
//}

@end
