//
//  NDPhotoFilterCellView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDPhotoFilterCellViewDelegate;

/**
 *  滤镜的cell 包含滤镜名称和 效果图
 */
@interface NDPhotoFilterCellView : UIView

@property(assign,nonatomic)NSInteger index;  ///< index
@property(assign,nonatomic)BOOL isSelected; ///< 是否选中
@property(assign,nonatomic)id<NDPhotoFilterCellViewDelegate>delegate; ///< 事件委托

/**
 *  填充数据
 *
 *  @param image 效果图
 *  @param name  名称
 */
-(void)fillData:(UIImage *)image name:(NSString *)name;

@end


@protocol NDPhotoFilterCellViewDelegate <NSObject>

@optional

/**
 *  点击事件
 *
 *  @param cell 自身
 */
- (void)didClick:(NDPhotoFilterCellView *)cell;

@end