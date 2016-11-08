//
//  IDMPhotoBrowser+Category.m
//  NDUIToolKit
//
//  Created by zhangx on 15/11/19.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "IDMPhotoBrowser+Category.h"

@implementation IDMPhotoBrowser (Category)

+ (void)load
{
    Class c = [IDMPhotoBrowser class];
    AutoCloseSwizzle(c, @selector(viewWillLayoutSubviews), @selector(override_viewWillLayoutSubviews));
}

static const char DoneImageSizeKey = '\0';
- (void)setDoneImageSize:(CGSize)doneImageSize
{
    if (CGSizeEqualToSize(self.doneImageSize, doneImageSize) == NO) {
        // 存储新的
        [self willChangeValueForKey:@"doneImageSize"]; // KVO
        objc_setAssociatedObject(self, &DoneImageSizeKey,
                                 [NSValue valueWithCGSize:doneImageSize] , OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"doneImageSize"]; // KVO
    }
}

- (CGSize)doneImageSize
{
    return [objc_getAssociatedObject(self, &DoneImageSizeKey) CGSizeValue];
}

static const char DoneButtonClickKey = '\0';
- (void)setDoneButtonClick:(void (^)(IDMPhotoBrowser *,NSInteger))doneButtonClick
{
    if (doneButtonClick != self.doneButtonClick) {
        // 存储新的
        [self willChangeValueForKey:@"doneButtonClick"]; // KVO
        objc_setAssociatedObject(self, &DoneButtonClickKey,
                                 doneButtonClick, OBJC_ASSOCIATION_COPY);
        [self didChangeValueForKey:@"doneButtonClick"]; // KVO
    }
}

- (void (^)(IDMPhotoBrowser *,NSInteger))doneButtonClick
{
    return objc_getAssociatedObject(self, &DoneButtonClickKey);
}



-(void)override_viewWillLayoutSubviews
{
    [self override_viewWillLayoutSubviews];
    
    if (CGSizeEqualToSize(self.doneImageSize,CGSizeZero) == NO) {
        UIButton * _doneButton = [self valueForKey:@"_doneButton"];
        [_doneButton setEnlargeEdge:20];
        _doneButton.frame = CGRectMake(_doneButton.center.x - self.doneImageSize.width / 2.0 , _doneButton.center.y - self.doneImageSize.height / 2.0, self.doneImageSize.width, self.doneImageSize.height);
    }
    
    if (self.doneButtonClick != nil) {
        UIButton * _doneButton = [self valueForKey:@"_doneButton"];
        [_doneButton removeTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


- (NSInteger)imageCount
{
    NSMutableArray *_photos = [self valueForKey:@"_photos"];
    return _photos.count;
}

- (void)removeImageAtIndex:(NSInteger)index
{
    NSMutableArray *_photos = [self valueForKey:@"_photos"];
    UIScrollView *_pagingScrollView = [self valueForKey:@"_pagingScrollView"];
    [_photos removeObjectAtIndex:index];
    if (index == 0) {
        [self setValue:[[NSNumber alloc] initWithInteger:0] forKey:@"_currentPageIndex"];
        [self setValue:[[NSNumber alloc] initWithInteger:0] forKey:@"_initalPageIndex"];
    }else{
        [self setValue:[[NSNumber alloc] initWithInteger:index - 1] forKey:@"_currentPageIndex"];
        [self setValue:[[NSNumber alloc] initWithInteger:index - 1] forKey:@"_initalPageIndex"];
        
    }
    [_pagingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self reloadData];
}

- (void)doneClick:(id)sender
{
    UIButton * _doneButton = [self valueForKey:@"_doneButton"];
    if (_doneButton.hidden == NO && _doneButton.alpha > 0) {
        NSInteger _currentPageIndex = [[self valueForKey:@"_currentPageIndex"] integerValue];
        self.doneButtonClick(self,_currentPageIndex);
    }else{
        [self toggleControls];
    }
    
    
    
}

- (void)setSenderViewForAnimation:(UIView *)view
{
    CGRect frame  = [view.superview convertRect:view.frame toView:nil];
    [self setValue:view forKey:@"_senderViewForAnimation"];
    [self setValue:[NSValue valueWithCGRect:frame] forKey:@"_senderViewOriginalFrame"];
    
}

@end
