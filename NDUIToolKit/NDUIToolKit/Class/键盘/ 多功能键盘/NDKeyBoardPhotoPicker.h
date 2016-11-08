//
//  NDKeyBoardPhotoPicker.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDKeyBoardPhotoPickerDelegate;


@interface NDKeyBoardPhotoPicker : UIView

@property(assign,nonatomic)id<NDKeyBoardPhotoPickerDelegate>delegate; 

@property(assign,nonatomic)NSInteger maxImageCnt;  ///< 最多一次选几种照片

@end


@protocol NDKeyBoardPhotoPickerDelegate <NSObject>

/**
 *  选中了一些图片
 *
 *  @param photoDatas 图片 NDPhotoData对象 请使用 imageToShow 方法获取照片
 *  @param pickerView 自身对象
 */
-(void)didPickedImages:(NSArray *)photoDatas pickerView:(NDKeyBoardPhotoPicker *)pickerView;

@end