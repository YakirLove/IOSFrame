//
//  NDKeyBoard.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/6.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 键盘类
 */
@interface NDKeyBoard : UIView

/**
 *  初始化
 *
 *  @param frame    位置信息
 *  @param funcFlag 功能配置  文本|摄像头|图片|表情|声音|GIF|更多|赞同
 *
 *  @return 初始化
 */
-(id)initWithFrame:(CGRect)frame funcFlag:(NSString *)funcFlag;

@end
