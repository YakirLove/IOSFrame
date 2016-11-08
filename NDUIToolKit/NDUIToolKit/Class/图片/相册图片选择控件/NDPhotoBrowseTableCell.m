//
//  NDPhotoBrowseTableCell.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoBrowseTableCell.h"
#import "NDPhotoBrowseTableCellPhoto.h"


@implementation NDPhotoBrowseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageWidth:(CGFloat)imageWidth colCnt:(NSInteger)colCnt
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;  //取消选中效果
        self.imageArray = [[NSMutableArray alloc] init];
        NDPhotoBrowseTableCellPhoto *imageView = nil;
        for (NSInteger i = 0; i < colCnt; i++) {
            imageView = [[NDPhotoBrowseTableCellPhoto alloc] initWithFrame:CGRectMake((NDUI_PHOTOBROWSE_TABLEVIEW_SPACE + imageWidth) * i, 0, imageWidth, imageWidth)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPress:)]];
            [self.contentView addSubview:imageView];
            [self.imageArray addObject:imageView];
        }
    }
    
    return self;
}

/**
 *  图片点击
 *
 *  @param gr 手势对象
 */
- (void)imageClick:(UITapGestureRecognizer *)gr
{
    NDPhotoBrowseTableCellPhoto *photoView = (NDPhotoBrowseTableCellPhoto *)gr.view;
    if (photoView.isCameraPhoto == NO) {
        if ([self.delegate respondsToSelector:@selector(didImageClick:)]) {
            [self.delegate didImageClick:photoView];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(didCameraClick:)]) {
            [self.delegate didCameraClick:photoView];
        }
    }
}

/**
 *  图片长按
 *
 *  @param gr 图片长按
 */
- (void)imageLongPress:(UILongPressGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        NDPhotoBrowseTableCellPhoto *photoView = (NDPhotoBrowseTableCellPhoto *)gr.view;
        if (photoView.isCameraPhoto == NO) {
            if ([self.delegate respondsToSelector:@selector(didImageLongPress:)]) {
                [self.delegate didImageLongPress:(NDPhotoBrowseTableCellPhoto *)gr.view];
            }
        }
    }
}

@end
