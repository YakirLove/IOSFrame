//
//  UIWindow+Subviews.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Subviews)

@property(nonatomic,strong)NSMutableArray *controledSubviews;  ///< 受监控的子视图 用于批量移除

/**
 *  加入子视图
 *
 *  @param subview 子视图
 */
-(void)addControledSubview:(UIView *)subview;

/**
 *  移除子视图
 *
 *  @param subview 子视图
 */
-(void)removeControledSubview:(UIView *)subview;

/**
 *  移除所有的受监控子视图
 */
-(void)removeAllControledSubviews;

@end
