//
//  NDTDHTTPRequest.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 * 类功能说明:
 1.请求数据缓存策略
 2.自动加载网络提醒
 3.网络数据模拟
 5.请求队列管理
 6.重连次数配置
 7.请求失败自动提醒
 */

#import <Foundation/Foundation.h>
#import "AFJSONResponseSerializer+Categary.h"
#import "NDTDHTTPRequestData.h"
#import "NDTDHTTPCallbackData.h"
#import "NDTDNetworkDataCache.h"
#import "NDTDNetworkMonitor.h"
#import "NDTDHTTPCode.h"
@class AFHTTPRequestOperationManager;
@class NDTDHTTPCallbackData;

#define simulateTimeValue 2.0              //模拟数据回调的时间
#define FailureRemindDefaultHeight 50.0    //错误提醒的默认高度

#define NDTDRequestShareInstance ([NDTDHTTPRequest shareInstance])    //快速实现单例

@interface NDTDHTTPRequest : NSObject
{
    NSString *urlString;
}

+(instancetype)shareInstance;


//替换接口缓存的db库名，有分登录帐户数据时，可以设置此方法区分数据
-(void)replaceCacheLibraryName:(NSString *)interfaceCacheName;

/**
 *  单个请求
 *
 *  @param requestData 请求参数
 *  @param results     结果回调
 */
-(void)startSingleSendRequest:(NDTDHTTPRequestData *)requestData results:(void (^)(NDTDHTTPCallbackData *callbackData))results;

/**
 *  多个请求,接口如果有关联，你可以在参数nextRequestData添加相应参数
 *
 *
 *  @param requestArray 数组里为NDTDHTTPRequestData对象
 *  @param isRely       接口间是否有依赖关系。当为YES时，将根据requestArray数组的顺序队列请求，          当为NO时，一次性并发请求，提高加载速度,网络提醒语句统一成 “正在努力加载...”;
 *  @param results      结果回调,参数nextRequestData为下个请求，如果没有下个请求或者依赖关系isRely=NO时返回将nil;callbackData为当前的结果回调.
 */
-(void)startMultipleSendRequest:(NSMutableArray *)requestArray isRely:(BOOL)isRely results:(void (^)(NDTDHTTPRequestData *nextRequestData,NDTDHTTPCallbackData *callbackData))results;

/**
 *  配置HttpHead和HTTPBody协议，不同的应用协议不同，请扩展此方法覆盖
 *
 *  @param requestData 请求的参数
 *  @param results     返回AFHTTPRequestOperationManage或者NSMutableURLRequest对象。如果是正常数据请求返回AFHTTPRequestOperationManage，如果是图片语音上传返回NSMutableURLRequest
 */
-(id)configurationHttpHeaderHTTPBody:(NDTDHTTPRequestData *)requestData;

/**
 *  解析网络返回的数据，不同的应用解析数据协议可能不同，请扩展此方法覆盖
 *
 *  @param responseObject 网络返回的数据
 *
 *  @return 返回解析成功的数据
 */
-(NDTDHTTPCallbackData *)parsingCallbackData:(id)responseObject requestData:(NDTDHTTPRequestData *)requestData error:(NSError *)error;

@end
