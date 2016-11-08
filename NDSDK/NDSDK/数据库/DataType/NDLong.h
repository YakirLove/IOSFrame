//
//  NDLong.h
//  long的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

@interface NDLong : NSObject

#pragma mark 值
@property(assign,nonatomic)long long longValue;

-(id)initWithString:(NSString *)str;

-(id)initWithLong:(long long)lv;

#pragma mark 用string初始化
+(NDLong *)dblongWithString:(NSString *)string;


@end
