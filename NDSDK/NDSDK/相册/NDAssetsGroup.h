//
//  NDAssetsGroup.h
//  NDSDK
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDAssetsGroup : NSObject

@property(strong,nonatomic)ALAssetsGroup *group; ///< 相册对象

/**
 *  初始化
 *
 *  @param group 相册
 *
 *  @return 对象
 */
- (id)initWithAssetsGroup:(ALAssetsGroup *)group;

/**
 *  相册名称
 *
 *  @return 相册名称
 */
- (NSString *)groupName;

/**
 *  相册下的图片或者视频数
 *
 *  @return 相册下的图片或者视频数
 */
- (NSInteger)numberOfAssets;

/**
 *  缩略图
 *
 *  @return 缩略图
 */
- (UIImage *)posterImage;

@end
