//
//  NDWebViewController.h
//  NDUIToolKit
//
//  Created by zhangx on 15/9/7.
//  Copyright © 2015年 nd. All rights reserved.
//

@interface NDWebViewController : NDViewController

@property(assign,nonatomic)BOOL isCustomNavBar;  ///< 是否自定义导航栏

/**
 *  初始化对象
 *
 *  @param url 跳转地址
 *
 *  @return webvc对象
 */
- (instancetype)initWithUrl:(NSString *)url;


/**
 *  初始化对象
 *
 *  @param url            跳转地址
 *  @param isCustomNavBar 是否是自定义导航栏
 *
 *  @return webvc对象
 */
- (instancetype)initWithUrl:(NSString *)url isCustomNavBar:(BOOL)isCustomNavBar;

@end
