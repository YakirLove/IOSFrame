//
//  NDCycleScrollView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/11/3.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "CycleScrollView.h"
/**
 *  拓展循环滚动面板
 */
@interface NDCycleScrollView : CycleScrollView

/**
 滚动切换的时候
 **/
@property (nonatomic , copy) void (^PageChanged)(NSInteger pageIndex);

@end
