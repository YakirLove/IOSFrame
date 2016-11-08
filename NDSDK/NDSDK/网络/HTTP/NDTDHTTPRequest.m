//
//  NDTDHTTPRequest.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDHTTPRequest.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "NDTDNetworkDataCache.h"
#import "NDTDNetworkMonitor.h"
#import "NDJson.h"
#import "NDTDLoadView.h"



@interface NDTDHTTPRequest()
{
    NDTDNetworkDataCache *dataCache;
    NDTDLoadView *loadView;
    float failureRemindHeight;
}

@end

@implementation NDTDHTTPRequest

static NDTDHTTPRequest *requestmanager;

+ (id)shareInstance
{
    @synchronized(self){
        if (!requestmanager) {
            requestmanager = [[NDTDHTTPRequest alloc] init];
        }
        return requestmanager;
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        urlString = @"";
        dataCache = [NDTDNetworkDataCache shareInstance];
        failureRemindHeight = FailureRemindDefaultHeight;
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)replaceCacheLibraryName:(NSString *)interfaceCacheName
{
    [dataCache setTableName:interfaceCacheName];
}

#pragma mark-
#pragma mark 数据模拟

//模拟接口请求成功
-(void)simulateRequestSuccessful:(NDTDHTTPRequestData *)requestData results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    NSMutableArray *simulateArray = [[NSMutableArray alloc]init];
    NDTDHTTPCallbackData *callBackData=[[NDTDHTTPCallbackData alloc]init];
    callBackData.dataSource=SourceSimulation;
    callBackData.dataDic=requestData.simulationValue;
    callBackData.iCMType = requestData.iCMType;
    callBackData.requestData = requestData;
    callBackData.moduleName = requestData.moduleName;
    
    [simulateArray addObject:callBackData];
    [simulateArray addObject:requestData];
    [simulateArray addObject:results];
    [self performSelector:@selector(perSimulateRequestSuccessful:) withObject:simulateArray afterDelay:simulateTimeValue];

}

-(void)perSimulateRequestSuccessful:(NSMutableArray *)simulateArray
{
    if (simulateArray.count>=3) {
        NDTDHTTPCallbackData *callBackData=[simulateArray objectAtIndex:0];
        void (^results)(NDTDHTTPCallbackData *callbackData) = [simulateArray objectAtIndex:2];
        results(callBackData);
    }
}


-(void)simulateRequestFailure:(NDTDHTTPRequestData *)requestData results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    NSMutableArray *simulateArray = [[NSMutableArray alloc]init];
    NDTDHTTPCallbackData *callBackData=[[NDTDHTTPCallbackData alloc]init];
    callBackData.dataDic=requestData.simulationValue;
    callBackData.dataSource=SourceSimulation;
    callBackData.error=nil;
    callBackData.errorReason=@"模拟网络数据失败";
    callBackData.iCMType = requestData.iCMType;
    callBackData.requestData = requestData;
    callBackData.moduleName = requestData.moduleName;
    [simulateArray addObject:callBackData];
    [simulateArray addObject:requestData];
    [simulateArray addObject:results];
    [self performSelector:@selector(perSimulateRequestFailure:) withObject:simulateArray afterDelay:simulateTimeValue];

}

-(void)perSimulateRequestFailure:(NSMutableArray *)simulateArray
{
    if (simulateArray.count>=3) {
        NDTDHTTPCallbackData *callBackData = [simulateArray objectAtIndex:0];
        void (^simResults)(NDTDHTTPCallbackData *callbackData) = [simulateArray objectAtIndex:2];
        simResults(callBackData);
//        if ([OMGToast isShowOMGToast]==YES) {
//            failureRemindHeight = failureRemindHeight+44;
//        }
        if (callBackData.requestData.requestFaileRemind == AutomaticRemind) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:callBackData.errorReason message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark --网络提醒

//加载网络提醒
-(void)networkProcessing:(NDTDHTTPRequestData *)requestData
{
    if (requestData !=nil && requestData.loadFatherView !=nil && loadView!=nil) {
        [loadView showLoadedView:requestData];
    }
}

//修改网络提醒
-(void)modifynetworkProcessing:(NDTDHTTPRequestData *)requestData
{
    if (requestData !=nil && requestData.loadFatherView !=nil && loadView!=nil) {
        [loadView showOperationView:requestData];
    }
}


//隐藏网络提醒
-(void)hiddenNetworkProcessing:(NDTDHTTPRequestData *)requestData
{
    if (requestData !=nil && requestData.loadFatherView !=nil && loadView!=nil) {
        [loadView hiddenLoadedView:requestData];
    }
}

//处理加载网络
-(void)showNetworkAlertProcessing:(NDTDHTTPRequestData *)requestData
{
    if (requestData.iCMType==InterfaceAfterCacheFirstNetwork) {
        [dataCache getNetworkData:requestData results:^(id callbackData) {
            if (callbackData==nil) {
                //这边网络加载视图
                [self networkProcessing:requestData];
            }
        }];
        
    }
    else
    {
        if (requestData.loadFatherView!=nil  && (requestData.networkRemindWay==NetworkLoadRemind || requestData.networkRemindWay==NetworkLoadOrOperationSuccessRemind)) {
            //这边网络加载视图
            [self networkProcessing:requestData];
        }
    }

}

//处理隐藏网络
-(void)hiddenNetworkAlertProcessing:(NDTDHTTPRequestData *)requestData isSuccessful:(BOOL)isSuccessful
{
    if (requestData.networkRemindWay==NetworkLoadRemind || requestData.networkRemindWay==NetworkLoadOrOperationSuccessRemind) {
        [self hiddenNetworkProcessing:requestData];  //隐藏网络提醒
        if (requestData.networkRemindWay==NetworkLoadOrOperationSuccessRemind){
            if (isSuccessful==YES) {
                [self modifynetworkProcessing:requestData];
            }
        }
    }
    else if (requestData.networkRemindWay==NetworkOperationSuccessRemind)
    {
        if (isSuccessful==YES) {
            [self modifynetworkProcessing:requestData];
        }
    }
    else
    {
        
    }

}

#pragma mark --请求

//发起请求
-(void)sendRequest:(NDTDHTTPRequestData *)requestData isLastRequest:(BOOL)isLastRequest results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    //请求缓存策略处理
    switch (requestData.iCMType) {
        case InterfaceDefaultNoCache :
        {
            [self requestData:requestData isLastRequest:isLastRequest results:results isReconnect:NO];
            break;
        }
        case InterfaceLatestCache :
        {
            [self requestData:requestData isLastRequest:isLastRequest results:results isReconnect:NO];
            break;
        }
        case InterfacePersistentCacher:
        {
            static BOOL isNil=YES;
            [dataCache getNetworkData:requestData results:^(id callbackData) {
                if (callbackData==nil) {
                    isNil=NO;
                    [self requestData:requestData isLastRequest:isLastRequest results:results isReconnect:NO];
                }
                else
                {
                    isNil=YES;
                    results(callbackData);
                }
                
            }];
            break;
        }
        case InterfaceAfterCacheFirstNetwork:
        {
            [dataCache getNetworkData:requestData results:^(id callbackData) {
                if (callbackData!=nil) {
                    results(callbackData);
                }
                else
                {
                    [self hiddenNetworkAlertProcessing:requestData isSuccessful:NO];
                }
            }];
            [self requestData:requestData isLastRequest:isLastRequest results:results isReconnect:NO];
            break;
        }
        default:
            break;
    }

}

-(void)startSingleSendRequest:(NDTDHTTPRequestData *)requestData results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    failureRemindHeight = FailureRemindDefaultHeight;
    if (requestData.loadFatherView!=nil) {
        if (loadView!=nil) {
            [loadView removeView];
            loadView = nil;
        }
        loadView = [[NDTDLoadView alloc]init:requestData.loadFatherView];
    }
    [self showNetworkAlertProcessing:requestData];
    [self sendRequest:requestData isLastRequest:YES results:^(NDTDHTTPCallbackData *callbackData) {
        @try {
            results(callbackData);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        BOOL isSuccessful = YES;
        if (callbackData.error !=nil) {
            isSuccessful = NO;
        }
        //这边添加网络隐藏处理
        [self hiddenNetworkAlertProcessing:requestData isSuccessful:isSuccessful];
    }];
}

-(void)multipleSendRequest:(NSMutableArray *)requestArray isRely:(BOOL)isRely results:(void (^)(NDTDHTTPRequestData *nextRequestData,NDTDHTTPCallbackData *callbackData))results
{
    if (requestArray.count>0) {
        if (isRely==YES) {
            NDTDHTTPRequestData *requestData = [requestArray objectAtIndex:0];
            [self showNetworkAlertProcessing:requestData];
            BOOL isLastRequest = NO;
            if (requestArray.count==1) {
                isLastRequest = YES;
            }
            [self sendRequest:requestData isLastRequest:isLastRequest results:^(NDTDHTTPCallbackData *callbackData) {
                
                //这边进行判断，如果是缓存返回的数据，则不处理下个请求
                if ((callbackData.dataSource == SourceCache  ||  callbackData.dataSource == SourceMemory) && callbackData.iCMType == InterfaceAfterCacheFirstNetwork) {
                    if (requestArray.count>1) {
                        results([requestArray objectAtIndex:1],callbackData);
                    }
                    else
                    {
                        results(nil,callbackData);
                    }
                }
                else
                {
                    [requestArray removeObjectAtIndex:0];
                    if (requestArray.count==0) {
                        
                        results(nil,callbackData);
                        //这边添加网络隐藏处理
                        [self hiddenNetworkAlertProcessing:requestData isSuccessful:YES];
                    }
                    else
                    {
                        if (requestData.networkRemindWay == NetworkLoadOrOperationSuccessRemind || requestData.networkRemindWay == NetworkOperationSuccessRemind) {
                            
                            [self modifynetworkProcessing:requestData];
                        }
                        NDTDHTTPRequestData *nextRequestData = [requestArray objectAtIndex:0];
                        results(nextRequestData,callbackData);
                        [self multipleSendRequest:requestArray isRely:isRely results:results];
                    }

                }
            }];
            
        }
        else
        {
            for (int i=0; i<requestArray.count; i++) {
                NDTDHTTPRequestData *requestData = [requestArray objectAtIndex:i];
                if (i==0) {
                    requestData.loadRemindString = @"正在努力加载...";
                    [self showNetworkAlertProcessing:requestData];
                }
                [self sendRequest:[requestArray objectAtIndex:i] isLastRequest:YES results:^(NDTDHTTPCallbackData *callbackData) {
                    results(nil,callbackData);
                    if (i==requestArray.count-1) {
                        //这边添加网络隐藏处理
                        [self hiddenNetworkAlertProcessing:[requestArray objectAtIndex:i] isSuccessful:YES];
                    }
                }];
            }
        }
    }

}

-(void)startMultipleSendRequest:(NSMutableArray *)requestArray isRely:(BOOL)isRely results:(void (^)(NDTDHTTPRequestData *nextRequestData,NDTDHTTPCallbackData *callbackData))results
{
    failureRemindHeight = FailureRemindDefaultHeight;
    //遍历取出有加载视图的请求
    NDTDHTTPRequestData *newRequestData=nil;
    for (int i=0; i<requestArray.count; i++) {
        NDTDHTTPRequestData *requestData = [requestArray objectAtIndex:i];
        if (requestData.loadFatherView!=nil) {
            newRequestData = requestData;
            break;
        }
    }
    //所有的加载视图统一成一个
    for (int j=0; j<requestArray.count; j++) {
        NDTDHTTPRequestData *requestData = [requestArray objectAtIndex:j];
        requestData.loadFatherView = newRequestData.loadFatherView;
    }
    
    if (newRequestData!=nil) {
        if (loadView!=nil) {
            [loadView removeView];
            loadView = nil;
        }
        loadView = [[NDTDLoadView alloc]init:newRequestData.loadFatherView];
    }
    //[self showNetworkAlertProcessing:newRequestData];
    [self multipleSendRequest:requestArray isRely:isRely results:results];
}

-(void)requestData:(NDTDHTTPRequestData *)requestData
     isLastRequest:(BOOL)isLastRequest
           results:(void (^)(NDTDHTTPCallbackData *callbackData))results
       isReconnect:(BOOL)isReconnect
{
    //如果是接口模拟则不请求网络数据
    if (requestData.dataSimulation==DataSimulationSuccessful) {
        [self simulateRequestSuccessful:requestData results:results];
        return;
    }
    else if (requestData.dataSimulation==DataSimulationFailure)
    {
        [self simulateRequestFailure:requestData results:results];
        return;
    }
    //网络环境监测
    NDTDNetworkMonitor *monitor=[NDTDNetworkMonitor shareInstance];
    if (monitor.status ==NDTDNetworkReachabilityStatusNotReachable ) {
        //没有网络时给予提醒，并且隐藏网络加载视图
        [self hiddenNetworkAlertProcessing:requestData isSuccessful:NO];
        NSError *error = [[NSError alloc]init];
        NDTDHTTPCallbackData *callbackData = [self parsingCallbackData:nil  requestData:requestData error:error];
        callbackData.errorReason = @"网络未连接";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请检查网络是否连接" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        results(callbackData);
        return;
    }
    if (requestData.redirectNumber>3) {
        requestData.redirectNumber=3;
    }
    if (requestData.requestType == RequestType)
    {
        AFHTTPSessionManager *manager = [self configurationHttpHeaderHTTPBody:requestData];
        NSString *url = @"";
        if([urlString isEqualToString:@""])
        {
            url = requestData.url;
        }
        else
        {
            url = urlString;
        }
        // 设置返回格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if (requestData.requestMethodType == POSTType) {
            [manager POST:url parameters:requestData.requestDic success:^(NSURLSessionDataTask *operation, id responseObject) {
                [self successfullyProcessed:operation
                                requestData:requestData
                             responseObject:responseObject
                                    results:results];
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [self failureProcessed:operation
                           requestData:requestData
                                 error:error
                               results:results];
            }];
            
        }
        else
        {
            [manager GET:url  parameters:requestData.requestDic success:^(NSURLSessionDataTask *operation, id responseObject) {
                [self successfullyProcessed:operation
                                requestData:requestData
                             responseObject:responseObject
                                    results:results];
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [self failureProcessed:operation
                           requestData:requestData
                                 error:error
                               results:results];
            }];
        }
    }
    else
    {
        
    }
}


//成功处理
-(void)successfullyProcessed:(NSURLSessionDataTask *)operation
                 requestData:(NDTDHTTPRequestData *)requestData
              responseObject:(id)responseObject
                     results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    NDTDHTTPCallbackData *callbackData = [self parsingCallbackData:responseObject requestData:requestData error:nil];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)operation.response;
    callbackData.httpCode = httpResponse.statusCode;
    if (callbackData.errorReason !=nil && callbackData.error !=nil) {
//        if ([OMGToast isShowOMGToast]==YES) {
//            failureRemindHeight = failureRemindHeight+44;
//        }
        if (requestData.requestFaileRemind == AutomaticRemind) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:callbackData.errorReason message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//            [OMGToast showWithText:callbackData.errorReason bottomOffset:failureRemindHeight];
        }
    }
    else
    {
        //这边进行缓存处理
        [self requestSuccessfulCacheHandling:callbackData requestData:requestData];
        
    }
//    [self httpFlowCalculation:callbackData operation:operation responseObject:responseObject error:nil];
    [self returnResultsDeal:requestData callbackData:callbackData results:results];
}


-(void)failureProcessed:(NSURLSessionDataTask *)operation
            requestData:(NDTDHTTPRequestData *)requestData
                  error:(NSError *)error
                results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    if (requestData.redirectNumber>0) {
        requestData.redirectNumber = requestData.redirectNumber-1;
        [self requestData:requestData isLastRequest:YES results:results isReconnect:YES];
    }
    else
    {
        NDTDHTTPCallbackData *callbackData = [self parsingCallbackData:nil  requestData:requestData error:error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)operation.response;
        callbackData.httpCode = httpResponse.statusCode;
        if (callbackData.errorReason !=nil) {
//            if ([OMGToast isShowOMGToast]==YES) {
//                failureRemindHeight = failureRemindHeight+44;
//            }
            if (requestData.requestFaileRemind == AutomaticRemind) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:callbackData.errorReason message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
//                [OMGToast showWithText:callbackData.errorReason bottomOffset:failureRemindHeight];
            }
        }
//        [self httpFlowCalculation:callbackData operation:operation responseObject:nil error:error];
        [self returnResultsDeal:requestData callbackData:callbackData results:results];
    }
}

-(void)returnResultsDeal:(NDTDHTTPRequestData *)requestData callbackData:(NDTDHTTPCallbackData *)newCallbackData results:(void (^)(NDTDHTTPCallbackData *callbackData))results
{
    if (requestData.iCMType == InterfaceLatestCache) {
        if (newCallbackData.error !=nil) {
            [dataCache getNetworkData:requestData results:^(id callbackData) {
                if (callbackData == nil) {
                    results(newCallbackData);
                }
                else
                {
                    results(callbackData);
                }
            }];
        }
        else
        {
            results(newCallbackData);
        }
    }
    else
    {
        results(newCallbackData);
    }
}

/*
 //打印服务端返回的http头http码
 // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)operation.response;
 if ([operation.response respondsToSelector:@selector(allHeaderFields)]) {
 NSDictionary *dictionary = [httpResponse allHeaderFields];
 NSLog(@"%@",dictionary);                      //服务端给的头信息
 NSLog(@"%ld",(long)httpResponse.statusCode);  //http码
 
 }
 
 //打印自己的http头和body的数据
 NSLog(@"self.request.allHTTPHeaderFields=%@",operation.request.allHTTPHeaderFields);
 NSLog(@"self.request.HTTPBody=%@",operation.request.HTTPBody);
 NSString * bodyString = [[NSString alloc]initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
 NSLog(@"bodyString=%@",bodyString);
 */


-(id)configurationHttpHeaderHTTPBody:(NDTDHTTPRequestData *)requestData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //超时的时间
    manager.requestSerializer.timeoutInterval = requestData.timeoutTime;
    //进入后台时持续请求
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"SIGNATURE"];
    [manager.requestSerializer setValue:requestData.moduleName forHTTPHeaderField:@"ACTION"];
    urlString = requestData.url;
    return manager;
}

-(NDTDHTTPCallbackData *)parsingCallbackData:(id)responseObject requestData:(NDTDHTTPRequestData *)requestData error:(NSError *)error
{
    NDTDHTTPCallbackData *callBackData=[[NDTDHTTPCallbackData alloc]init];
    callBackData.dataSource=SourceNetwork;
    callBackData.iCMType = requestData.iCMType;
    callBackData.requestData = requestData;
    callBackData.moduleName = requestData.moduleName;
    if (error==nil ) {
        NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        
//        [result stringByReplacingOccurrencesOfString:@" " withString:@" "];//把一个显示成空格的特殊字符转成空格
        
        NSDictionary * dic=[result JSONValue];
        if (dic!=nil) {
            callBackData.dataDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
            NSString *codeString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if(codeString!=nil && ![codeString isEqualToString:@"(null)"] && ![codeString isKindOfClass:[NSNull class]])
            {
                int codeint=[codeString intValue];
                //不同的code可能意义不通，请自行处理
                if (codeint==0) {
                    return callBackData;
                }
                else
                {
                    NSString *errorReason = [dic objectForKey:@"message"];
                    callBackData.errorReason = errorReason;
                    return callBackData;
                }
            }
        }
        else
        {
            NSString *errorReason = @"数据异常";
            callBackData.errorReason = errorReason;
            callBackData.dataDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [callBackData.dataDic setValue:@"-1" forKey:@"code"];
            [callBackData.dataDic setValue:errorReason forKey:@"message"];
            
            return callBackData;
        }
        
    }
    else
    {
        NSString *errorReason = @"服务器连接失败";
        callBackData.errorReason = errorReason;
        callBackData.error = error;
    }
 
    return callBackData;
}

#pragma mark --缓存策略
//数据请求成功缓存策略处理
-(void)requestSuccessfulCacheHandling:(NDTDHTTPCallbackData *)callbackData requestData:(NDTDHTTPRequestData *)requestData
{
    switch (requestData.iCMType) {
        case InterfaceDefaultNoCache :
        {
            break;
        }
        case InterfaceLatestCache :
        {
            [dataCache saveNetworkData:requestData callbackData:callbackData results:^(BOOL isSuccessful) {
                
            }];
            break;
        }
        case InterfacePersistentCacher:
        {
            [dataCache saveNetworkData:requestData callbackData:callbackData results:^(BOOL isSuccessful) {
                
            }];
            break;
        }
        case InterfaceAfterCacheFirstNetwork:
        {
            [dataCache saveNetworkData:requestData callbackData:callbackData results:^(BOOL isSuccessful) {
                
            }];
            break;
        }
        default:
            break;
    }

}

//#pragma mark --流量计算
//-(void)httpFlowCalculation:(NDTDHTTPCallbackData *)callbackData
//                 operation:(AFHTTPRequestOperation *)operation
//            responseObject:(id)responseObject error:(NSError *)error
//{
//    NDTDNetworkMonitor *monitor = [NDTDNetworkMonitor shareInstance];
//    if (callbackData.dataSource == SourceNetwork && monitor.status != NDTDNetworkReachabilityStatusNotReachable) {
//        long long int flow=0;
//        //获取服务端信息,注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)operation.response;
//        if ([operation.response respondsToSelector:@selector(allHeaderFields)]) {
//            NSDictionary *dictionary = [httpResponse allHeaderFields];
//            NSString *httpHeaderString = [dictionary JSONRepresentation];
//            NSData* httpHeaderData = [httpHeaderString dataUsingEncoding:NSUTF8StringEncoding];
//            flow=httpHeaderData.length+flow;
//        }
//        //服务端返回的body数据
//        if (responseObject!=nil) {
//            if ([responseObject isMemberOfClass:[NSData class]]) {
//                NSData *httpBodyData = (NSData *)responseObject;
//                flow=httpBodyData.length+flow;
//            }
//            else if ([responseObject isMemberOfClass:[NSString class]])
//            {
//                NSData* httpBodyData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
//                flow = httpBodyData.length+flow;
//            }
//        }
//        
//        //自己的请求头
//        if ([operation.request respondsToSelector:@selector(setAllHTTPHeaderFields:)]) {
//            NSString *httpRequestHeaderString = [operation.request.allHTTPHeaderFields JSONRepresentation];
//            NSData *httpRequestHeaderData = [httpRequestHeaderString dataUsingEncoding:NSUTF8StringEncoding];
//            flow = httpRequestHeaderData.length +flow;
//        }
//        
//        //自己的请求包体
//        NSString *requestString = @"{}";
//        if (callbackData.requestData.requestDic!=nil) {
//            requestString = [callbackData.requestData.requestDic JSONRepresentation];
//            NSData *requestBodyData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
//            flow = requestBodyData.length+flow;
//        }
//        if (monitor.status == NDTDNetworkReachabilityStatusReachableViaWWAN) {
//            monitor.currentApplicationMobileFlow = flow+monitor.currentApplicationMobileFlow;
//        }
//        else
//        {
//            monitor.currentApplicationWifiFlow = flow+monitor.currentApplicationWifiFlow;
//        }
//
//    }
//
//}

@end
