//
//  NDPhotoBrowseTableView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoBrowseTableView.h"
#import "NDPhotoBrowseTableCell.h"
#import "NDPhotoBrowseTableCellPhoto.h"
#import "NDPhotoData.h"

@interface NDPhotoBrowseTableView()<UITableViewDataSource,UITableViewDelegate,NDPhotoBrowseTableCellDelegate>{
    CGFloat imageWidth;  ///< 图片宽度
    NSInteger lastClickedImage; ///< 最后点击的image
}

@end

@implementation NDPhotoBrowseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedArray = [[NSMutableArray alloc] init];
        lastClickedImage = -1;
    }
    return self;
}

- (void) setColCnt:(NSInteger)colCnt
{
    _colCnt = colCnt;
    imageWidth = (self.width - NDUI_PHOTOBROWSE_TABLEVIEW_SPACE * (_colCnt - 1)) / _colCnt;
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return 0;
    }
    NSInteger row = self.dataArray.count / _colCnt;
    return row + (self.dataArray.count % _colCnt == 0 ? 0 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NDPhotoBrowseTableCell";
    NDPhotoBrowseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NDPhotoBrowseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageWidth:imageWidth colCnt:_colCnt];
        cell.delegate = self;
    }
    
    for (NSInteger i = 0; i < cell.imageArray.count; i++) {
        ((UIView *)cell.imageArray[i]).hidden = YES;
    }
    
    for (NSInteger i = 0; i < cell.imageArray.count && indexPath.row * _colCnt + i < self.dataArray.count ; i++) {
        NDPhotoBrowseTableCellPhoto * imageView = ((NDPhotoBrowseTableCellPhoto *)cell.imageArray[i]);
        imageView.hidden = NO;
        imageView.tag = indexPath.row * _colCnt + i;
        
        if ([self.cellDelegate cameraEnable] && i == 0 && indexPath.row == 0) {  //拍照启用时候 第一个是拍照按钮
            imageView.isCameraPhoto = YES;
            [imageView hideNumber];
            imageView.image = nil;
        }else{
            imageView.isCameraPhoto = NO;
            
            NDPhotoData *photoData = self.dataArray[imageView.tag];
            
            imageView.image = [photoData imageToShow];
            
            NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)imageView.tag];
            if ([self.selectedArray containsObject:tagStr]) {
                [imageView showNumber:[self.selectedArray indexOfObject:tagStr] + 1];
            }else{
                [imageView hideNumber];
            }
            
            if (imageView.tag == lastClickedImage) { //点击动画
                [imageView clickAnimations];
            }
        }
       
    }
    
    return cell;
}


- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return imageWidth + NDUI_PHOTOBROWSE_TABLEVIEW_SPACE;
}

#pragma mark NDPhotoBrowseTableCellDelegate

#pragma mark 图片点击
- (void)didImageClick:(NDPhotoBrowseTableCellPhoto *)image
{
    lastClickedImage = image.tag;
    if (image.isNumberVisable) { //序号已经可见时候  移除
        [self.selectedArray removeObject:[NSString stringWithFormat:@"%ld",(long)image.tag]];
    }else{ //序号可见时候 增加
        if (self.selectedArray.count < [self.cellDelegate maxPhotosPicked]) {
            [self.selectedArray addObject:[NSString stringWithFormat:@"%ld",(long)image.tag]];
        }else{
            NSString *warnIngStr = [NSString stringWithFormat:@"一次只能添加%ld张照片",(long)[self.cellDelegate maxPhotosPicked]];
            ALERT_MSG(nil,warnIngStr);
        }
    }
    [self reloadData];
    
    
    
    if ([self.cellDelegate respondsToSelector:@selector(didImageClick:)]) {
        [self.cellDelegate didImageClick:image];
    }
}

#pragma mark 图片长按
- (void)didImageLongPress:(NDPhotoBrowseTableCellPhoto *)image
{
    if (image.isNumberVisable == NO) { //序号已经可见时候  移除
        if (self.selectedArray.count >= [self.cellDelegate maxPhotosPicked]) {
            NSString *warnIngStr = [NSString stringWithFormat:@"一次只能添加%ld张照片",(long)[self.cellDelegate maxPhotosPicked]];
            ALERT_MSG(nil,warnIngStr);
            return;
        }
    }
    
    if ([self.cellDelegate respondsToSelector:@selector(didImageLongPress:)]) {
        [self.cellDelegate didImageLongPress:image];
    }
}

#pragma mark 拍照按钮点击
- (void)didCameraClick:(NDPhotoBrowseTableCellPhoto *)image
{
    if ([self.cellDelegate respondsToSelector:@selector(didCameraClick:)]) {
        [self.cellDelegate didCameraClick:image];
    }
}

@end
