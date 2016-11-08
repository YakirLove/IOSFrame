//
//  UIWindow+Subviews.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UIWindow+Subviews.h"
#import <objc/runtime.h>

@implementation UIWindow (Subviews)

static const char ControledSubviewsKey = '\0';
- (void)setControledSubviews:(NSMutableArray *)controledSubviews
{
    if (controledSubviews != self.controledSubviews) {
        // 存储新的
        [self willChangeValueForKey:@"controledSubviews"]; // KVO
        objc_setAssociatedObject(self, &ControledSubviewsKey,
                                 controledSubviews, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"controledSubviews"]; // KVO
    }
}

- (NSMutableArray *)controledSubviews
{
    return objc_getAssociatedObject(self, &ControledSubviewsKey);
}


#pragma mark 加入子视图
-(void)addControledSubview:(UIView *)subview
{
    if (self.controledSubviews == nil) {
        self.controledSubviews = [[NSMutableArray alloc] init];
    }
    
    if ([self.controledSubviews containsObject:subview] == NO) {
        [self.controledSubviews addObject:subview];
    }
    
    [self addSubview:subview];
}

#pragma mark 移除子视图
-(void)removeControledSubview:(UIView *)subview
{
    [self.controledSubviews removeObject:subview];
    [subview removeFromSuperview];
}

#pragma mark 移除所有的受监控子视图
-(void)removeAllControledSubviews
{
    [self.controledSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.controledSubviews removeAllObjects];
}

@end
