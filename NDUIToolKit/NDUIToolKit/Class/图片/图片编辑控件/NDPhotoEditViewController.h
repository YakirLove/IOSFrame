//
//  NDPhotoEditViewController.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDPhotoEditViewControllerDelegate;
/**
 图片编辑控制器
 */
@interface NDPhotoColorCircleView : UIView

/**
 *  初始化
 *
 *  @param frame      位置
 *  @param circleSize 内圆大小
 *  @param color      颜色
 *
 *  @return 对象
 */
-(id)initWithFrame:(CGRect)frame circleSize:(CGFloat)circleSize color:(UIColor *)color;

/**
 *  设置内圆大小
 *
 *  @param size 半径大小
 */
-(void)setInnerCircleSize:(CGFloat)size;

/**
 *   设置颜色
 *
 *  @param color 颜色
 */
-(void)setCircleColor:(UIColor *)color;

@end


/**
 颜色板
 */
@interface NDPhotoColorView : UIView

@property(nonatomic,strong)UIImageView *colorImage; ///< 颜色图

@end

/**
 *  图片编辑页面
 */
@interface NDPhotoEditViewController : NDViewController

/**
 *  初始化
 *
 *  @param oriImage 源图
 *
 *  @return 图片编辑页面
 */
-(id)initWithOriImage:(UIImage *)oriImage;

@property(assign,nonatomic)id<NDPhotoEditViewControllerDelegate>delegate;

@end


@protocol NDPhotoEditViewControllerDelegate <NSObject>

/**
 *  编辑图片完成
 *
 *  @param editedImage        图片编辑完成
 *  @param editViewController 编辑图片的控制器
 */
-(void)didFinishedEdit:(UIImage *)editedImage editViewController:(NDPhotoEditViewController *)editViewController;

@optional

/**
 *  取消编辑图片
 */
-(void)didCancelEdit;

@end