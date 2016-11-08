//
//  ALYUploadPic.m
//  NDSDK
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "ALYUploadPic.h"

@implementation ALYUploadPic

+ (instancetype)shareInstance
{
    static ALYUploadPic *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}
/**
 *  设置阿里云oss参数
 *
 *  @param access    帐号
 *  @param secret    密钥
 *  @param bucke     bucke名称
 *  @param urlString url地址
 */
-(void)alyAccess:(NSString *)access alySecret:(NSString *)secret bucketName:(NSString *)bucke endPoint:(NSString *)urlString
{
    accessKey = access;
    secretKey = secret;
    endPoint = urlString;
    buckeName = bucke;
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3;
    conf.enableBackgroundTransmitService = NO;
    conf.timeoutIntervalForRequest = 15;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:secretKey];
        if (signature != nil) {
            *error = nil;
        } else {
            *error = [NSError errorWithDomain:@"" code:-1001 userInfo:nil];
            return nil;
        }
        NSLog(@"%@",[NSString stringWithFormat:@"OSS %@:%@", accessKey, signature]);
        return [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
    }];
    
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
    
}
/**
 *  阿里云oss上传图片
 *  @param image          图片
 *  @param name           图片id
 *  @param uploadProgress 上传进度block
 *  @param callback       完成回调block
 */
-(void)alyUploadPic:(UIImage *)image withName:(NSString *)name progress:(OSSNetworkingUploadProgressBlock)uploadProgress resultsCallback:(void (^)(BOOL success,NSString *string))callback
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = buckeName;
    put.objectKey = [NSString stringWithFormat:@"%@",name];
    
//    NSString *nameString = [NSString stringWithFormat:@"http://%@.%@/%@.png",buckeName,[endPoint substringFromIndex:7],name];
    
    NSData *data = UIImagePNGRepresentation(image);
    double area = data.length/1024;//kb
    NSLog(@"图片大小%fkb",area);
    if(area > 300)
    {
        data = UIImageJPEGRepresentation(image,0.5);
    }
    
    put.uploadingData = data;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        uploadProgress(bytesSent,totalByteSent,totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task)
    {
        if (!task.error) {
            NSLog(@"upload object success!");
            callback(YES ,name);
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            callback(NO ,name);
        }
        return nil;
    }];
}




@end
