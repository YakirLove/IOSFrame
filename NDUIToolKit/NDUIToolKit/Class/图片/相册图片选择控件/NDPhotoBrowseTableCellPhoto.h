//
//  NDPhotoBrowseTableCellPhoto.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  相册图片选则当中的图片
 */
@interface NDPhotoBrowseTableCellPhoto : UIImageView

@property(assign,nonatomic)BOOL isNumberVisable; ///< 序号是否可见
@property(assign,nonatomic)BOOL isCameraPhoto;  ///< 是否是拍照按钮

/**
 *  显示序号
 *
 *  @param number 序号
 */
- (void)showNumber:(NSInteger)number;

/**
 *  隐藏序号
 */
- (void)hideNumber;

/**
 *  点击的动画
 */
- (void)clickAnimations;

@end
