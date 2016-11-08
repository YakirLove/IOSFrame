//
//  NDTDInputFaceMenuView.h
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ITEMBTNWITH 70.0                            //按钮的长度

@class NDTDInputFaceMenuView;
@protocol NDTDInputFaceMenuViewDelegate <NSObject>

//点击加号的回调
-(void)didClickAddInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView;
//点击表情菜单按钮的回调
-(void)didClickItemBtnInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView selectIndex:(NSInteger)selectIndexs;
//点击发送按钮的回调
-(void)didClickSendBtnInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView;
@end

@interface NDTDInputFaceMenuView : UIView


@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) id<NDTDInputFaceMenuViewDelegate>delegate;

/**
 *  初始化
 *
 *  @param frame               位置和大小
 *  @param emojiResourcesArray数组里为NSDictionary对象{
                                               iconImage = "\U6807\U5fd7.png";
                                               isSystem = 0;
                                               path = "Download_PictureEmoji_1";
                                               type = png;
 }
 *  @param selectIndex             选中的索引
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame
         emojiResourcesArray:(NSMutableArray *)emojiResourcesArray
                 selectIndex:(NSInteger)selectIndexs;

-(void)refreshView;

-(void)setSendBtnTitle:(NSString *)title;

@end
