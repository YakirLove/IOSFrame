//
//  NDTDHTTPRequestData.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDHTTPRequestData.h"

@implementation NDTDHTTPRequestData

-(id)init
{
    self=[super init];
    if (self) {
        self.moduleName=@"";
        self.iCMType=InterfaceDefaultNoCache;
        self.isRequestLogin=YES;
        self.networkRemindWay=NetworkLoadRemind;
        self.loadRemindString=@"正在努力加载...";
        self.operationRemindString=@"操作成功";
        self.requestFaileRemind=AutomaticRemind;
        self.redirectNumber=0;
        self.timeoutTime=25;
        self.requestType=RequestType;
        self.requestMethodType = POSTType;
        self.dataSimulation=DataNotSimulation;
        self.simulationValue=nil;
        self.other=nil;
        
    }
    return self;
}


//快速生成请求对象，便于开发。
+(NDTDHTTPRequestData *)quicklyGenerateRequestData:(NSString *)moduleName requestDic:(NSMutableDictionary *)requestDic
{
    NDTDHTTPRequestData * requestData=[[NDTDHTTPRequestData alloc]init];
    requestData.moduleName=moduleName;
    requestData.requestDic=requestDic;
    return requestData;
}


@end
