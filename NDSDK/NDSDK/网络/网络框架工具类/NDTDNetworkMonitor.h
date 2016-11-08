//
//  NDTDNetworkMonitoring.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/*
 类说明：
 1.此类为工具类，监听网络环境变化.
 2.统计流量
 */


/**********************网络环境监听类型*****************************/
typedef enum
{
    NDTDNetworkMonitorNotOpen                     = -2,  //未开启
    NDTDNetworkReachabilityStatusUnknown          = -1,  // 未知
    NDTDNetworkReachabilityStatusNotReachable     = 0,   // 无连接
    NDTDNetworkReachabilityStatusReachableViaWWAN = 1,   // 2G/3G/4G
    NDTDNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi网络
}NDTDNetworkReachabilityStatus;

/*********************获取的流量类型*****************************/
typedef enum
{
    AllFlowType  = 0,        //获取使用的所有流量
    MobileFlowType = 1,      //获取移动网络使用的流量（2g，3g，4g等）
    WiftFlowType = 2         //获取wift使用的流量
}GetUseFlowType;


#import <Foundation/Foundation.h>

@protocol NDTDNetworkMonitorDelegate <NSObject>

//打开监听的回调
-(void)networkMonitorDidOpenMonitor:(NDTDNetworkReachabilityStatus)status;

//网络环境变化时的回调，需addDelegate添加观察者
-(void)networkMonitorDidChange:(NDTDNetworkReachabilityStatus)status;

@end

@interface NDTDNetworkMonitor : NSObject

@property(nonatomic,assign)NDTDNetworkReachabilityStatus status;       //网络状态
@property(nonatomic,assign)long long int currentApplicationWifiFlow;   //app当前使用的wift流量
@property(nonatomic,assign)long long int currentApplicationMobileFlow; //app当前使用的移动流量

+(instancetype)shareInstance;

//打开网络监听,默认不打开
-(void)open;
//关闭网络监听
-(void)close;

//添加观察者（委托)
- (void)addDelegate:(id<NDTDNetworkMonitorDelegate>)delegate;
//删除观察者（委托）
- (void)removeDelegate:(id<NDTDNetworkMonitorDelegate>)delegate;

//获取启动到现在http接口使用的流量(单位B)，程序退出清零
-(long long int)getHTTPApplicationCurrentFlowBytes:(GetUseFlowType)getUseFlowType;
//获取应用历史http接口使用的流量(单位B)，删除应用记录清零
-(long long int)getHTTPApplicationAllFlowBytes:(GetUseFlowType)getUseFlowType;
//获取系统所有应用消耗的流量(单位B),关机以后清零
-(long long int)getSystemFlowIOBytes:(GetUseFlowType)getUseFlowType;


@end
