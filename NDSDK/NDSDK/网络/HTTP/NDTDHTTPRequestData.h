//
//  NDTDHTTPRequestData.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/*
 类说明:
 1.请求信息
 2.功能配置
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NDTDHTTPCode.h"

@interface NDTDHTTPRequestData : NSObject

@property(nonatomic,copy)NSString *moduleName;                     //模块标识(必传)
/******************选传字段**********************/

#pragma mark --请求相关
@property(nonatomic,strong) UIView *loadFatherView;                  //加载父视图，默认为nil
@property(nonatomic,assign) InterfaceRequestType requestType;        //请求类型:1.接口请求 2.上传 3.下载
@property(nonatomic,strong) NSMutableDictionary *requestDic;         //请求参数
@property(nonatomic,assign) InterfaceCachingMechanism iCMType;       //缓存策略类型,默认InterfaceDefaultNoCache
@property(nonatomic,assign) RequestMethodType requestMethodType;     //请求方法POST与GET，默认Post
@property(nonatomic,assign) BOOL isRequestLogin;                     //接口是否需要登录。yes:需要 no:不要  默认yes
@property(nonatomic,copy) NSString *url;                           //如果为空接口将采用默认的url，不为空接口将采用此url

#pragma mark --网络提醒相关
@property(nonatomic,assign) NetworkRemindWay networkRemindWay;            //提醒方式，默认NetworkLoadRemind
@property(nonatomic,copy) NSString *loadRemindString;                   //加载提醒文本，默认为：“正在努力加载...”
@property(nonatomic,copy) NSString *operationRemindString;              //操作提醒文本，默认为：“操作成功”
@property(nonatomic,assign) RequestFailedRemind requestFaileRemind;       //请求失败自动提醒配置，默认AutomaticRemind

#pragma mark --重定向相关
@property(nonatomic,assign) NSInteger redirectNumber;                     //重定向次数设置，默认不重定向。重定向次数不要超过3次，超过3次将强制设置成3;

#pragma mark --超时设置
@property(nonatomic) NSTimeInterval timeoutTime;                          //请求超时设置，默认25秒

#pragma mark --数据模拟
@property(nonatomic,assign)DataSimulation dataSimulation;                 //数据模拟设置，默认DataNotSimulation
@property(nonatomic,strong)NSMutableDictionary *simulationValue;          //将要模拟的数据值。模拟什么将原样返回

#pragma mark --如果是上传
@property(nonatomic,strong) NSData *attachmentData;                      //附件数据
@property(nonatomic,assign)FileType fileType;                            //文件类型：图片，语音，视频
@property(nonatomic,copy)NSString *fileFormat;                          //文件格式：jpg，mp4等

#pragma mark --其他
@property(nonatomic,strong)id other;                                      //例子：可以用来标识下啦刷新或加载更多


//快速生成请求对象，便于开发，其他字段均为默认值
+(NDTDHTTPRequestData *)quicklyGenerateRequestData:(NSString *)moduleName requestDic:(NSMutableDictionary *)requestDic;

@end
