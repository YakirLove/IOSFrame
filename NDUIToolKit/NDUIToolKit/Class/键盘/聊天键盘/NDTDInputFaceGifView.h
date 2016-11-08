//
//  NDTDInputFaceGifView.h
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GifMaxHeight 60.0     //gif图最大的高
#define GifMinHeight 45.0     //gif图最小的高
#define GifMaxWith 60.0       //gif图最大的宽
#define GifMinwith 45.0       //gif图最小的宽


@interface NDTDInputFaceGifView : UIView

-(instancetype)initWithFrame:(CGRect)frame gifsDic:(NSDictionary *)gifsDics;

@property(nonatomic,assign) CGSize gifSize;

@property(nonatomic,assign) BOOL isShowGifTitle;       //是否显示表情标题

@end
