//
//  NDBaseViewModel.m
//  NDSDK
//
//  Created by zhangx on 15/9/15.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDBaseViewModel.h"

@implementation UIViewController(ViewModel)

- (void)callBackAction{
    [self callBackAction:0 info:nil];
}

- (void)callBackAction:(NSUInteger)action{
    [self callBackAction:action info:nil];
}

- (void)callBackAction:(NSUInteger)action info:(id)info
{
    
}

@end

@implementation NDBaseViewModel

+ (instancetype)modelWithViewController:(UIViewController *)viewController{
    static NDBaseViewModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[[self class] alloc] init];
        model.viewController = viewController;
    });
    return model;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"View model:%@ viewController:%@",
            super.description,
            self.viewController.description
            ];
}

@end
