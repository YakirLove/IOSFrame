//
//  NDAsset.h
//  NDSDK
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface NDAsset : NSObject

@property(strong,nonatomic)UIImage *editedImage; ///< 编辑后的图
@property(strong,nonatomic)UIImage *sbcImage; ///< 调整对比度、饱和度、亮度后的图
@property(strong,nonatomic)NSURL *assertUrl; ///< 地址

/**
 *  初始化
 *
 *  @param asset 相册信息
 *
 *  @return 相册
 */
-(id)initWithAsset:(ALAsset *)asset;

/**
 *  高清图
 *
 *  @return 高清图
 */
-(UIImage *)fullScreenImage;

/**
 *  缩略图
 *
 *  @return 缩略图
 */
-(UIImage *)thumbnailImage;

/**
 *  图片的唯一标示
 *
 *  @return 图片的唯一标示
 */
-(NSString *)imageID;


@end
