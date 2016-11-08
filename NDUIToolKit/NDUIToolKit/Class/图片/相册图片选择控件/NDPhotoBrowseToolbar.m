//
//  NDPhotoBrowseToolbar.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/29.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoBrowseToolbar.h"
#import "NDPhotoData.h"

#define NDUI_PHOTO_TOOLBAR_BTN_SPACE 10


@interface NDPhotoBrowseToolbar(){
    UIButton *_btnFilter;   ///< 滤镜
    UIButton *_btnLux;      ///< 魔术棒
    UIButton *_btnCrop;     ///< 裁剪
    
    NSMutableArray *btnArray;
    NDPhotoFilterView *filterView; ///< 所有滤镜效果面板
}

@end

@implementation NDPhotoBrowseToolbar

- (id)initWithFrame:(CGRect)frame funcFlag:(NSString *)funcFlag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:NDUI_COLOR_F8F8F8];
        [self createView];
        
        if ([funcFlag isMatch:@"[0-1](\\|[0-1])*"]) {
            NSArray *funcFlags = [funcFlag componentsSeparatedByString:@"|"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0 ; i < funcFlags.count ; i++) {
                if ([funcFlags[i] boolValue] == YES) {
                    [tempArray addObject:btnArray[i]];
                }
            }
            
            [btnArray removeAllObjects];
            btnArray = tempArray;
            
            CGFloat itemWidth = self.height;
            CGFloat itemHeight = self.height;
            CGFloat tb = (itemHeight - 32.0)/2.0;
            CGFloat fr = (itemWidth - 30.0)/2.0;
            
            CGFloat leftMargin = ( self.width - btnArray.count * itemWidth - (btnArray.count - 1) * NDUI_PHOTO_TOOLBAR_BTN_SPACE )/2.0;
            
            UIButton *menuBtn = nil;
            
            
            for ( NSInteger i = 0 ; i < btnArray.count ; i++) {
                menuBtn = btnArray[i];
                menuBtn.frame = CGRectMake(leftMargin + (itemWidth + NDUI_PHOTO_TOOLBAR_BTN_SPACE) * i, 0, itemWidth, itemHeight);
                [menuBtn setImageEdgeInsets:UIEdgeInsetsMake(tb, fr, tb, fr)];
                [self addSubview:menuBtn];
            }
        }
        
        filterView = [[NDPhotoFilterView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
    }
    return self;
}

- (void)createView
{
    
    _btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFilter addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFilter setImage:[UIImage imageInUIToolKitProject:@"light-simple-filter-icon"] highLightImage:[UIImage imageInUIToolKitProject:@"light-simple-filter-icon-active"]];
    
    _btnLux = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLux addTarget:self action:@selector(luxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLux setImage:[UIImage imageInUIToolKitProject:@"light-icon-lux"] highLightImage:[UIImage imageInUIToolKitProject:@"light-icon-lux-active"]];
    
    _btnCrop = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCrop addTarget:self action:@selector(cropBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCrop setImage:[UIImage imageInUIToolKitProject:@"light-icon-crop"] highLightImage:[UIImage imageInUIToolKitProject:@"light-icon-crop-active"]];
    
    btnArray = [[NSMutableArray alloc] init];
    [btnArray addObject:_btnFilter];
    [btnArray addObject:_btnLux];
    [btnArray addObject:_btnCrop];
}

/**
 *  滤镜按钮点击
 *
 *  @param sender 滤镜按钮
 */
- (void)filterBtnClick:(id)sender
{
    filterView.delegate = self.delegate;
    
    if (_btnFilter.NDHighLight == NO) {
        _btnFilter.NDHighLight = YES;
        
        filterView.frame = CGRectMake(self.left, self.top, filterView.width, filterView.height);
        [self.superview insertSubview:filterView belowSubview:self];
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            filterView.frame = CGRectMake(self.left, self.top - filterView.height, filterView.width, filterView.height);
        }completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(filterScrollViewDisplayChange:view:)]) {
                [self.delegate filterScrollViewDisplayChange:YES view:filterView];
            }
        }];
        
    }else{
        _btnFilter.NDHighLight = NO;
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            filterView.frame = CGRectMake(self.left, self.top, filterView.width, filterView.height);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(filterScrollViewDisplayChange:view:)]) {
                [self.delegate filterScrollViewDisplayChange:NO view:filterView];
            }
            [filterView removeFromSuperview];
        }];
    }
    
}

#pragma 关闭滤镜栏
- (void)closeFilterView
{
    _btnFilter.NDHighLight = NO;
    _btnLux.NDHighLight = NO;
    [filterView resetData];
    [filterView removeFromSuperview];
}

/**
 *  魔术棒按钮点击
 *
 *  @param sender 魔术棒按钮
 */
- (void)luxBtnClick:(id)sender
{
    if (_btnLux.NDHighLight == NO) {
        _btnLux.NDHighLight = YES;
    }else{
        _btnLux.NDHighLight = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(luxSelectedChanged:)]) {
        [self.delegate luxSelectedChanged:_btnLux.NDHighLight];
    }
}

/**
 *  裁剪按钮点击
 *
 *  @param sender 裁剪按钮
 */
- (void)cropBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gotoCropMode)]) {
        [self.delegate gotoCropMode];
    }
}


#pragma mark 修改滤镜demo图
- (void)changeFilterImages:(NDPhotoData *)photoData
{
    if (_btnFilter.NDHighLight == YES) {
        [filterView showFilterImages:photoData];
    }else{
        [filterView resetDataWithPhotoData:photoData];
    }
}

#pragma mark 改变lux按钮的选中状态
- (void)changeLuxStatus:(NDPhotoData *)photoData
{
    _btnLux.NDHighLight = photoData.enableLux; // 回填lux的状态
}

@end
