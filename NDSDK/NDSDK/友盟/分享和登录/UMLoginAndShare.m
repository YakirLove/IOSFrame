//
//  UMLoginAndShare.m
//  NDSDK
//
//  Created by apple on 15/10/8.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UMLoginAndShare.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialDataService.h"
#import "UMAccountInfo.h"

@implementation UMLoginAndShare

@synthesize umDelegate;

//+ (id)shareInstance
//{
//    @synchronized(self){
//        static UMLoginAndShare *login = nil;
//        if (!login) {
//            login = [[UMLoginAndShare alloc] init];
//        }
//        return login;
//    }
//}


+(void)umInit:(NSString *)umengKey wxAppId:(NSString *)wxAppId wxAppSecret:(NSString *)wxAppSecret qqAppId:(NSString *)qqAppId qqAppSecret:(NSString *)qqAppSecret sinaAppId:(NSString *)sinaAppId sinaAppSecret:(NSString *)sinaAppSecret sinaSSOUrl:(NSString *)sinaSSOUrl shareUrl:(NSString *)shareUrl
{
    [UMAccountInfo shareInstance].umengKey = [NSString stringWithFormat:@"%@",umengKey];
    [UMAccountInfo shareInstance].wxAppId = [NSString stringWithFormat:@"%@",wxAppId];
    [UMAccountInfo shareInstance].wxAppSecret = [NSString stringWithFormat:@"%@",wxAppSecret];
    [UMAccountInfo shareInstance].qqAppId = [NSString stringWithFormat:@"%@",qqAppId];
    [UMAccountInfo shareInstance].qqAppSecret = [NSString stringWithFormat:@"%@",qqAppSecret];
    [UMAccountInfo shareInstance].sinaSSOUrl = [NSString stringWithFormat:@"%@",sinaSSOUrl];
    [UMAccountInfo shareInstance].shareUrl = [NSString stringWithFormat:@"%@",shareUrl];
    [UMAccountInfo shareInstance].sinaAppId = [NSString stringWithFormat:@"%@",sinaAppId];
    [UMAccountInfo shareInstance].sinaAppSecret = [NSString stringWithFormat:@"%@",sinaAppSecret];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:umengKey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:wxAppId appSecret:wxAppSecret url:shareUrl];
    
    
    //设置新浪微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:sinaAppId
                                              secret:sinaAppSecret
                                         RedirectURL:sinaSSOUrl];

    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:qqAppId appKey:qqAppSecret url:shareUrl];
    
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
}

//+(BOOL)canLogin:(NSString *)platformName
//{
//    return [UMSocialAccountManager isOauthAndTokenNotExpired:platformName];
//}

/**
 *  获取第三方登录授权
 *
 *  @param platformName 平台名称 UMShareToSina UMShareToWechatSession UMShareToQQ
 *  @param controller   点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
-(void)umOauth:(UMSocialSnsType)snsType withController:(UIViewController *)controller
{
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:snsType];
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(controller,
                                  [UMSocialControllerService defaultControllerService],
                                  YES,
                                  ^(UMSocialResponseEntity *response)
                                  {
                                      //获取微博用户名、uid、token等
                                      if (response.responseCode == UMSResponseCodeSuccess)
                                      {
                                          UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                                          NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                                          if([umDelegate respondsToSelector:@selector(umOauthSuccess:)])
                                          {
                                              [umDelegate umOauthSuccess:snsAccount];
                                          }
                                      }
                                      else
                                      {
                                          if([umDelegate respondsToSelector:@selector(umOauthFail)])
                                          {
                                              [umDelegate umOauthFail];
                                          }
                                      }
                                  });
}





#pragma mark - 图文分享自带界面

-(void)umShareData:(UMShareData *)data withController:(UIViewController *)controller
{
    shareData = data;
//    if(data.url != nil && ![data.url isEqualToString:@""])
//    {
//        [UMSocialWechatHandler setWXAppId:WXAPPID appSecret:WXAPPSECRET url:data.url];
//        [UMSocialQQHandler setQQWithAppId:QQAPPID appKey:WXAPPSECRET url:data.url];
//    }
//    NSLog(@"%@",[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray);
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:[UMSocialData appKey]
                                      shareText:data.content
                                     shareImage:data.image
                                shareToSnsNames:@[@"sina",@"wxsession",@"wxtimeline",@"qq",@"qzone",@"tencent"]
                                       delegate:self];
}
#pragma mark - UMSocialUIDelegate

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 
 -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 {
 if (platformName == UMShareToSina) {
 socialData.shareText = @"分享到新浪微博的文字内容";
 }
 else{
 socialData.shareText = @"分享到其他平台的文字内容";
 }
 }
 使用自带分享渠道选择页面
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
//    if (platformName == UMShareToSina)
//    {
//        socialData.shareText  = [NSString stringWithFormat:@"%@\n%@",shareData.url,shareData.content];
//    }
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseType == UMSResponseShareToSNS)//分享到一个微博平台
    {
        if([umDelegate respondsToSelector:@selector(umShareCallback:)])
        {
            [umDelegate umShareCallback:response];
        }
    }
    else if(response.responseType == UMSResponseShareToMutilSNS)//分享到多个微博平台
    {
        if([umDelegate respondsToSelector:@selector(umShareCallback:)])
        {
            [umDelegate umShareCallback:response];
        }
    }
    else if(response.responseType == UMSResponseOauth)//授权
    {
    }
    else if(response.responseType == UMSResponseGetAccount)//获取账户信息
    {
    }
    else if(response.responseType == UMSResponseIsTokenValid)//获取各个微博平台的token是否有效
    {
    }
}

#pragma mark -

#pragma mark - 内容分享无界面

-(void)wxShareData:(UMShareData *)data withController:(UIViewController *)controller
{
    if(data.image != nil)
    {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    }
    
    if(data.url != nil && ![data.url isEqualToString:@""])
    {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    

    [[UMSocialControllerService defaultControllerService] setShareText:data.content shareImage:data.image socialUIDelegate:self];
    
    [UMSocialWechatHandler setWXAppId:[UMAccountInfo shareInstance].wxAppId appSecret:[UMAccountInfo shareInstance].wxAppSecret url:data.url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}


-(void)wxpyqShareData:(UMShareData *)data withController:(UIViewController *)controller
{
    if(data.image != nil)
    {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    }
    
    if(data.url != nil && ![data.url isEqualToString:@""])
    {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:data.content shareImage:data.image socialUIDelegate:self];
    [UMSocialWechatHandler setWXAppId:[UMAccountInfo shareInstance].wxAppId appSecret:[UMAccountInfo shareInstance].wxAppSecret url:data.url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

-(void)sinaShareData:(UMShareData *)data withController:(UIViewController *)controller
{
    NSString *content = [NSString stringWithFormat:@"%@",data.content];
    if(data.url != nil && ![data.url isEqualToString:@""])
    {
        content = [NSString stringWithFormat:@"%@\n%@",data.url,content];
    }
    [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:data.image socialUIDelegate:self];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:[UMAccountInfo shareInstance].sinaAppId secret:[UMAccountInfo shareInstance].sinaAppSecret RedirectURL:[UMAccountInfo shareInstance].sinaSSOUrl];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

-(void)qqShareDate:(UMShareData *)data withController:(UIViewController *)controller
{
    [[UMSocialControllerService defaultControllerService] setShareText:data.content shareImage:data.image socialUIDelegate:self];
    [UMSocialQQHandler setQQWithAppId:[UMAccountInfo shareInstance].qqAppId appKey:[UMAccountInfo shareInstance].qqAppSecret url:data.url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

-(void)qzoneShareDate:(UMShareData *)data withController:(UIViewController *)controller
{
    [[UMSocialControllerService defaultControllerService] setShareText:data.content shareImage:data.image socialUIDelegate:self];
    [UMSocialQQHandler setQQWithAppId:[UMAccountInfo shareInstance].qqAppId appKey:[UMAccountInfo shareInstance].qqAppSecret url:data.url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qzone"].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

-(void)txwbShareDate:(UMShareData *)data withController:(UIViewController *)controller
{
    [[UMSocialControllerService defaultControllerService] setShareText:data.content shareImage:data.image socialUIDelegate:self];
    [UMSocialQQHandler setQQWithAppId:[UMAccountInfo shareInstance].qqAppId appKey:[UMAccountInfo shareInstance].qqAppSecret url:data.url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}


@end
