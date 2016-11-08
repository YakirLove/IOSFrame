//
//  NDToast.h
//  NDSDK
//
//  Created by zhangx on 15/7/15.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDToast : NSObject

/**
 *  显示提示信息
 *
 *  @param message    提示信息
 *  @param completion 动画完成回调
 */
+(void)showInfoMsg:(NSString *)message completionBlock:(void (^)(void))completion;

/**
 *  显示错误信息
 *
 *  @param message    错误信息
 *  @param completion 动画完成回调
 */
+(void)showErrorMsg:(NSString *)message completionBlock:(void (^)(void))completion;

/**
 *  显示提示信息
 *
 *  @param message    提示信息
 *  @param completion 动画完成回调
 */
+(void)showBigInfoMsg:(NSString *)message completionBlock:(void (^)(void))completion;

/**
 *  显示错误信息
 *
 *  @param message    错误信息
 *  @param completion 动画完成回调
 */
+(void)showBigErrorMsg:(NSString *)message completionBlock:(void (^)(void))completion;

@end
