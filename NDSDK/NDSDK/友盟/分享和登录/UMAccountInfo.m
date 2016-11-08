//
//  UMAccountInfo.m
//  NDSDK
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UMAccountInfo.h"

@implementation UMAccountInfo

+(UMAccountInfo *)shareInstance
{
    static UMAccountInfo *account = nil;
    if (account == nil)
    {
        account = [[UMAccountInfo alloc] init];
    }
    return account;
}


@end
