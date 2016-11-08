//
//  NDAlbumsTableCell.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  选择相册的弹出框当中的tableview的cell
 */
@interface NDAlbumsTableCell : UITableViewCell

@property(strong,nonatomic)UIImageView *checkMark; ///< 选中图片

/**
 *  绘制视图
 *
 *  @param group 相册数据
 */
- (void)drawView:(NDAssetsGroup *)group;

@end
