//
//  OMGToast.h
//  使用需加入 QuartzCore.framework
//
//  Created by 陈峰 on 14-6-16.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

//默认显示时间
#define DEFAULT_DISPLAY_DURATION 2.0f

@interface OMGToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

#pragma mark 显示toast 提示 内容
+ (void)showWithText:(NSString *) text_;

#pragma mark 显示toast 提示 内容 显示时间
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

#pragma mark 显示toast 提示 内容 距离顶部的位置
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;

#pragma mark 显示toast 提示 内容 距离顶部的位置 显示时间
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

#pragma mark 显示toast 提示 内容 距离底部的位置
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;

#pragma mark 显示toast 提示 内容 距离底部的位置 显示时间
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end
