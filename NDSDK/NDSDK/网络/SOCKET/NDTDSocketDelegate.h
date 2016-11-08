//
//  NDTDSocketDelegate.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 8/31/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 scoket 委托
 */

//断开标示
typedef enum
{
    SocketOfflineByServer = 0,                 //服务端断开
    SocketOfflineByUser = 1                    //客户端断开
    
}SocketCutOffState;

@class AsyncSocket;
@class NDTDSocketCallbackData;

@protocol NDTDSocketDelegate <NSObject>

@optional

//Socket连接成功回调
-(void)didSocketConnectionSuccessful:(AsyncSocket *)socket;
//Socket连接失败回调
-(void)didSocketConnectionFailure:(AsyncSocket *)socket error:(NSError *)error;
//socket断开回调
-(void)didSocketCutOff:(SocketCutOffState )socketCutOffState;
//发送成功
-(void)callBackSocketData:(AsyncSocket *)socket socketData:(NDTDSocketCallbackData *)socketData;
//发送失败回调
-(void)didSocketSendFailure:(AsyncSocket *)socket socketData:(NDTDSocketCallbackData *)socketData;

@end
