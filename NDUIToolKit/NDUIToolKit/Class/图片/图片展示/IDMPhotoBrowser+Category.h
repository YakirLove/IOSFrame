//
//  IDMPhotoBrowser+Category.h
//  NDUIToolKit
//
//  Created by zhangx on 15/11/19.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "IDMPhotoBrowser.h"

@interface IDMPhotoBrowser (Category)

@property(nonatomic,assign)CGSize doneImageSize;

@property (nonatomic , copy) void (^doneButtonClick)(IDMPhotoBrowser *browser,NSInteger pageIndex);  ///< 滚动切换的时候

- (void)doneButtonPressed:(id)sender;

- (void)dismissPhotoBrowserAnimated:(BOOL)animated ;

- (void)removeImageAtIndex:(NSInteger)index;

- (NSInteger)imageCount;

- (void)toggleControls;

- (void)setSenderViewForAnimation:(UIView *)view;

@end
