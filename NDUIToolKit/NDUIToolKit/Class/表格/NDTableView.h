//
//  NDTableView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger,NDTableRefreshType)
{
    ArrowTableRefreshType, //带箭头的刷新效果 (默认)
    QQTableRefreshType,    //模仿qq的下啦刷新
    BigImageRefreshType
};

@protocol NDTableViewDelegate;

/**
 *  表格公共父类  带下拉刷新的
 */
@interface NDTableView : UITableView

@property(nonatomic,assign) NDTableRefreshType refreshType;

@property(nonatomic,assign)BOOL enableMore; ///< 启用/禁用上拉更多

@property(nonatomic,assign)BOOL enableRefresh; ///< 启用/禁用下拉刷新

@property(nonatomic,assign)id<NDTableViewDelegate>eventDelegate; ///< 事件委托

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 *  进入刷新状态
 */
- (void)beginRefreshing;

/**
 *  isAnimation：是否需要动画
 */
-(void)beginRefreshing:(BOOL)isAnimation;

/**
 *  结束刷新状态
 */
- (void)endRefreshing;

/**
 *  是否正在刷新
 *
 *  @return 是否正在刷新
 */
- (BOOL)isRefreshing;


/**
 *  进入加载更多状态
 */
- (void)beginLoadMore;

/**
 *  结束加载更多状态
 */
- (void)endLoadMore;

/**
 *  是否正在加载更多
 *
 *  @return 是否正在刷新
 */
- (BOOL)isLoadingMore;



/**
 *  提示没有更多的数据
 */
- (void)noticeNoMoreData;

/**
 *  重置没有更多的数据（消除没有更多数据的状态）
 */
- (void)resetNoMoreData;

/**
 *  下拉刷新头部
 *
 *  @return 下拉刷新头部
 */
- (UIView *)ndHeader;

/**
 *  下拉刷新尾部
 *
 *  @return 下拉刷新尾部
 */
- (UIView *)ndFooter;

/**
 *  清除底部显示所有视图
 */
-(void)clearFooter;

/**
 *  没有任何数据提示
 */
-(void)noticeNoAnyData;

/**
 *  脚部增加没有任何数据提示(通常在tableview有headView的情况下才使用，防止因为headview导致剩下的区域不足于显示提示的图片)
 */
-(void)tableFootNoAnyData;
/**
 *  清除脚部的没有数据提示
 */
-(void)clearTableFootNoData;

/**
 *  头部刷新结束提示语设置
 */
-(void)setHeaderEndText:(NSString *)string;

@end


@protocol NDTableViewDelegate <NSObject>

@optional
/**
 *  下拉事件
 *
 *  @param tableView 表格
 */
-(void)pllDown:(NDTableView *)tableView;

/**
 *  上拉事件
 *
 *  @param tableView 表格
 */
-(void)pllUp:(NDTableView *)tableView;

@end