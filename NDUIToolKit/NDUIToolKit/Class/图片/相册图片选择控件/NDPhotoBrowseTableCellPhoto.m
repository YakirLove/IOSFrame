//
//  NDPhotoBrowseTableCellPhoto.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoBrowseTableCellPhoto.h"

@interface NDPhotoBrowseTableCellPhoto(){
    
    UIImageView *numberImage;  ///< 序号图
    UILabel *numberLabel; ///< 序号
    UIImageView *cameraImage; ///< 相机图片
}

@end

@implementation NDPhotoBrowseTableCellPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self ) {
        numberImage = [[UIImageView alloc] initWithFrame:self.bounds];
        numberImage.image = [UIImage imageInUIToolKitProject:@"simple-selector-ios7"];
        [self addSubview:numberImage];
        
        CGFloat width = self.width * 44 / 208;
        CGFloat height = self.height * 44 / 208;
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - width, 0, width, height)];
        numberLabel.font = [UIFont boldSystemFontOfSize:self.width * 20 / 208];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = @"18";
        [self addSubview:numberLabel];
        
        [self hideNumber];
    }
    return self;
}

#pragma mark 显示序号
- (void)showNumber:(NSInteger)number
{
    numberLabel.hidden = NO;
    numberImage.hidden = NO;
    numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    self.isNumberVisable = YES;
}

#pragma mark 隐藏序号
- (void)hideNumber
{
    numberLabel.hidden = YES;
    numberImage.hidden = YES;
    self.isNumberVisable = NO;
}

#pragma mark 点击的动画
- (void)clickAnimations
{
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.96, 0.96);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

#pragma mark 是否是拍照按钮
- (void)setIsCameraPhoto:(BOOL)isCameraPhoto
{
    _isCameraPhoto = isCameraPhoto;
    if (isCameraPhoto) {
        if (cameraImage == nil) {
            cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 48.0)/2.0, (self.height - 48.0)/2.0, 48.0, 48.0)];
            cameraImage.image = [UIImage imageInUIToolKitProject:@"fbc_glyphcamera_medium_24_normal"];
        }
        [self addSubview:cameraImage];
        self.backgroundColor = [UIColor colorWithHexString:@"e5e6ea"];
    }else{
        [cameraImage removeFromSuperview];
        self.backgroundColor = [UIColor clearColor];
    }
}


@end
