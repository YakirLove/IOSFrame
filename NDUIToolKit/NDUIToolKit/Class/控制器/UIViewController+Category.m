//
//  UIViewController+Category.m
//  NDUIToolKit
//
//  Created by zhangx on 15/10/14.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

+ (void)load
{
    Class c = [UIViewController class];
    AutoCloseSwizzle(c, @selector(viewWillAppear:), @selector(override_viewWillAppear:));
    AutoCloseSwizzle(c, @selector(viewWillDisappear:), @selector(override_viewWillDisappear:));
}

static const char DefaultStatusBarKey;
- (void)setDefaultStatusBar:(BOOL)defaultStatusBar
{
    if (defaultStatusBar != self.defaultStatusBar) {
        // 存储新的
        [self willChangeValueForKey:@"defaultStatusBar"]; // KVO
        objc_setAssociatedObject(self, &DefaultStatusBarKey,
                                 [NSNumber numberWithBool:defaultStatusBar], OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"defaultStatusBar"]; // KVO
    }
}

- (BOOL)defaultStatusBar
{
    return [objc_getAssociatedObject(self, &DefaultStatusBarKey) boolValue];
}


static const char BarStyleKey;
- (void)setBarStyle:(UIStatusBarStyle)barStyle
{
    if (barStyle != self.barStyle) {
        // 存储新的
        [self willChangeValueForKey:@"barStyle"]; // KVO
        objc_setAssociatedObject(self, &BarStyleKey,
                                 [NSNumber numberWithInteger:barStyle], OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"barStyle"]; // KVO
    }
}

- (UIStatusBarStyle)barStyle
{
    return [objc_getAssociatedObject(self, &BarStyleKey) integerValue];
}

- (void)override_viewWillAppear:(BOOL)animated
{
    [self override_viewWillAppear:animated];
    if (self.defaultStatusBar) {
        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    }
}

- (void)override_viewWillDisappear:(BOOL)animated
{
    [self override_viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}



/**
 *  根据类名加载
 *
 *  @param className 类名
 *
 *  @return 对象
 */
+ (UIViewController *)loadByClassName:(NSString *)className
{
    Class c = NSClassFromString(className);
    UIViewController *controller = [[c alloc] initWithNibName:className bundle:nil];
    return controller;
}


@end
