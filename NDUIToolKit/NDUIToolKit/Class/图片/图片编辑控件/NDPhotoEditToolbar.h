//
//  NDPhotoEditToolbar.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDPhotoEditToolbarDelegate;

/**
 *  图片编辑时候底部工具条
 */
@interface NDPhotoEditToolbar : UIView

@property(assign,nonatomic)id<NDPhotoEditToolbarDelegate>delegate;  ///< 事件委托
@property(assign,nonatomic)NDUIEditToolbarStatus toolbarStatus;  ///< 工具栏状态;

@end

@protocol NDPhotoEditToolbarDelegate <NSObject>

/**
 *  工具类按钮状态改变
 *
 *  @param newStatus 当前状态
 */
-(void)didEditToolbarStatusChange:(NDUIEditToolbarStatus)newStatus;

@end