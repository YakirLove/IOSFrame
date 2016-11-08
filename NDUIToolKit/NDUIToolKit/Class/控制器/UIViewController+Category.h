//
//  UIViewController+Category.h
//  NDUIToolKit
//
//  Created by zhangx on 15/10/14.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

@property(nonatomic,assign)BOOL defaultStatusBar; ///< 是否使用默认的黑色状态栏
@property(nonatomic,assign)UIStatusBarStyle barStyle;  ///< 状态条类型


/**
 *  根据类名加载
 *
 *  @param className 类名
 *
 *  @return 对象
 */
+ (UIViewController *)loadByClassName:(NSString *)className;

@end
