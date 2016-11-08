//
//  NDTDNetworkDataCache.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 6/29/15.
//  Copyright (c) 2015 林. All rights reserved.
//
#import "NDTDNetworkDataCache.h"
#import "FMDB.h"
#import "NDJson.h"
#import "NDTDHTTPCode.h"

//请求类型
typedef enum
{
    HTTPType = 0,        //Http类型
    SOCKETType = 1       //Socket类型
}SaveNetworkDataType;

#define dbEncryptionKey @"#a$H@23&*％52"

//扩展FMDatabaseQueue,目的给FMDatabaseQueue增加加密方法
@interface FMDatabaseQueue (Category)
{
    
}

@end

@implementation FMDatabaseQueue (Category)

-(void)setKet:(NSString *)ket
{
    [_db setKey:ket];
}

@end

@interface NDTDNetworkDataCache()
{
    FMDatabaseQueue *queue;
    NSString *networkDataCachetableName;
}

@end

@implementation NDTDNetworkDataCache

static  NDTDNetworkDataCache *_networkDataCache;

+ (NDTDNetworkDataCache *)shareInstance
{
    @synchronized(self){
        if (!_networkDataCache) {
            _networkDataCache = [[NDTDNetworkDataCache alloc] init];
        }
        return _networkDataCache;
    }

}

-(id)init
{
    self = [super init];
    if (self) {
        networkDataCachetableName=defaultTableName;
        [self initQueue];
    }
    return self;
}

+ (NSString *)getDocumentPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//当前时间转化为时间戳
+(NSString *)currentTimeTimestamp
{
    NSDate *currentTime = [NSDate date];             //获取系统当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[currentTime timeIntervalSince1970]];
    return timeSp;
}

//打开库
- (void)initQueue{

    NSString *documentDirectory = [NDTDNetworkDataCache getDocumentPath];
    NSString *cacheString=[NSString stringWithFormat:@"%@.sqlite",networkDataCacheDbName];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:cacheString];
    NSLog(@"dbPath%@",dbPath);
    if (queue==nil) {
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    //数据库加密
    if (NetworkInterfaceEncryption==1) {
        [queue setKet:dbEncryptionKey];
    }
    [self setTableName:networkDataCachetableName];
 }

-(void)setTableName:(NSString *)tableName
{
    networkDataCachetableName = tableName;
    [self createTable:tableName];
}

//首先判断表有没存在，不存在则创建
-(BOOL)createTable: (NSString *)tableName{
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //if ([db open]==YES) {
            NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(*) as c FROM sqlite_master where type='table' and name='%@'",tableName];
            FMResultSet * rs =[db executeQuery:sql];
            int count = 0;
            while ([rs next]){
                count = [[rs stringForColumn:@"c"] intValue];
            }
            if (count==0) {
                //创建表
                BOOL isTable=[db executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(ID INTEGER PRIMARY KEY AUTOINCREMENT,moduleName text,data text,requestDic text,networkType int,stime text)",tableName]];
                //建立索引
                BOOL isIndex1=[db executeUpdate:[NSString stringWithFormat:@"create index request_moduleName_index_%@ on %@(moduleName)",tableName,tableName]];
                BOOL isIndex2=[db executeUpdate:[NSString stringWithFormat:@"create index request_requestDic_index_%@ on %@(requestDic)",tableName,tableName]];
                BOOL isIndex3=[db executeUpdate:[NSString stringWithFormat:@"create index request_ID_index_%@ on %@(ID)",tableName,tableName]];
                
                NSLog(@"%d%d%d%d",isTable,isIndex1,isIndex2,isIndex3);
                
            }
    }];
    
    return YES;
}

-(void)saveNetworkData:(id)requestData callbackData:(id)callbackData results:(void (^)(BOOL isSuccessful))results
{
    SaveNetworkDataType networkType = HTTPType;
    if ([callbackData isMemberOfClass:[NDTDHTTPCallbackData class]]) {
        networkType = HTTPType;
        NDTDHTTPCallbackData *newCallbackData = (NDTDHTTPCallbackData *)callbackData;
        NDTDHTTPRequestData *newRequestData = (NDTDHTTPRequestData *)requestData;
        [self setDataCacheToDatabase:[newCallbackData.dataDic JSONRepresentation] requestDic:newRequestData.requestDic moduleName:newRequestData.moduleName networkType:networkType results:results];
    }
    else
    {
        networkType = SOCKETType;
        NDTDSocketCallbackData *newCallbackData = (NDTDSocketCallbackData *)callbackData;
        [self setDataCacheToDatabase:[newCallbackData.dataDic JSONRepresentation] requestDic:nil moduleName:newCallbackData.moduleName networkType:networkType results:results];
    }
}

//数据缓存到数据库,相同则覆盖
-(void)setDataCacheToDatabase:(NSString *)responseString
                   requestDic:(NSDictionary *)requestDics
                   moduleName:(NSString *)moduleName
                  networkType:(SaveNetworkDataType)networkType
                      results:(void (^)(BOOL isSuccessful))results
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *dataString=responseString;
            NSString *requestString=[requestDics JSONRepresentation];
            if (requestString==nil || [requestString isKindOfClass:[NSNull class]]) {
                requestString=@"{}";
            }
            NSString *moduleNameString=moduleName;
            NSString *stimeString=[NDTDNetworkDataCache currentTimeTimestamp];
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where moduleName=? and requestDic=? and networkType =?",networkDataCachetableName],moduleNameString,requestString,[NSNumber numberWithInteger:networkType]];
            int num = 0;
            BOOL flag;
            while ([result next]) {
                num++;
            }
            if(num!= 0)
            {
                //数据库数据更新掉
                flag=[db executeUpdate:[NSString stringWithFormat:@"update %@ set moduleName=?,requestDic=?,data=?, stime=? where moduleName=? and requestDic=? and networkType=?",networkDataCachetableName],moduleNameString,requestString,dataString,stimeString,moduleNameString,requestString,[NSNumber numberWithInteger:networkType]];
                NSLog(@"flag=%d",flag);
            }
            else
            {
                //新数据插入数据库
                flag=[db executeUpdate:[NSString stringWithFormat:@"insert into %@ values (NULL,?,?,?,?,?)",networkDataCachetableName],moduleNameString,dataString,requestString,[NSNumber numberWithInteger:networkType],stimeString];
            }
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                results(flag);
            });
        }];

    });
}

-(void)getNetworkData:(id)requestData results:(void (^)(id callbackData))results;
{
    SaveNetworkDataType networkType = HTTPType;
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]]) {
        networkType = HTTPType;
        NDTDHTTPRequestData *newRequestData = (NDTDHTTPRequestData *)requestData;
        [self getHttpDataCacheToDatabase:newRequestData networkType:networkType results:results];
    }
    else
    {
        networkType = SOCKETType;
        NDTDSocketRequestData *newRequestData = (NDTDSocketRequestData *)requestData;
        [self getSocketDataCacheToDatabase:newRequestData.requestDic moduleName:newRequestData.moduleName networkType:networkType results:results];
    }
}


-(void)getHttpDataCacheToDatabase:(NDTDHTTPRequestData *)requestData
                      networkType:(SaveNetworkDataType)networkType
                          results:(void (^)(id callbackData))results
{
    NSString *requestString=[requestData.requestDic JSONRepresentation];
    if (requestString==nil || [requestString isKindOfClass:[NSNull class]]) {
        requestString=@"{}";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *result  = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where moduleName=? and requestDic=? and networkType=?",networkDataCachetableName],requestData.moduleName,requestString,[NSNumber numberWithInteger:networkType]];
            NDTDHTTPCallbackData * httpCallBackData=nil;
            while ([result next])
            {
                NSString *dataString=[result stringForColumn:@"data"];
                httpCallBackData= [[NDTDHTTPCallbackData alloc] init];
                httpCallBackData.dataDic=[dataString JSONValue];
                httpCallBackData.dataSource=SourceCache;
                httpCallBackData.ID = [[result stringForColumn:@"ID"] intValue];
                httpCallBackData.iCMType = requestData.iCMType;
                httpCallBackData.requestData = requestData;
                httpCallBackData.moduleName = requestData.moduleName;
            }
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                results(httpCallBackData);
            });
        }];

    });
}

//数据从数据库取出
-(void)getSocketDataCacheToDatabase:(NSDictionary *)requestDics
                   moduleName:(NSString *)moduleName
                  networkType:(SaveNetworkDataType)networkType
                      results:(void (^)(id callbackData))results
{
    NSString *requestString=[requestDics JSONRepresentation];
    if (requestString==nil || [requestString isKindOfClass:[NSNull class]]) {
        requestString=@"{}";
    }
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *result  = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where moduleName=? and requestDic=? and networkType=?",networkDataCachetableName],moduleName,requestString,[NSNumber numberWithInteger:networkType]];
        NDTDSocketCallbackData *socketCallbackData=nil;
        while ([result next])
        {
            socketCallbackData = [[NDTDSocketCallbackData alloc]init];
            socketCallbackData.moduleName = [result stringForColumn:@"moduleName"];
            socketCallbackData.dataDic = [[result stringForColumn:@"data"] JSONValue];
            
        }
        results(socketCallbackData);
        
    }];
    
}


@end
