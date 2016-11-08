//
//  NDTDInPutMoreView.h
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

/**
 *  类说明：
 *  1、推荐使用[initWithFrame:...]方法进行初始化
 *  3、可扩展方法customView自定义视图
 */

#import <UIKit/UIKit.h>
#import "NDKeyBoardPhotoPicker.h"
@class NDTDInputMoreView;

@protocol NDTDInputMoreViewDelegate <NSObject>

-(void)didPickedImagePaths:(NDTDInputMoreView *)inputMoreView imagePaths:(NSMutableArray *)imagePaths;

@end

@interface NDTDInputMoreView : UIView

@property (nonatomic, assign) id<NDTDInputMoreViewDelegate>delegate;

-(void)customView;

@end
