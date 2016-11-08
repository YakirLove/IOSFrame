//
//  NDKeyBoardPhoto.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDKeyBoardPhotoDelegate;

@interface NDKeyBoardPhoto : UIView

@property(assign,nonatomic)id<NDKeyBoardPhotoDelegate>delegate;
@property(assign,nonatomic)NSInteger index;

/**
 *  移除编辑视图
 */
-(void)removeEditView;
/**
 *  移除编辑视图
 *
 *  @param block 回调
 */
-(void)removeEditViewWithBlock:(void (^)(void))block;

/**
 *  设置图片
 *
 *  @param image 图片
 */
-(void)setImage:(UIImage * )image;

/**
 *  背景图
 *
 *  @return 背景图
 */
-(UIImage *)backgroundImage;

@end

@protocol NDKeyBoardPhotoDelegate <NSObject>

/**
 *  编辑按钮点击
 *
 *  @param photo 图片
 */
-(void)didEditBtnClick:(NDKeyBoardPhoto *)photo;

/**
 *  发送按钮点击
 *
 *  @param photo 发送按钮点击
 */
-(void)didSendBtnClick:(NDKeyBoardPhoto *)photo;

@optional
/**
 *  进入编辑状态
 *
 *  @param photo 图片
 */
-(void)didBecomeEditStatus:(NDKeyBoardPhoto *)photo;


@end
