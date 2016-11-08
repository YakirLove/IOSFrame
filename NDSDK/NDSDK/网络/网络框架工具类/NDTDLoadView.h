//
//  NDTDLoadView.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/13/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  网络请求加载页面
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NDTDHTTPRequestData.h"

#define operationalViewOfTime  1.5    //操作视图存在的时间

@interface NDTDLoadView : UIView

/**
 *  初始化
 *
 *  @param loadFatherView 加载的父视图
 *
 *  @return 初始化成功返回
 */

-(instancetype)init:(UIView *)loadFatherView;

/**
 *  自定义加载视图，默认使用MBProgressHUD，个性化定义请扩展此方法
 *
 *  @param requestData 请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 */
-(void)customLoadView:(id)requestData;

/**
 *  自定义操作视图，默认使用MBProgressHUD，个性化定义请扩展此方法
 *
 *  @param requestData 请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 */
-(void)customOperationView:(id)requestData;

/**
 *  显示加载视图
 *
 *  @param requestData 请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 */
-(void)showLoadedView:(id)requestData;

/**
 *  显示操作视图
 *
 *  @param requestData 请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 */
-(void)showOperationView:(id)requestData;

/**
 *  隐藏视图
 *
 *  @param requestData 请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 */
-(void)hiddenLoadedView:(id)requestData;

-(void)removeView;

@end
