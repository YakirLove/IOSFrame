//
//  UIImage+Filter.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/5.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)

/**
 *  黑白滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 黑白滤镜图
 */
+ (UIImage *)heibaiImage : (UIImage *)oriImage;


/**
 *  对比滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 对比滤镜图
 */
+ (UIImage *)duibiImage : (UIImage *)oriImage;


/**
 *  翡翠绿滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 翡翠绿滤镜图
 */
+ (UIImage *)feicuilvImage : (UIImage *)oriImage;

///**
// *  冷色滤镜图
// *
// *  @param oriImage 原始图
// *
// *  @return 冷色滤镜图
// */
//+ (UIImage *)lengseImage : (UIImage *)oriImage;

/**
 *  米黄滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 米黄滤镜图
 */
+ (UIImage *)mihuangImage : (UIImage *)oriImage;

/**
 *  灯光滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 灯光滤镜图
 */
+ (UIImage *)dengguangImage : (UIImage *)oriImage;

/**
 *  淡雅滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 淡雅滤镜图
 */
+ (UIImage *)danyaImage : (UIImage *)oriImage;

/**
 *  金色滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 金色滤镜图
 */
+ (UIImage *)jinseImage : (UIImage *)oriImage;

/**
 *  增强滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 增强滤镜图
 */
+ (UIImage *)zengqiangImage : (UIImage *)oriImage;

///**
// *  炫丽滤镜图
// *
// *  @param oriImage 原始图
// *
// *  @return 炫丽滤镜图
// */
//+ (UIImage *)xuanliImage : (UIImage *)oriImage;

/**
 *  高亮滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 高亮滤镜图
 */
+ (UIImage *)gaoliangImage : (UIImage *)oriImage;

/**
 *  铜色滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 铜色滤镜图
 */
+ (UIImage *)tongseImage : (UIImage *)oriImage;

/**
 *  艳阳滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 艳阳滤镜图
 */
+ (UIImage *)yanyangImage : (UIImage *)oriImage;

/**
 *  复古滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 复古滤镜图
 */
+ (UIImage *)fuguImage : (UIImage *)oriImage;

/**
 *  奶昔色滤镜图
 *
 *  @param oriImage 原始图
 *
 *  @return 奶昔色滤镜图
 */
+ (UIImage *)naixiseImage : (UIImage *)oriImage;

///**
// *  柔和滤镜图
// *
// *  @param oriImage 原始图
// *
// *  @return 柔和滤镜图
// */
//+ (UIImage *)rouheImage : (UIImage *)oriImage;

///**
// *  现代滤镜图
// *
// *  @param oriImage 原始图
// *
// *  @return 现代滤镜图
// */
//+ (UIImage *)xiandaiImage : (UIImage *)oriImage;


/**
 *  根据滤镜类型过滤图片
 *
 *  @param filterType 滤镜类型
 *
 *  @return 图片
 */
+ (UIImage *)imageWithFilterType:(NDUIFilterType)filterType oriImage:(UIImage *)oriImage;


@end
