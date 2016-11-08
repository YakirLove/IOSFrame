//
//  NDBgImageTableView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/10/12.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDTableView.h"
/**
 *  带背景图的下拉刷新图
 */
@interface NDHeaderViewTableView : NDTableView

@property(nonatomic,weak)UIImageView *arrowImage; ///< 箭头图片
@property(nonatomic,weak)UIActivityIndicatorView *indicatorView; ///< 等待的菊花
@property(nonatomic,weak)UIView *headerView;

- (void)setNDHeaderBeginRefresh;

- (void)setNDHeaderEndRefresh;

@end
