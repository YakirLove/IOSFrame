//
//  NDPhotoFilterView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/31.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  滤镜数据
 */
@interface NDFilterData : NSObject

@property(assign,nonatomic)NDUIFilterType filterType; ///< 滤镜类型
@property(copy,nonatomic)NSString *filterName; ///< 滤镜名称
@property(strong,nonatomic)UIImage *filerImage; ///< 滤镜效果图

/**
 *  初始化
 *
 *  @param filterName 滤镜名称
 *  @param type       类型
 *
 *  @return 对象
 */
- (id)initWithName:(NSString *)filterName filterType:(NDUIFilterType)filterType;

@end

@class NDPhotoData;
@protocol NDPhotoFilterViewDelegate;


/**
 *  滤镜视图
 */
@interface NDPhotoFilterView : UIView

@property(assign,nonatomic)id<NDPhotoFilterViewDelegate>delegate; ///< 事件委托

/**
 *  显示滤镜图
 *
 *  @param photoData 图片信息
 */
- (void)showFilterImages:(NDPhotoData *)photoData;

/**
 *  删除缓存滤镜图片
 */
- (void)resetData;


/**
 *  删除缓存滤镜图片、如果已经是同一个图片 那么不删除
 *
 *  @param photoData 当前图片数据
 */
- (void)resetDataWithPhotoData:(NDPhotoData *)photoData;

@end

@protocol NDPhotoFilterViewDelegate <NSObject>
/**
 *  滤镜选择
 *
 *  @param data 滤镜数据
 */
-(void)didFilterSelected : (NDFilterData *)data;

@end
