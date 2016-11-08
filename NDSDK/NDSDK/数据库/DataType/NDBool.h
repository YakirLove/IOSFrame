//
//  NDBool.h
//  bool的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

@interface NDBool : NSObject

#pragma mark 值
@property(assign,nonatomic)BOOL boolValue;

-(int)intValue;

-(id)initWithString:(NSString *)str;

-(id)initWithBool:(BOOL)bv;

#pragma mark true
+(NDBool *)NDYES;

#pragma mark no
+(NDBool *)NDNO;

@end
