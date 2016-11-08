//
//  NDPhotoBrowseTableView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDPhotoBrowseTableViewDelegate;
/**
 *  相册图片选择的tableview
 */
@interface NDPhotoBrowseTableView : UITableView

@property(assign,nonatomic)id<NDPhotoBrowseTableViewDelegate>cellDelegate;

@property(nonatomic,assign)NSInteger colCnt; ///<每一行多少列图标
@property(nonatomic,strong)NSMutableArray *dataArray; ///< 数据数组 放的是NDPhotoData对象
@property(nonatomic,strong)NSMutableArray *selectedArray; ///< 选中的数组 存放NDPhotoData在dataArray中的index

@end


@protocol NDPhotoBrowseTableViewDelegate <NSObject>

/**
 *  最多可以选则多少张照片
 *
 *  @return 照片数
 */
- (NSInteger)maxPhotosPicked;

/**
 *  是否启用拍照功能
 *
 */
- (BOOL)cameraEnable;

@optional
/**
 *  图片长按
 *
 *  @param imageView 图片
 */
- (void)didImageLongPress : (UIImageView *)imageView;

/**
 *  图片点击
 *
 *  @param imageView 图片点击
 */
- (void)didImageClick: (UIImageView *)imageView;

/**
 *  拍照按钮点击
 *
 *  @param imageView 拍照按钮点击
 */
- (void)didCameraClick: (UIImageView *)imageView;

@end