//
//  NDSDK.m
//  NDSDK
//
//  Created by zhangx on 15/7/9.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDSDK.h"
#import "FMDatabase.h"
#import "NDTDHTTPRequest.h"


void AutoCloseSwizzle(Class c, SEL orig, SEL newg)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, newg);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, newg, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation NDSDK

+(void)test
{
//    [OMGToast showWithText:@"12121212" bottomOffset:100 duration:50];
    
//    [[NDTDHTTPRequest shareInstance] startSingleSendRequest:[NDTDHTTPRequestData quicklyGenerateRequestData:@"1-1-1" requestDic:nil] results:^(NDTDHTTPCallbackData *callbackData) {
//    }];
}

@end
