//
//  AFJSONResponseSerializer+Categary.m
//  NDSDK
//
//  Created by zhangx on 15/10/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "AFJSONResponseSerializer+Categary.h"

@implementation AFJSONResponseSerializer (Categary)

+ (void)load
{
    Class c = [AFJSONResponseSerializer class];
    AutoCloseSwizzle(c, @selector(init), @selector(override_init));
}

-(instancetype)override_init
{
    id obj = [self override_init];
    if (obj) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/octet-stream",@"text/json", @"text/javascript", nil];
    }
    return obj;
}

@end
