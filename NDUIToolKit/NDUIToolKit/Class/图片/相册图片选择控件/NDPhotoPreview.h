//
//  NDPhotoPreview.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/30.
//  Copyright © 2015年 nd. All rights reserved.
//

@class NDFilterData;

#import <UIKit/UIKit.h>

@protocol NDPhotoPreviewDelegate;

/**
 *  预览视图
 */
@interface NDPhotoPreview : UIScrollView

@property(assign,nonatomic)NSInteger nowIndex;  ///< 当前页号
@property(strong,nonatomic)NSMutableArray *dataArray; ///< 图片数组 放的是NDPhotoData对象
@property(strong,nonatomic)UIImageView *preImage; ///< 遮挡视图
@property(assign,nonatomic)NSInteger indexOffset; ///< 位置偏移量
@property(assign,nonatomic)id<NDPhotoPreviewDelegate>viewDelegate; ///< 事件委托

/**
 *  显示在某个位置上的图片
 *
 *  @param index 位置
 */
- (void)showPhotoAtIndex : (NSInteger)index;

/**
 *  小图转大图动画
 *
 *  @param superview        父视图
 *  @param originalView     初始视图
 */
- (void)turnToPreview : (UIView *)superview originalView : (UIView *)originalView;

/**
 *  大图转小图动画
 *
 *  @param superview    父视图
 *  @param originalView 缩小到目的视图
 */
- (void)turnToList:(UIView *)superview originalView:(UIView *)originalView;

/**
 *  调整对比度
 *
 *  @param enable 是否启用
 */
- (void)changeLux : (BOOL) enable;

/**
 *  调整滤镜
 *
 *  @param data 滤镜数据
 */
- (void)changeFilter : (NDFilterData *)data;


/**
 *  当前视图
 *
 *  @return 当前视图
 */
- (UIImageView *)currentImageView;

@end

@protocol NDPhotoPreviewDelegate <NSObject>

@optional
/**
 *  拖动完毕
 */
- (void)scrollViewDidEndDecelerating;

@end
