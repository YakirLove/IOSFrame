//
//  NDCameraUtils.h
//  NDSDK
//
//  Created by zhangx on 15/9/14.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDCameraUtils : NSObject

/**
 *  相机是否可用
 *
 *  @return 相机是否可用
 */
+ (BOOL) isCameraAvailable ;


/**
 *  相机是否可以拍照
 *
 *  @return 相机是否可以拍照
 */
+ (BOOL) doesCameraSupportTakingPhotos ;

/**
 *  前置摄像机是否可用
 *
 *  @return 前置摄像机是否可用
 */
+ (BOOL) isFrontCameraAvailable ;


/**
 *  后置相机是否可以使用
 *
 *  @return 后置相机是否可以使用
 */
+ (BOOL) isBackCameraAvailable ;

@end
