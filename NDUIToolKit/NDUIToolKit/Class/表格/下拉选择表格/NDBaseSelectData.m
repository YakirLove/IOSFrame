//
//  BaseSelectData.m
//  SelectServer
//
//  Created by 网龙技术部 on 15/8/5.
//  Copyright (c) 2015年 吴焰基. All rights reserved.
//

#import "NDBaseSelectData.h"

@implementation NDBaseSelectData 

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initData];
        [self initSelectView];
    }
    return self;
}

#pragma mark - 创建数据
-(void)initData
{
    
}

#pragma mark - 创建视图
-(void)initSelectView
{
    
}

#pragma mark - SelectServerViewDelegate
-(void)selectDic:(NSDictionary *)dic dickey:(NSString *)string pullDownView:(NDPullDownView *)pullDownView
{
    
}


@end
