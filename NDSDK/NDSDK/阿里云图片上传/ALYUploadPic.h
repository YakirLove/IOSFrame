//
//  ALYUploadPic.h
//  NDSDK
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <AliyunOSSiOS/OSSModel.h>
#import <AliyunOSSiOS/OSSClient.h>
#import <AliyunOSSiOS/OSSUtil.h>

@interface ALYUploadPic : NSObject
{
    OSSClient *client;
    NSString *accessKey;
    NSString *secretKey;
    NSString *endPoint;
    NSString *buckeName;
}

+ (instancetype)shareInstance;
/**
 *  设置阿里云oss参数
 *
 *  @param access    帐号
 *  @param secret    密钥
 *  @param bucke     bucke名称
 *  @param urlString url地址
 */
-(void)alyAccess:(NSString *)access alySecret:(NSString *)secret bucketName:(NSString *)bucke endPoint:(NSString *)urlString;

/**
 *  阿里云oss上传图片
 *
 *  @param image          图片
 *  @param uploadProgress 上传进度block
 *  @param callback       完成回调block
 */
-(void)alyUploadPic:(UIImage *)image  withName:(NSString *)name progress:(OSSNetworkingUploadProgressBlock)uploadProgress resultsCallback:(void (^)(BOOL success,NSString *string))callback;

@end
