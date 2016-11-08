//
//  NDTDHTTPCallbackData.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/30/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/*
 类说明:
 1.服务端返回的数据
 2.请求的信息
 */


/**********************数据来源*****************************/

typedef enum
{
    SourceNetwork = 0,      //数据来源于网络
    SourceCache = 1,        //数据来源于缓存
    SourceMemory = 2,       //数据来源于内存
    SourceSimulation = 3    //数据来源于模拟数据
}DataSource;


#import <Foundation/Foundation.h>
#import "NDTDHTTPRequestData.h"

@interface NDTDHTTPCallbackData : NSObject

//成功时
@property(nonatomic)DataSource dataSource;                       //数据来源类型
@property(nonatomic)InterfaceCachingMechanism iCMType;           //缓存策略类型
@property(nonatomic,strong)NSMutableDictionary *dataDic;

//失败时
@property(nonatomic,strong)NSError *error;                       //错误指针
@property(nonatomic,copy)NSString *errorReason;                //错误原因

//公共
@property(nonatomic) NSInteger ID;
@property(nonatomic,copy)NSString *moduleName;                 //模块号
@property(nonatomic,strong)NDTDHTTPRequestData *requestData;
@property(nonatomic,assign)NSInteger httpCode;


@end
