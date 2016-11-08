//
//  NDAlbumsTableView.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDAlbumsTableViewDelegate;
/**
 *  选择相册弹出框的tableview
 */
@interface NDAlbumsTableView : UITableView

@property(strong,nonatomic)NSMutableArray *dataArray; ///< 相册数据
@property(assign,nonatomic)NSInteger selectedIndex; ///< 当前选中相册的索引

@property(assign,nonatomic)id<NDAlbumsTableViewDelegate>albumsDelegate; ///< 相簿delegate

@end

@protocol NDAlbumsTableViewDelegate <NSObject>

/**
 *  选中某个相簿
 *
 *  @param index 相簿索引
 */
- (void)didSelectedAlbum:(NSInteger)index;

@end
