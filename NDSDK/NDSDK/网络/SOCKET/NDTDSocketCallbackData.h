//
//  NDTDSocketCallBackData.h
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/1/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDTDSocketCallbackData : NSObject


@property(nonatomic,copy)NSString *moduleName;             //业务编号

//成功时
@property(nonatomic,strong)NSMutableDictionary *dataDic;  //服务端返回的数据
//失败时
@property(nonatomic,copy)NSString *errorReason;           //错误原因;


@end
