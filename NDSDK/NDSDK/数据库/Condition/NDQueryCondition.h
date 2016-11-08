//
//  NDQueryCondition.h
//  数据查询条件限制
//
//  Created by 陈峰 on 14-7-2.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

//or 或者 and 条件
#define ND_OPER_AND @"(%@ AND %@)"
#define ND_OPER_OR @"(%@ OR %@)"

//字符串比较
#define ND_OPER_GT @"%@ > '%@' "
#define ND_OPER_GE @"%@ >= '%@' "
#define ND_OPER_LT @"%@ < '%@' "
#define ND_OPER_LE @"%@ <= '%@' "
#define ND_OPER_EQ @"%@ = '%@' "
#define ND_OPER_NE @"%@ <> '%@' "
#define ND_OPER_IN @"%@ IN (%@)"

//数值型比较
#define ND_OPER_GT_NUMBER @"CAST(%@ AS DOUBLE) > %@ "
#define ND_OPER_GE_NUMBER @"CAST(%@ AS DOUBLE) >= %@ "
#define ND_OPER_LT_NUMBER @"CAST(%@ AS DOUBLE) < %@ "
#define ND_OPER_LE_NUMBER @"CAST(%@ AS DOUBLE) <= %@ "
#define ND_OPER_EQ_NUMBER @"CAST(%@ AS DOUBLE) = %@ "
#define ND_OPER_NE_NUMBER @"CAST(%@ AS DOUBLE) <> %@ "

//布尔值的常量值
#define ND_BOOL_YES_STR @"1"
#define ND_BOOL_NO_STR @"0"

@interface NDQueryCondition : NSObject

#pragma mark 构造方法
-(id)initWithKey:(NSString *)key value:(NSString *)value oper:(NSString *)oper;

#pragma mark 条件的数据库字段
@property(copy,nonatomic)NSString *key;
#pragma mark 条件比对的值
@property(copy,nonatomic)NSString *value;
#pragma mark 条件操作
@property(copy,nonatomic)NSString *oper;


@end
