//
//  NDPhotoData.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoData.h"
#import "NDPhotoFilterView.h"

@implementation NDPhotoData

-(instancetype)init
{
    self = [super init];
    if (self) {
        _cropFrame = CGRectZero;
        _angle = 0;
    }
    return self;
}


#pragma mark 要用来展示的图片
- (UIImage *)imageToShow
{
    if(self.orgImage != nil){
        return self.orgImage;
    }
    
    UIImage *org = nil;
    if ([NSString isEmptyString:self.localUrl]) {
        org = [_asset thumbnailImage];
    }else{
        org = [[UIImage alloc] initWithContentsOfFile:self.localUrl];
    }
    
    if (self.selecteFilter == nil && self.enableLux == NO) {
        return org;
    }
    
    if (self.enableLux) {
        if (self.selecteFilter == nil) {
            return [org imageWithContrast:1.05];
        }else{
            UIImage *tempImage = [UIImage imageWithFilterType:self.selecteFilter.filterType oriImage:org];
            return tempImage;
        }
    }
    
    return [UIImage imageWithFilterType:self.selecteFilter.filterType oriImage:org];
}

#pragma mark 处理过的图片
-(UIImage *)imageWithEdit
{
    UIImage *org =  [_asset thumbnailImage];
    
    if (self.selecteFilter == nil && self.enableLux == NO) {
        return org;
    }
    
    if (self.enableLux) {
        if (self.selecteFilter == nil) {
            return [org imageWithContrast:1.05];
        }else{
            UIImage *tempImage = [UIImage imageWithFilterType:self.selecteFilter.filterType oriImage:org];
            return tempImage;
        }
    }
    
    return [UIImage imageWithFilterType:self.selecteFilter.filterType oriImage:org];
}

#pragma mark 没有处理过的图片
-(UIImage *)imageWithoutEdit
{
    UIImage *org = nil;
    if ([NSString isEmptyString:self.localUrl]) {
        org = [_asset thumbnailImage];
    }else{
        org = [[UIImage alloc] initWithContentsOfFile:self.localUrl];
    }
    return org;
}

@end
