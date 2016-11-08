//
//  NDTDHTTPCode.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/2/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  请将接口业务编号写在此处
 */


//网络数据库是否加密  1:加密  0:不加密
#define NetworkInterfaceEncryption 1

//请求类型
typedef enum
{
    RequestType = 0,     //接口请求（默认）
    UploadType = 1,      //上传请求
    DownloadType = 2     //下载请求
}InterfaceRequestType;

//缓存策略类型
typedef enum
{
    InterfaceDefaultNoCache = 0,     //默认不缓存
    InterfaceLatestCache = 1,        //网络请求失败时，读取缓存数据，返回给用户，如果网络请求成功则返回网络的数据给用户，期间用户是不能进行相关操作
    InterfacePersistentCacher = 2,    //只要有缓存数据，接口永远不会重新请求，一直读取缓存数据给用户。如果没有缓存则请求网络数据，并且加入缓存
    InterfaceAfterCacheFirstNetwork = 3 //先读取缓存数据返回给用户，在请求网络数据，成功时更新缓存，用户在更新页面。
    
}InterfaceCachingMechanism;

//网络提醒方式
typedef enum
{
    NetworksNotRemind =0,                     //网络加载操作都不提醒
    NetworkLoadRemind = 1,                    //网络加载提醒 (默认)
    NetworkOperationSuccessRemind = 2,        //网络操作成功提醒
    NetworkLoadOrOperationSuccessRemind = 3   //网络加载和操作都提醒
}NetworkRemindWay;

//请求失败是否自动提醒
typedef enum
{
    AutomaticRemind =0,             //自动提醒（默认）
    NotAutomaticRemind = 1          //不提醒
}RequestFailedRemind;


//数据模拟
typedef enum
{
    DataNotSimulation =0,                                //数据不模拟(默认)
    DataSimulationSuccessful = 1,                        //数据模拟成功时，不会请求接口，缓存策略为InterfaceDefaultNoCache
    DataSimulationFailure  = 2                           //数据模拟失败时，不会请求接口，缓存策略为InterfaceDefaultNoCache
}DataSimulation;


//文件类型
typedef enum
{
    ImageType = 0,                        //图片类型
    VoiceType = 1,                        //语音类型
    VideoType = 2                         //视频类型
}FileType;

//http请求方法类型
typedef enum
{
    POSTType= 0,                        //post请求(默认)
    GETType = 1,                        //get请求
}RequestMethodType;

