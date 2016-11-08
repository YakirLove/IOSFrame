//
//  NDTDInputFaceView.h
//  NDTDChat
//
//  Created by 林 on 7/28/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDTDInputFacePictureView;
@class NDTDInputFaceMenuView;
@protocol NDTDInputFacePanelViewDelegate <NSObject>

//点击删除按钮的回调
-(void)didClickDelete:(NDTDInputFacePictureView *)facePictureView;
//点击发送按钮的回调
-(void)didClickSendBtnInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView;
//点击表情的回调
-(void)didClickPictureface:(NDTDInputFacePictureView *)facePictureView imagePath:(NSString *)imagePath imageName:(NSString *)imageName;

@end

#define SYSTEM_GIFEMOJI @"system_ gifEmoji"            //系统的gif表情bundle
#define SYSTEM_PICTUREEMOJI @"system_ pictureEmoji"    //系统的图片表情bundle
#define DOWNLOAD_GIFEMOJI   @"Download_GifEmoji"       //下载的gif表情资源
#define DOWNLOAD_PICTUREEMOJI @"Download_PictureEmoji" //下载的图片表情资源
#define DownloadEmoji @"DownloadEmoji"                 //下载保存在Document目录下的表情资源文件夹
#define ICON_NAME @"标志.png"                           //菜单按钮的标志图标名称

@interface NDTDInputFacePanelView : UIView

@property(nonatomic,assign)id<NDTDInputFacePanelViewDelegate>delegate;

-(void)setSendButton:(UIControlState)controlState;
-(void)setSendButtonTitle:(NSString *)title;
@end
