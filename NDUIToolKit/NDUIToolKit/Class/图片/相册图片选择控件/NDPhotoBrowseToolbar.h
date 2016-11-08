//
//  NDPhotoBrowseToolbar.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/29.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NDPhotoFilterView.h"

@protocol NDPhotoBrowseToolbarDelegate;

/**
 *  图片编辑工具类  包含 滤镜 魔术棒 裁剪
 */
@interface NDPhotoBrowseToolbar : UIView


@property(assign,nonatomic)id<NDPhotoBrowseToolbarDelegate,NDPhotoFilterViewDelegate>delegate;   ///< 工具栏delegate



/**
 *  初始化
 *
 *  @param frame    位置信息
 *  @param funcFlag 功能配置  滤镜|魔术棒|裁剪
 *
 *  @return 初始化
 */
-(id)initWithFrame:(CGRect)frame funcFlag:(NSString *)funcFlag;

/**
 *  关闭滤镜栏
 */
- (void)closeFilterView;

/**
 *  修改滤镜demo图
 *
 *  @param photoData 当前图片数据
 */
- (void)changeFilterImages:(NDPhotoData *)photoData;

/**
 *  改变lux按钮的选中状态
 *
 *  @param photoData 图片数据
 */
- (void)changeLuxStatus:(NDPhotoData *)photoData;

@end


@protocol NDPhotoBrowseToolbarDelegate <NSObject>

@optional
/**
 *  进到裁剪模式
 */
- (void)gotoCropMode;

/**
 *  对比度调节按钮选中状态
 *
 *  @param selected 是否选中
 */
- (void)luxSelectedChanged : (BOOL) selected;


/**
 *  滤镜条是否显示
 *
 *  @param isDisplay 是否显示
 */
- (void)filterScrollViewDisplayChange : (BOOL)isDisplay view:(NDPhotoFilterView *)view;


@end