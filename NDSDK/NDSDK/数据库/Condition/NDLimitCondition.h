//
//  NDLimitCondition.h
//  查询结果限制条数跟起始位置  用于分页
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ND_NO_LIMIT -1

@interface NDLimitCondition : NSObject

//起始位置
@property(nonatomic,assign)int offset;

//条数
@property(nonatomic,assign)int count;

//初始化
-(id)initWithCount:(int )_count offset:(int)_offset;

@end
