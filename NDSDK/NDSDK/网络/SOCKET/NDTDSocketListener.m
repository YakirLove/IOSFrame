//
//  NDTDSocketListener.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 8/31/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDSocketListener.h"
#import "AsyncSocket.h"
#import "NDJson.h"
#import "NDTDSocketCallbackData.h"

@interface NDTDSocketListener ()
{
    AsyncSocket *socket;
    NSMutableData *continueData;
    NSInteger tagIndex;
    NSString *_hostIP;
    UInt16 _port;
    NSMutableArray *delegateArray;
    //重连次数
    NSInteger reconnectionNumber;
    //心跳计时器
    NSTimer *heartbeatTime;
}

@end

@implementation NDTDSocketListener
@synthesize isConnection;

static  NDTDSocketListener *_socketManager;

+ (NDTDSocketListener *)shareInstance
{
    @synchronized(self){
        if (!_socketManager) {
            _socketManager = [[NDTDSocketListener alloc] init];
        }
        return _socketManager;
    }
}

-(id)init
{
    self=[super init];
    if (self) {
        delegateArray=[[NSMutableArray alloc]init];
        continueData=[[NSMutableData alloc]init];
        isConnection=NO;
        _hostIP = @"";
        _port = 0;
        tagIndex = 0;
        reconnectionNumber=0;
    }
    return self;
}

- (void)addDelegate:(id<NDTDSocketDelegate>)delegate
{
    if (delegate!=nil) {
        if ([delegateArray containsObject:delegate]==NO) {
            [delegateArray addObject:delegate];
        }
    }
}

- (void)removeDelegate:(id<NDTDSocketDelegate>)delegate
{
    if (delegate!=nil) {
        if ([delegateArray containsObject:delegate]==YES) {
            [delegateArray removeObject:delegate];
        }
    }
}

-(BOOL)connectionSocket:(NSString *)hostIP port:(UInt16)port
{
    if (hostIP==nil || [hostIP isEqualToString:@""]) {
        return NO;
    }
    _hostIP = hostIP;
    _port = port;
    if (socket==nil) {
        socket = [[AsyncSocket alloc] initWithDelegate: self];
    }
    else
    {
        if (socket.isConnected==YES) {
            return YES;
        }
        
    }
    
    NSError *error;
    isConnection = [socket connectToHost:hostIP onPort:port error: &error];
    if (isConnection==NO) {
        //socket连接失败
        for (int i=0; i<delegateArray.count; i++) {
            id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
            if ([delegate respondsToSelector:@selector(didSocketConnectionFailure:error:)]) {
                [delegate didSocketConnectionFailure:socket error:error];
            }
        }
        return NO;
    }
    else
    {
        [socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        return YES;
        
    }
}

// 断开socket连接
-(void)cutOffSocket
{
    NSLog(@"socket断开连接");
    [self disconnectSocket:SocketOfflineByUser];
}

-(void)disconnectSocket:(SocketCutOffState )socketCutOffState
{
    socket.userData = socketCutOffState;
    [socket disconnect];
    isConnection=NO;
    socket.delegate=nil;
    socket=nil;
    [heartbeatTime invalidate];
    heartbeatTime=nil;
}

//心跳处理
-(void)heartbeatSocket
{
    [self sendSocketData:[NDTDSocketRequestData quicklyGenerateRequestData:sCode_1_5 requestDic:nil]];
}

//发送数据
-(BOOL)sendSocketData:(NDTDSocketRequestData *)requestData;
{
    NSData *data = [NDTDSocketListener override_combiningData:requestData];
    if (data==nil || data.length==0 || isConnection==NO) {
        for (int i=0; i<delegateArray.count; i++) {
            id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
            if ([delegate respondsToSelector:@selector(didSocketSendFailure:socketData:)]) {
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:requestData.requestDic];
                NDTDSocketCallbackData *sendData = [[NDTDSocketCallbackData alloc]init];
                sendData.dataDic = dataDic;
                if (isConnection==NO) {
                    sendData.errorReason = @"请检查网络是否连接";
                    
                }
                else
                {
                    sendData.errorReason = @"组合数据异常";
                }
                sendData.moduleName = requestData.moduleName;
                [delegate didSocketSendFailure:socket socketData:sendData];
            }
        }
        return NO;
    }
    else
    {
        [socket writeData:data withTimeout: -1 tag:0];
        return YES;
    }
}

#pragma mark --socketDelegate
//当socket连接正准备读和写的时候调用，host属性是一个IP地址，而不是一个DNS 名称
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (heartbeatTime==nil) {
        heartbeatTime = [NSTimer scheduledTimerWithTimeInterval:HeartbeaTime target:self selector:@selector(heartbeatSocket) userInfo:nil repeats:YES];
    }
    reconnectionNumber=0;
    [sock readDataWithTimeout: -1 tag:0];
    for (int i=0; i<delegateArray.count; i++) {
        id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
        if ([delegate respondsToSelector:@selector(didSocketConnectionSuccessful:)]) {
            [delegate didSocketConnectionSuccessful:sock];
        }
    }
}

// 当一个socket已完成请求数据的写入时候调用
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout: -1 tag: tag];
}

// 这里必须要使用流式数据
//当socket已完成所要求的数据读入内存时调用，如果有错误则不调用
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //注意这边data数据有可能会含有多个包
    if (continueData.length>0) {
        [continueData appendData:data];
        [self dataParsing:continueData];
    }
    else
    {
        [self dataParsing:data];
    }
    [sock readDataWithTimeout: -1 tag: tag];
}

//当socket由于或没有错误而断开连接，如果你想要在断开连接后release socket，在此方法工作，而在onSocket:willDisconnectWithError 释放则不安全
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    isConnection = NO;
    if (sock.userData == SocketOfflineByServer) {
        //服务器掉线，重连3次
        if (reconnectionNumber<3) {
            [self connectionSocket:_hostIP port:_port];
        }
        else
        {
            for (int i=0; i<delegateArray.count; i++) {
                id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
                if ([delegate respondsToSelector:@selector(didSocketCutOff:)]) {
                    [delegate didSocketCutOff:SocketOfflineByServer];
                }
            }
            [self disconnectSocket:SocketOfflineByServer];
        }
        reconnectionNumber=reconnectionNumber+1;
    }
    else if (sock.userData == SocketOfflineByUser) {
        //如果由用户断开，不进行重连
        for (int i=0; i<delegateArray.count; i++) {
            id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
            if ([delegate respondsToSelector:@selector(didSocketCutOff:)]) {
                [delegate didSocketCutOff:SocketOfflineByUser];
            }
        }
    }
    else
    {
        
    }
    
}


-(void)dataParsing:(NSData *)data
{
    ParsType parsType;
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    NSData *residueData=nil;
    parsType=[NDTDSocketListener override_parsingData:data packetDic:dataDic residueData:residueData];
    if (parsType==parsComplete) {
        [self emptyContinueData];
        NSString *moduleName=[dataDic objectForKey:@"moduleName"];
        if ([moduleName isEqualToString:sCode_1_5]) {
            //如果是心跳，则什么都不做处理
            return;
        }
        else
        {
            NSInteger code=[[dataDic objectForKey:@"code"] intValue];
            if (code==0) {
                //发送成功
                NDTDSocketCallbackData *socketData=[[NDTDSocketCallbackData alloc]init];
                socketData.moduleName=moduleName;
                socketData.dataDic=[dataDic objectForKey:@"packdata"];
                for (int i=0; i<delegateArray.count; i++) {
                    id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
                    if ([delegate respondsToSelector:@selector(callBackSocketData:socketData:)]) {
                        [delegate callBackSocketData:socket socketData:socketData];
                    }
                }
            }
            else
            {
                NDTDSocketCallbackData *socketData=[[NDTDSocketCallbackData alloc]init];
                socketData.moduleName=moduleName;
                socketData.errorReason=[[dataDic objectForKey:@"packdata"] objectForKey:@"error"];
                socketData.dataDic=[dataDic objectForKey:@"packdata"];
                for (int i=0; i<delegateArray.count; i++) {
                    id<NDTDSocketDelegate>delegate=[delegateArray objectAtIndex:i];
                    if ([delegate respondsToSelector:@selector(didSocketSendFailure:socketData:)]) {
                        [delegate didSocketSendFailure:socket socketData:socketData];
                    }
                }
                
            }
        }
    }
}

//清空
-(void)emptyContinueData
{
    if (continueData.length>0) {
        [continueData resetBytesInRange:NSMakeRange(0, [continueData length])];
        [continueData setLength:0];
    }
}

+ (NSData *)override_combiningData:(NDTDSocketRequestData *)requestData
{
    //解析业务编号
    NSArray *moduleArray=(NSArray *)[requestData.moduleName componentsSeparatedByString:@"-"];
    if (moduleArray.count<2) {
        return nil;
    }
    int headLength = 8;    //包头固定8个长度
    NSString *requestJson=[requestData.requestDic JSONRepresentation];
    NSData *data=[requestJson dataUsingEncoding:NSUTF8StringEncoding];
    const int nmlen=(int)data.length;
    int nsize   = headLength + nmlen+ 1;
    short sint  = 0;
    char *sztmp = NULL;
    char *szptr = (char *)malloc(nsize);  //申请一个大小为协议包头＋业务参数大小的空间
    if(szptr == NULL) {
        return nil;
    }
    memset(szptr, 0x00, nsize);           //清空野内存
    //填补协议头信息
    szptr[0] = [[moduleArray objectAtIndex:0] intValue];  //业务编号
    szptr[1] = [[moduleArray objectAtIndex:1] intValue];  //接口编号
    sint  = htons(requestData.appChnid);
    memcpy(szptr+2, &sint, 2);   //应用频道
    nsize = htonl(nmlen);        //msg数据长度
    memcpy(szptr+4, &nsize, 4);
    const char * msgChar =[requestJson UTF8String];
    if(nmlen > 0) {
        memcpy(szptr+headLength, msgChar, nmlen);    //szptr的值将是 head+msg的值
        sztmp = szptr + headLength;                  //计算msg内存的起始位置，也就是msg
        im_crypt(szptr, sztmp, nmlen,headLength);    //sztmp是msg内存的起始位置
    }
    NSData *allData = [[NSData alloc] initWithBytes:szptr length:nmlen+headLength];
    free(szptr);
    return allData;
}

+(ParsType )override_parsingData:(NSData*)data packetDic:(NSMutableDictionary *)packetDic residueData:(NSData *)residueData
{
    ParsType parsType=parsComplete;
    if (data.length<8) {
        parsType=parsFailure;
        return parsType;
    }
    int headLength = 8;  //包头固定长度8
    NSUInteger count=data.length;
    NSUInteger index=0;
    //解析业务编号
    Byte buziCode[1];
    [data getBytes:buziCode range:NSMakeRange(index, 1)];
    index=index+1;
    //解析接口编号
    Byte portCode[1];
    [data getBytes:portCode range:NSMakeRange(index, 1)];
    index=index+1;
    //解析code
    Byte code[2];
    [data getBytes:code range:NSMakeRange(index, 2)];
    short codeShort=0;
    memcpy(&codeShort, code, 2);
    codeShort  = ntohs(codeShort);
    index=index+2;
    //读取包体长度
    Byte packsize[4];
    [data getBytes:packsize range:NSMakeRange(index, 4)];
    int packSzieInt=0;
    memcpy(&packSzieInt, packsize, 4);
    packSzieInt=ntohl(packSzieInt);
    index=index+4;
    index=index+packSzieInt;
    //组合数据包
    [packetDic setValue:[NSString stringWithFormat:@"%d-%d",buziCode[0],portCode[0]] forKey:@"moduleName"];
    [packetDic setValue:[NSString stringWithFormat:@"%d",packSzieInt] forKey:@"packsize"];
    [packetDic setValue:[NSString stringWithFormat:@"%d",codeShort] forKey:@"code"];
    if (packSzieInt<=0) {
        //没有包体
        parsType=parsFailure;
        return parsType;
    }
    else if (count-headLength<packSzieInt)
    {
        parsType=parsContinue;
        return parsType;
    }
    else if (count==packSzieInt+headLength)
    {
        parsType=parsComplete;
    }
    else if (count>packSzieInt+headLength)
    {
        parsType=parsMultiple;
    }
    else
    {
        
    }
    /*****读取后续包体
     1.首先读取前8位
     2.在读取8位后面的消息体
     3.头与消息体进行异或操作解密
     4.转码
     */
    
    //首先读取前8位
    char *allChar=(char *)[data bytes];
    char *headChar=NULL;
    headChar=(char *)malloc(headLength+1);
    memset(headChar, 0x00, headLength+1);
    memcpy(headChar, allChar, headLength);
    
    //在读取8位后面的消息体
    char *packChar=allChar+headLength;
    //头与消息体进行异或操作解密
    im_crypt(headChar, packChar, packSzieInt,headLength);
    //转码
    NSString *packString=[NSString stringWithUTF8String:packChar];
    //将packdata组合起来
    NSDictionary *dataDic=[packString JSONValue];
    if (dataDic!=nil) {
        [packetDic setValue:dataDic forKey:@"packdata"];
    }
    else
    {
        dataDic=[[NSDictionary alloc]initWithObjectsAndKeys:packString,@"prompt",nil];
        [packetDic setValue:dataDic forKey:@"packdata"];
    }
    free(headChar);
    return parsType;
}

//异或加密
static void im_crypt(const char *szpro, char *pkdata, int nlen,int headLength) {
    int i = 0;
    if(nlen > 0) {
        for(i = 0; i < nlen; i++) {
            pkdata[i] ^= szpro[i%headLength];
        }
    }
}

@end
