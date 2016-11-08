//
//  NDPhotoBrowseTableCell.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDPhotoBrowseTableCellPhoto;
@protocol NDPhotoBrowseTableCellDelegate;
/**
 *  相册图片选择的tableviewcell
 */
@interface NDPhotoBrowseTableCell : UITableViewCell


@property(strong,nonatomic)NSMutableArray* imageArray; ///< uiimageview 数组
@property(assign,nonatomic)id<NDPhotoBrowseTableCellDelegate>delegate; ///cell delegate

/**
 *  初始化
 *
 *  @param style           cell style
 *  @param reuseIdentifier 重用id
 *  @param imageWidth     图片宽度
 *
 *  @return cell对象
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier: (NSString *)reuseIdentifier imageWidth:(CGFloat)imageWidth colCnt:(NSInteger)colCnt;

@end


@protocol NDPhotoBrowseTableCellDelegate <NSObject>

/**
 *  拍照按钮点击
 *
 *  @param image 拍照按钮
 */
- (void)didCameraClick:(NDPhotoBrowseTableCellPhoto *)image;

/**
 *  图片点击
 *
 *  @param image 图片点击
 */
- (void)didImageClick:(NDPhotoBrowseTableCellPhoto *)image;

/**
 *  图片长按
 *
 *  @param image 图片长按
 */
- (void)didImageLongPress:(NDPhotoBrowseTableCellPhoto *)image;

@end