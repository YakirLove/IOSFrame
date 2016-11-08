//
//  UmengStatistical.m
//  NDSDK
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UmengStatistical.h"

@implementation UmengStatistical

+(void)umengStatistical:(NSString *)umeng appVersion:(NSString *)version;
{
    //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:NO];
    [MobClick setAppVersion:version];

    UMConfigInstance.appKey = umeng;
    UMConfigInstance.ChannelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

@end
