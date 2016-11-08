//
//  NDToast.m
//  NDSDK
//
//  Created by zhangx on 15/7/15.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDToast.h"
#import "CRToast.h"

@implementation NDToast

/**
 *  显示提示信息
 *
 *  @param message    提示信息
 *  @param completion 动画完成回调
 */
+(void)showInfoMsg:(NSString *)message completionBlock:(void (^)(void))completion
{
    [CRToastManager showNotificationWithOptions:@{kCRToastTextKey : message,kCRToastBackgroundColorKey : [UIColor colorWithHexString:@"2e2e2e"]}
                      completionBlock:completion];
}

/**
 *  显示错误信息
 *
 *  @param message    错误信息
 *  @param completion 动画完成回调
 */
+(void)showErrorMsg:(NSString *)message completionBlock:(void (^)(void))completion
{
    [CRToastManager showNotificationWithMessage:message completionBlock:^{
        completion();
    }];
}

/**
 *  显示提示信息
 *
 *  @param message    提示信息
 *  @param completion 动画完成回调
 */
+(void)showBigInfoMsg:(NSString *)message completionBlock:(void (^)(void))completion
{
    
    NSDictionary *options = @{
                              kCRToastTextKey : message,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor colorWithHexString:@"2e2e2e"],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    completion();
                                }];
}

/**
 *  显示错误信息
 *
 *  @param message    错误信息
 *  @param completion 动画完成回调
 */
+(void)showBigErrorMsg:(NSString *)message completionBlock:(void (^)(void))completion
{
    NSDictionary *options = @{
                              kCRToastTextKey : message,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    completion();
                                }];
}

@end
