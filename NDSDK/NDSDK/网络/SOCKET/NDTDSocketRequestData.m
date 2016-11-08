//
//  NDTDSocketRequestData.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/1/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDSocketRequestData.h"

@implementation NDTDSocketRequestData
@synthesize appChnid;

-(instancetype)init
{
    self = [super init];
    if (self) {
        appChnid = defaultAppChnids;
    }
    return self;
}

//快速生成请求对象，便于开发
+(NDTDSocketRequestData *)quicklyGenerateRequestData:(NSString *)moduleName requestDic:(NSMutableDictionary *)requestDic
{
    NDTDSocketRequestData *requestData = [[NDTDSocketRequestData alloc]init];
    requestData.moduleName = moduleName;
    requestData.requestDic = requestDic;
    return requestData;
}

@end
