//
//  UIImage+Resource.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/9.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UIImage+Resource.h"

@implementation UIImage (Resource)

#pragma mark 本工程图片
+(UIImage *)imageInUIToolKitProject:(NSString *)name
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",NDUI_BUNDLE_NAME,name]];
}

-(CGSize)imageShowDesignSize
{
    CGSize size = self.size;
    if (self.scale==1.0) {
        size.width = self.size.width/3;
        size.height = self.size.height/3;
    }
    return size;
}

@end
