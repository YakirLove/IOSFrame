//
//  NDInteger.h
//  int的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

@interface NDInteger : NSObject

#pragma mark 值
@property(assign,nonatomic)int intValue;


-(id)initWithString:(NSString *)str;

-(id)initWithInt:(int)iv;

#pragma mark 用string初始化
+(NDInteger *)dbintWithString:(NSString *)string;

@end
