//
//  NDTDNetworkDataCache.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/*
 类说明：
 1.此类为工具类，缓存数据.
 2.此类支持多线程操作数据库，线程是安全的
 */

#import <Foundation/Foundation.h>
#import "NDTDHTTPRequestData.h"
#import "NDTDSocketRequestData.h"
#import "NDTDHTTPCallbackData.h"
#import "NDTDSocketCallbackData.h"

#define networkDataCacheDbName @"NetworkDataCache.db"  //库名
#define defaultTableName @"NetworkData"                //默认表名

static int networkDataCachedeleteDbTime = -1;                   //删除缓存的时间，小于0表示永久不删除，等于0表示程序启动时删除原有的缓存，大于0表示几天以后删除

@interface NDTDNetworkDataCache : NSObject
{
    
}

//单例模式
+ (NDTDNetworkDataCache *)shareInstance;

/**
 * 设置表名,如果要区分多个帐户缓存的数据，可调用此方法
 */
-(void)setTableName:(NSString *)tableName;

/**
 *  保存网络数据
 *  @param requestData:请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 *  @param callbackData:请求module,可传入NDTDHTTPCallbackData和NDTDSocketCallBackData类型
 *
 *  @return 保存成功返回yes,否者NO;
 */
-(void)saveNetworkData:(id)requestData callbackData:(id)callbackData results:(void (^)(BOOL isSuccessful))results;

/**
 *  获取缓存数据
 *
 *  @param requestData:请求module,可传入NDTDHTTPRequestData和NDTDSocketRequestData类型
 *
 *  @return 返回NDTDHTTPCallbackData类型或者NDTDSocketCallBackData
 */
-(void)getNetworkData:(id)requestData results:(void (^)(id callbackData))results;

@end
