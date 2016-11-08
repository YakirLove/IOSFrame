//
//  NDGroupCondition.h
//  查询结果分组
//
//  Created by 陈峰 on 14-7-8.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDGroupCondition : NSObject

//列名
@property(nonatomic,copy)NSString *column;


//初始化
-(id)initWithString:(NSString *)_column;

@end
