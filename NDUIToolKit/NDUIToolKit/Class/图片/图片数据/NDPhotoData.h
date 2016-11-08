//
//  NDPhotoData.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDFilterData;
/**
 *  图片数据
 */
@interface NDPhotoData : NSObject

@property(copy,nonatomic)NSString *localUrl; ///< 本地地址
@property(strong,nonatomic)NDAsset *asset; ///< 相册数据
@property(strong,nonatomic)NDFilterData *selecteFilter; ///< 滤镜数据
@property(assign,nonatomic)BOOL enableLux; ///< lux是否选中
@property(strong,nonatomic)UIImage *orgImage; ///< 原图图片
@property(assign,nonatomic)CGRect cropFrame; ///< 裁剪的布局
@property(assign,nonatomic)NSInteger angle; ///< 角度

/**
 *  要用来展示的图片
 *
 *  @return 图片
 */
-(UIImage *)imageToShow;


/**
 *  没有处理过的图片
 *
 *  @return 图片
 */
-(UIImage *)imageWithoutEdit;


/**
 *  处理过的图片
 *
 *  @return 图片
 */
-(UIImage *)imageWithEdit;

@end
