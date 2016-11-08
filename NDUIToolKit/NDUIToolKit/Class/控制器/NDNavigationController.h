//
//  NDNavigationController.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  导航类父类
 */
@interface NDNavigationController : UINavigationController

@property(strong,nonatomic)UIViewController *rootViewController;  ///< 导航栏的root控制类

@end
