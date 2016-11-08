//
//  NDTDSocketRequestData.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/1/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <Foundation/Foundation.h>

#define defaultAppChnids 1    //默认频道

@interface NDTDSocketRequestData : NSObject

@property (nonatomic,copy) NSString *moduleName;                     //模块标识(必传)
@property (nonatomic,strong) NSMutableDictionary *requestDic;        //请求参数
@property (nonatomic,assign) NSInteger appChnid;                     //应用频道，默认defaultAppChnids

//快速生成请求对象，便于开发
+(NDTDSocketRequestData *)quicklyGenerateRequestData:(NSString *)moduleName requestDic:(NSMutableDictionary *)requestDic;

@end