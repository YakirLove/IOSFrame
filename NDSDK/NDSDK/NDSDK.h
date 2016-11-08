//
//  NDSDK.h
//  NDSDK
//
//  Created by zhangx on 15/7/9.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NDDate.h"
#import "NDColor.h"
#import "NDString.h"
#import "NDConfig.h"
#import "NDAlbums.h"
#import "NDImageFilter.h"
//#import "NDLog.h"
#import "NDCommonFunc.h"
#import "NDCameraUtils.h"
#import "NSData+Category.h"
#import <objc/runtime.h>
#import "NDTDHTTPRequest.h"
#import "UMLoginAndShare.h"
#import "UmengStatistical.h"
#import "GTMBase64.h"
#import "NDKeychain.h"
#import "NDTDFileUtility.h"
#import "RegexKitLite.h"
#import "ALYUploadPic.h"

/**
 *  重写oc方法
 *
 *  @param c
 *  @param orig
 *  @param new
 */
void AutoCloseSwizzle (Class c, SEL orig, SEL newg);

@interface NDSDK : NSObject

+(void)test;

@end
