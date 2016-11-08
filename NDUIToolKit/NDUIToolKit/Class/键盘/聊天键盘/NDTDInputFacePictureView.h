//
//  NDTDInputFacePictureView.h
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//


#import <UIKit/UIKit.h>

#define ImageMaxHeight 36.0     //表情图标最大的高
#define ImageMinHeight 18.0     //表情图标最小的高
#define ImageMaxWith 36.0       //表情图标最大的宽
#define ImageMinwith 18.0       //表情图标最小的宽
#define Regex_emoji @""         //表情的正则，如果为@“”,表示不用正则

@class NDTDInputFacePictureView;
@protocol NDTDInputFacePictureViewDelegate <NSObject>
//点击表情的回调
-(void)didClickPictureface:(NDTDInputFacePictureView *)facePictureView imagePath:(NSString *)imagePath imageName:(NSString *)imageName;
//点击删除按钮的回调
-(void)didClickDelete:(NDTDInputFacePictureView *)facePictureView;
@end

@interface NDTDInputFacePictureView : UIView

@property(nonatomic,assign)CGSize imageSize;     //图标的大小，最小18，最大32

@property(nonatomic,assign)id<NDTDInputFacePictureViewDelegate>delegate;

/**
 *  初始化
 *
 *  @param frame    位置
 *  @param menuDics 表情集信息
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame emojisDic:(NSDictionary *)emojisDics;

@end
