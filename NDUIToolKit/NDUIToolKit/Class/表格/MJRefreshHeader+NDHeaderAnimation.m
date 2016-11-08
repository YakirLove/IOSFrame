//
//  MJRefreshHeader+NDHeaderAnimation.m
//  NDUIToolKit
//
//  Created by zhangx on 15/10/12.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "MJRefreshHeader+NDHeaderAnimation.h"

@implementation MJRefreshHeader (NDHeaderAnimation)


+ (void)load
{
    Class c = [MJRefreshHeader class];
    AutoCloseSwizzle(c, @selector(setState:), @selector(override_setState:));
}



- (void)override_setState:(MJRefreshState)state
{
    if (state == MJRefreshStateRefreshing && [self.superview isKindOfClass:[NDHeaderViewTableView class]]) {
        self.alpha = 0;
    }
    [self override_setState:state];
}

@end
