//
//  NDDouble.h
//  double的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

@interface NDDouble : NSObject

#pragma mark 值
@property(assign,nonatomic)double doubleValue;

-(id)initWithString:(NSString *)str;

-(id)initWithDouble:(double)dv;

#pragma mark 用string初始化
+(NDDouble *)dbdoubleWithString:(NSString *)string;


@end
