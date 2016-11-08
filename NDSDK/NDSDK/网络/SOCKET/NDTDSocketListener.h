//
//  NDTDSocketListener.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 8/31/15.
//  Copyright (c) 2015 林. All rights reserved.
//
/**
 scoket 监听
 */

#import <Foundation/Foundation.h>
#import "NDTDSocketDelegate.h"
#import "NDTDSocketRequestData.h"
#import "NDTDSocketCode.h"

//消息的发送方类型
typedef enum
{
    parsComplete = 0,                           //数据解析完成
    parsMultiple = 1,                           //多个包体
    parsFailure = 2,                            //数据解析失败
    parsContinue =3                             //等待数据继续解析
    
}ParsType;

#define HeartbeaTime 60               //心跳时间

@interface NDTDSocketListener : NSObject
{
}

@property(nonatomic,assign)BOOL isConnection;        ///< socket是否连接状态

//单例模式
+ (NDTDSocketListener *)shareInstance;

//添加委托
- (void)addDelegate:(id<NDTDSocketDelegate>)delegate;
//删除委托，没有用的时候记得调用这个删除委托,否者会持续收到消息
- (void)removeDelegate:(id<NDTDSocketDelegate>)delegate;

/**
 *  连接socket
 *
 *  @param hostIP IP地址
 *  @param port   端口
    
 *  @return 返回是否连接成功
 */
-(BOOL)connectionSocket:(NSString *)hostIP port:(UInt16)port;
//主动断开socket连接
-(void)cutOffSocket;

/**
 *  发送消息
 *
 *  @param requestData 参数
 *
 *  @return 返回是否发送成功
 */
-(BOOL)sendSocketData:(NDTDSocketRequestData *)requestData;

/**
 *  数据组合，用于请求（不同的应用数据组合的协议不同，请重写此方法）
 *
 *  @param requestData 参数
 *
 *  @return 返回组合好的二进制数据
 */
+(NSData *)override_combiningData:(NDTDSocketRequestData *)requestData;


+(ParsType )override_parsingData:(NSData*)data packetDic:(NSMutableDictionary *)packetDic residueData:(NSData *)residueData;

static void im_crypt(const char *szpro, char *pkdata, int nlen,int headLength);

@end
