//
//  UIImage+Resource.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/9.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resource)

/**
 *  本工程图片
 *
 *  @param name 图片名字
 *
 *  @return UIImage
 */
+(UIImage *)imageInUIToolKitProject:(NSString *)name;

/**
 *  获取图片的显示大小
 *
 *  @return 返回显示大小
 */
-(CGSize)imageShowDesignSize;

@end
