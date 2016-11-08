//
//  NDTDNetworkMonitoring.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDNetworkMonitor.h"
#import "AFNetworking.h"

#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

#define HISTORYAPPLICATIONWIFTFLOW @"historyApplicationWiftFlow"
#define HISTORYAPPLICATIONMOBILEFLOW @"historyApplicationMobileFlow"

@interface NDTDNetworkMonitor()
{
    NSMutableArray *delegateArray;
    long long int currentSystemWifiFlow;              //系统使用的wift流量
    long long int currentSystemMobileFlow;            //系统使用的移动流量
    long long int historyApplicationWifiFlow;         //app历史使用的所有wift流量
    long long int historyApplicationMobileFlow;       //app历史使用的所有移动流量
    
    long long int tempCurrenApplicationWifiFlow;      //临时的当前wifi
    long long int tempCurrenApplicationMobileFlow;
    
    
}

@end

@implementation NDTDNetworkMonitor
@synthesize currentApplicationMobileFlow;
@synthesize currentApplicationWifiFlow;

static NDTDNetworkMonitor *_manager;

+ (id)shareInstance
{
    @synchronized(self){
        if (!_manager) {
            _manager = [[NDTDNetworkMonitor alloc] init];
            
        }
        return _manager;
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)dealloc
{
    //UIApplicationWillEnterForegroundNotification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)initData
{
    _status = NDTDNetworkMonitorNotOpen;
    delegateArray = [[NSMutableArray alloc]init];
    currentSystemMobileFlow = [self getSystemGprsFlowIOBytes];
    currentSystemWifiFlow = [self getSystemInterfaceBytes];
    currentApplicationMobileFlow = 0;
    currentApplicationWifiFlow = 0;
    tempCurrenApplicationMobileFlow = currentApplicationMobileFlow;
    tempCurrenApplicationWifiFlow = currentApplicationWifiFlow;
    NSString * historyApplicationWiftFlowString = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYAPPLICATIONWIFTFLOW];
    if (historyApplicationWiftFlowString ==nil || [historyApplicationWiftFlowString isEqualToString:@""] || [historyApplicationWiftFlowString isKindOfClass:[NSNull class]]) {
        historyApplicationWifiFlow = 0;
    }
    else
    {
        historyApplicationWifiFlow = [historyApplicationWiftFlowString longLongValue];
    }
    NSString * historyApplicationMobileFlowString = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYAPPLICATIONMOBILEFLOW];
    if (historyApplicationMobileFlowString ==nil || [historyApplicationMobileFlowString isEqualToString:@""] || [historyApplicationMobileFlowString isKindOfClass:[NSNull class]]) {
        historyApplicationMobileFlow = 0;
    }
    else
    {
        historyApplicationMobileFlow = [historyApplicationMobileFlowString longLongValue];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackgroundFlowMonitor) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - 检测网络连接
- (void)reach
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        static BOOL isFirstTime=YES;
        if (isFirstTime==NO) {
            if (_status!=status) {
                for (int i=0; i<delegateArray.count; i++) {
                    id<NDTDNetworkMonitorDelegate>delegate=[delegateArray objectAtIndex:i];
                    if ([delegate respondsToSelector:@selector(networkMonitorDidChange:)]) {
                        [delegate networkMonitorDidChange:(NDTDNetworkReachabilityStatus)status];
                    }
                }
            }
        }
        else
        {
            //第一次开启.什么都不做处理
            /*
            for (int i=0; i<delegateArray.count; i++) {
                id<NDTDNetworkMonitorDelegate>delegate=[delegateArray objectAtIndex:i];
                if ([delegate respondsToSelector:@selector(networkMonitorDidChange:)]) {
                    [delegate networkMonitorDidChange:(NDTDNetworkReachabilityStatus)status];
                }
            }
             */
        }
        isFirstTime=NO;
        _status = (NDTDNetworkReachabilityStatus)status;
    }];
}

//打开监听
-(void)open
{
    [self reach];
}

//关闭监听
-(void)close
{
    _status = NDTDNetworkMonitorNotOpen;
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

//添加观察者（委托）
- (void)addDelegate:(id<NDTDNetworkMonitorDelegate>)delegate
{
    if (delegate!=nil) {
        if ([delegateArray containsObject:delegate]==NO) {
            [delegateArray addObject:delegate];
        }
    }

}

//删除观察者（委托）
- (void)removeDelegate:(id<NDTDNetworkMonitorDelegate>)delegate
{
    if (delegate!=nil) {
        if ([delegateArray containsObject:delegate]==YES) {
            [delegateArray removeObject:delegate];
        }
    }

}

#pragma mark -- 流量相关

-(void)applicationDidEnterBackgroundFlowMonitor
{
    currentSystemMobileFlow = [self getSystemGprsFlowIOBytes];
    currentSystemWifiFlow  = [self getSystemInterfaceBytes];
    //保存流量到文件中
    historyApplicationMobileFlow = historyApplicationMobileFlow+(currentApplicationMobileFlow-tempCurrenApplicationMobileFlow);
    historyApplicationWifiFlow = historyApplicationWifiFlow+(currentApplicationWifiFlow-currentApplicationWifiFlow);
    tempCurrenApplicationMobileFlow = currentApplicationMobileFlow;
    tempCurrenApplicationWifiFlow = currentApplicationWifiFlow;
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lld",historyApplicationMobileFlow] forKey:HISTORYAPPLICATIONMOBILEFLOW];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lld",historyApplicationWifiFlow] forKey:HISTORYAPPLICATIONWIFTFLOW];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


//获取自己应用此次消耗的流量
-(long long int)getHTTPApplicationCurrentFlowBytes:(GetUseFlowType)getUseFlowType
{
    if (getUseFlowType == AllFlowType) {
        return currentApplicationWifiFlow+currentApplicationMobileFlow;
    }
    else if (getUseFlowType == WiftFlowType)
    {
        return currentApplicationWifiFlow;
    }
    else
    {
        return currentApplicationMobileFlow;
    }
}
//获取自己应用消耗的流量，包括历史(单位B)，删除应用记录清零
-(long long int)getHTTPApplicationAllFlowBytes:(GetUseFlowType)getUseFlowType
{
    NSString * historyApplicationWiftFlowString = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYAPPLICATIONWIFTFLOW];
    if (historyApplicationWiftFlowString ==nil || [historyApplicationWiftFlowString isEqualToString:@""] || [historyApplicationWiftFlowString isKindOfClass:[NSNull class]]) {
        historyApplicationWifiFlow = 0;
    }
    else
    {
        historyApplicationWifiFlow = [historyApplicationWiftFlowString longLongValue];
    }
    NSString * historyApplicationMobileFlowString = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORYAPPLICATIONMOBILEFLOW];
    if (historyApplicationMobileFlowString ==nil || [historyApplicationMobileFlowString isEqualToString:@""] || [historyApplicationMobileFlowString isKindOfClass:[NSNull class]]) {
        historyApplicationMobileFlow = 0;
    }
    else
    {
        historyApplicationMobileFlow = [historyApplicationMobileFlowString longLongValue];
    }
    
    historyApplicationMobileFlow = historyApplicationMobileFlow+(currentApplicationMobileFlow-tempCurrenApplicationMobileFlow);
    historyApplicationWifiFlow = historyApplicationWifiFlow+(currentApplicationWifiFlow-tempCurrenApplicationWifiFlow);
    tempCurrenApplicationWifiFlow = currentApplicationWifiFlow;
    tempCurrenApplicationMobileFlow = currentApplicationMobileFlow;
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lld",historyApplicationMobileFlow] forKey:HISTORYAPPLICATIONMOBILEFLOW];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lld",historyApplicationWifiFlow] forKey:HISTORYAPPLICATIONWIFTFLOW];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (getUseFlowType == AllFlowType) {
        return historyApplicationMobileFlow+historyApplicationWifiFlow;
    }
    else if (getUseFlowType == WiftFlowType)
    {
        return historyApplicationWifiFlow;
    }
    else
    {
        return historyApplicationMobileFlow;
    }

}


/*
原理：通过函数getifaddrs来得到系统网络接口的信息，网络接口的信息, 包含在if_data字段中, 有很多信息, 但我现在只关心ifi_ibytes, ifi_obytes, 应该就是接收到的字节数和发送的字节数, 加起来就是流量了. 还发现, 接口的名字, 有en, pdp_ip, lo等几种形式, en应该是wifi, pdp_ip大概是3g或者gprs, lo是环回接口, 通过名字区分可以分别统计
 */

//获取系统消耗的流量(单位B),关机以后清零
-(long long int)getSystemFlowIOBytes:(GetUseFlowType)getUseFlowType
{
    if (getUseFlowType == AllFlowType) {
        return [self getSystemInterfaceBytes]+[self getSystemGprsFlowIOBytes];
    }
    else if (getUseFlowType == WiftFlowType)
    {
        return [self getSystemInterfaceBytes];
    }
    else
    {
        return [self getSystemGprsFlowIOBytes];
    }
}


//获取2g，3g，4g等流量
-(long long int)getSystemGprsFlowIOBytes
{
    struct ifaddrs *ifa_list= 0, *ifa;
    
    if (getifaddrs(&ifa_list)== -1)
    {
        return 0;
    }
    uint32_t iBytes =0;
    uint32_t oBytes =0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK!= ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags& IFF_UP) &&!(ifa->ifa_flags& IFF_RUNNING))
            continue;
        if (ifa->ifa_data== 0)
            continue;
        //if (!strcmp(ifa->ifa_name,"pdp_ip0"))
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            NSLog(@"%s :iBytes is %d, oBytes is %d",ifa->ifa_name, iBytes, oBytes);
        }
        
    }
    freeifaddrs(ifa_list);
    return iBytes + oBytes;
    
}

//WIFI流量统计功能
- (long long int)getSystemInterfaceBytes;
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "en", 2)==0)
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
        
    }
    
    freeifaddrs(ifa_list);
    return iBytes+oBytes;
}

@end

