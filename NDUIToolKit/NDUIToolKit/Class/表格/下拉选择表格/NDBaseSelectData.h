//
//  BaseSelectData.h
//  SelectServer
//
//  Created by 网龙技术部 on 15/8/5.
//  Copyright (c) 2015年 吴焰基. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDPullDownView.h"

@interface NDBaseSelectData : NSObject <NDPullDownViewDelegate>
/**
 *  创建数据
 */
-(void)initData;
/**
 *  创建PullDownView的视图
 */
-(void)initSelectView;

@end
