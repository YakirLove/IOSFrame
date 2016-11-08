//
//  NDTDInputFaceView.m
//  NDTDChat
//
//  Created by 林 on 7/28/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputFacePanelView.h"
#import "NDTDInputFaceMenuView.h"
#import "NDTDInputFacePictureView.h"
#import "NDTDInputFaceGifView.h"

@interface NDTDInputFacePanelView ()<UIScrollViewDelegate,NDTDInputFaceMenuViewDelegate,NDTDInputFacePictureViewDelegate>
{
    UIScrollView *scrollView;
    UIButton *sendButton;
    UIPageControl *pageControl;
    NSInteger pageCount;
    NSMutableArray *emojiResourcesArray;
    NSInteger selectIndex;
    NDTDInputFaceMenuView *faceMenuView;
}
@end

@implementation NDTDInputFacePanelView
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfigurationInformation];
    }
    return self;
}

-(void)setConfigurationInformation
{
    if (emojiResourcesArray==nil) {
        emojiResourcesArray = [[NSMutableArray alloc]init];
        selectIndex = 0;
    }
    else
    {
        [emojiResourcesArray removeAllObjects];
    }
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSArray * bundleArray=[NSBundle pathsForResourcesOfType:@"bundle" inDirectory:bundlePath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //系统图片表情放在最前面
    for (int i=0; i<bundleArray.count; i++) {
        NSString *bPath = [bundleArray objectAtIndex:i];
        if ([bPath rangeOfString:SYSTEM_PICTUREEMOJI].length>0) {
            NSString *resourcesPath = [bPath stringByAppendingPathComponent:@"Contents/Resources"];
            if ([fileManage fileExistsAtPath:resourcesPath]) {
                NSArray *array = [fileManage contentsOfDirectoryAtPath:resourcesPath error:nil];
                if (array.count>0) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:resourcesPath forKey:@"path"];
                    [dic setObject:ICON_NAME forKey:@"iconImage"];
                    [dic setObject:@"png" forKey:@"type"];
                    [dic setObject:@"1" forKey:@"isSystem"];
                    [emojiResourcesArray addObject:dic];
                }
            }
        }
    }
    //系统gif表情
    for (int i=0; i<bundleArray.count; i++) {
        NSString *bPath = [bundleArray objectAtIndex:i];
        if ([bPath rangeOfString:SYSTEM_GIFEMOJI].length>0) {
            NSString *resourcesPath = [bPath stringByAppendingPathComponent:@"Contents/Resources"];
            if ([fileManage fileExistsAtPath:resourcesPath]) {
                NSArray *array = [fileManage contentsOfDirectoryAtPath:resourcesPath error:nil];
                if (array.count>0) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:resourcesPath forKey:@"path"];
                    [dic setObject:ICON_NAME forKey:@"iconImage"];
                    [dic setObject:@"gif" forKey:@"type"];
                    [dic setObject:@"1" forKey:@"isSystem"];
                    [emojiResourcesArray addObject:dic];
                }
            }
        }
    }
    
    //寻找Document目录下的图片和gif表情资源
    NSString *downloadPath = [[NDTDInputFacePanelView getDocumentPath] stringByAppendingPathComponent:DownloadEmoji];
    if ([fileManage fileExistsAtPath:downloadPath]) {
        NSArray *array = [fileManage contentsOfDirectoryAtPath:downloadPath error:nil];
        //下载的资源图片表情
        for (int i=0; i<array.count; i++) {
            NSString *dPath = [array objectAtIndex:i];
            //寻找Document目录下的图片表情资源
            if ([dPath rangeOfString:DOWNLOAD_PICTUREEMOJI].length>0) {
                NSArray *picArray = [fileManage contentsOfDirectoryAtPath:[downloadPath stringByAppendingPathComponent:dPath] error:nil];
                if (picArray.count>0) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:[downloadPath stringByAppendingPathComponent:dPath] forKey:@"path"];
                    [dic setObject:ICON_NAME forKey:@"iconImage"];
                    [dic setObject:@"png" forKey:@"type"];
                    [dic setObject:@"0" forKey:@"isSystem"];
                    [emojiResourcesArray addObject:dic];
                }
            }
        }
        //下载的资源gif表情
        for (int i=0; i<array.count; i++) {
            NSString *dPath = [array objectAtIndex:i];
            //寻找Document目录下的图片表情资源
            if ([dPath rangeOfString:DOWNLOAD_GIFEMOJI].length>0) {
                NSArray *picArray = [fileManage contentsOfDirectoryAtPath:[downloadPath stringByAppendingPathComponent:dPath] error:nil];
                if (picArray.count>0) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:[downloadPath stringByAppendingPathComponent:dPath] forKey:@"path"];
                    [dic setObject:ICON_NAME forKey:@"iconImage"];
                    [dic setObject:@"gif" forKey:@"type"];
                    [dic setObject:@"0" forKey:@"isSystem"];
                    [emojiResourcesArray addObject:dic];
                }
                
            }
        }
    }
    
    [self refreshView];
    
}

-(void)refreshView
{
    for (id object in self.subviews) {
        if ([object isMemberOfClass:[NDTDInputFacePictureView class]] || [object isMemberOfClass:[NDTDInputFaceGifView class]]) {
            UIView *newView = (UIView *)object;
            [newView removeFromSuperview];
        }
    }
    
    if (emojiResourcesArray.count>0) {
        NSDictionary *dic = [emojiResourcesArray objectAtIndex:selectIndex];
        NSString *type = [dic objectForKey:@"type"];
        if ([type rangeOfString:@"png"].length>0 || [type rangeOfString:@"jpg"].length>0 || [type rangeOfString:@"tiff"].length>0) {
            NDTDInputFacePictureView *pictureView = [[NDTDInputFacePictureView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40) emojisDic:dic];
            pictureView.imageSize = CGSizeMake(28, 28);
            pictureView.delegate = self;
            [self addSubview:pictureView];
        }
        else
        {
            NDTDInputFaceGifView *gifView = [[NDTDInputFaceGifView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40) gifsDic:dic];
            gifView.gifSize = CGSizeMake(50, 50);
            gifView.isShowGifTitle = NO;
            [self addSubview:gifView];
        }
        
    }
    if (faceMenuView==nil) {
        faceMenuView = [[NDTDInputFaceMenuView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40) emojiResourcesArray:emojiResourcesArray selectIndex:selectIndex];
        faceMenuView.delegate = self;
        [self addSubview:faceMenuView];
    }
    
}

-(void)setSendButton:(UIControlState)controlState
{
    if (controlState == UIControlStateNormal) {
        faceMenuView.sendBtn.selected = NO;
    }
    else
    {
        faceMenuView.sendBtn.selected = YES;
    }
}

-(void)setSendButtonTitle:(NSString *)title
{
    [faceMenuView setSendBtnTitle:title];
}

+ (NSString *)getDocumentPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark --NDTDInputFaceMenuViewDelegate
//点击加号的回调
-(void)didClickAddInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView
{
    
}

//点击表情菜单按钮的回调
-(void)didClickItemBtnInputFaceMenuView:(NDTDInputFaceMenuView *)faceMenuView selectIndex:
(NSInteger)selectIndexs
{
    selectIndex = selectIndexs;
    [self refreshView];
    
}

//点击发送按钮的回调
-(void)didClickSendBtnInputFaceMenuView:(NDTDInputFaceMenuView *)_faceMenuView
{
    if (delegate && [delegate respondsToSelector:@selector(didClickSendBtnInputFaceMenuView:)]) {
        [delegate didClickSendBtnInputFaceMenuView:_faceMenuView];
    }
}

#pragma mark --NDTDInputFacePictureViewDelegate
//点击表情
-(void)didClickPictureface:(NDTDInputFacePictureView *)facePictureView imagePath:(NSString *)imagePath imageName:(NSString *)imageName
{
    if (delegate && [delegate respondsToSelector:@selector(didClickPictureface:imagePath:imageName:)]) {
        [delegate didClickPictureface:facePictureView imagePath:imagePath imageName:imageName];
    }
}
//点击删除按钮的回调
-(void)didClickDelete:(NDTDInputFacePictureView *)facePictureView
{
    if (delegate && [delegate respondsToSelector:@selector(didClickDelete:)] ) {
        [delegate didClickDelete:facePictureView];
    }
}


@end
