//
//  UMLoginAndShare.h
//  NDSDK
//
//  Created by apple on 15/10/8.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import "UMShareData.h"
@protocol UMLoginAndShareDelegate <NSObject>

/**
 *  第三方授权成功
 *
 *  @param account 帐号信息
 */
@optional
-(void)umOauthSuccess:(UMSocialAccountEntity *)account;

/**
 *  第三方授权失败
 */
@optional
-(void)umOauthFail;

/**
 *  分享结果返回
 *
 *  @param response 分享结果
 */
@optional
-(void)umShareCallback:(UMSocialResponseEntity *)response;

@end

@interface UMLoginAndShare : NSObject<UMSocialUIDelegate>
{
    NSString *umengKey;
    NSString *wxAppId;
    NSString *wxAppSecret;
    NSString *qqAppId;
    NSString *qqAppSecret;
    NSString *sinaSSOUrl;
    NSString *shareUrl;
    
    UMShareData *shareData;
}

@property (nonatomic ,assign) id <UMLoginAndShareDelegate> umDelegate;


+(void)umInit:(NSString *)umengKey wxAppId:(NSString *)wxAppId wxAppSecret:(NSString *)wxAppSecret qqAppId:(NSString *)qqAppId qqAppSecret:(NSString *)qqAppSecret sinaAppId:(NSString *)sinaAppId sinaAppSecret:(NSString *)sinaAppSecret sinaSSOUrl:(NSString *)sinaSSOUrl shareUrl:(NSString *)shareUrl;
/**
 *  获取第三方登录授权
 *
 *  @param platformName 平台名称 UMSocialSnsTypeMobileQQ UMSocialSnsTypeSina UMSocialSnsTypeWechatSession
 *  @param controller   点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)umOauth:(UMSocialSnsType)snsType withController:(UIViewController *)controller;

/**
 *  图文分享，自带平台选择界面
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)umShareData:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  微信分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)wxShareData:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  微信朋友圈分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)wxpyqShareData:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  新浪微博分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)sinaShareData:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  qq分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)qqShareDate:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  qq空间分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)qzoneShareDate:(UMShareData *)data withController:(UIViewController *)controller;

/**
 *  腾讯微博分享
 *
 *  @param data       分享数据
 *  @param controller 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)txwbShareDate:(UMShareData *)data withController:(UIViewController *)controller;

@end
