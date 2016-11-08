//
//  NDBaseViewModel.h
//  NDSDK
//
//  Created by zhangx on 15/9/15.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(ViewModel)

- (void)callBackAction;

- (void)callBackAction:(NSUInteger)action;

- (void)callBackAction:(NSUInteger)action info:(id)info;

@end

@interface NDBaseViewModel : NSObject

@property (nonatomic,weak) UIViewController *viewController;

+ (instancetype)modelWithViewController:(UIViewController *)viewController;

@end
