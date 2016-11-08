//
//  NDPhotoBrowseViewController.h
//  NDUIToolKit 相册图片浏览
//
//  Created by zhangx on 15/7/22.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDPhotoBrowseViewControllerDelegate;

/**
 *  相册图片浏览
 */
@interface NDPhotoBrowseViewController : NDViewController

@property(assign,nonatomic)id<NDPhotoBrowseViewControllerDelegate>delegate; ///< 事件委托

@property(assign,nonatomic)NSInteger maxPhotoCnt;  ///< 最多选中图片数 默认 NDUI_MAX_PHOTOS_PICKED 张
@property(assign,nonatomic)NSInteger photoColCnt;  ///< 一行有多少张图片 默认 NDUI_ROW_PHOTO_CNT 张
@property(assign,nonatomic)BOOL isCameraEnable; ///< 是否需要拍照功能 默认需要
@property(copy,nonatomic)NSString *overMaxCntNotice; ///< 超过最大张数时候的提醒
@property(copy,nonatomic)NSString *doneTitle; ///< 完成按钮

@end


@protocol NDPhotoBrowseViewControllerDelegate <NSObject>

/**
 *  发送图片
 *
 *  @param imagesArray          图片数组 NDPhotoData对象 请使用 imageToShow 方法获取照片
 *  @param browseViewController 图片浏览控制器
 */
-(void)didSendImages:(NSArray *)imagesArray browseViewController:(UIViewController *)browseViewController;

@optional
-(void)changeViewController:(UIViewController *)cameraVC browseViewController:(NDPhotoBrowseViewController *)browseViewController;

@end