//
//  NDCameraUtils.m
//  NDSDK
//
//  Created by zhangx on 15/9/14.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDCameraUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NDCameraUtils

#pragma mark 相机是否可用
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark 相机是否可以拍照
+ (BOOL) doesCameraSupportTakingPhotos {
    return [NDCameraUtils cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark 相机是否支持媒体类型
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark 前置摄像机是否可用
+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

#pragma mark 后置相机是否可以使用
+ (BOOL) isBackCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

@end
