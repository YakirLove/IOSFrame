//
//  NDAssetsGroup.m
//  NDSDK
//
//  Created by zhangx on 15/7/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDAssetsGroup.h"

@interface NDAssetsGroup()
{
    
}

@end

@implementation NDAssetsGroup

#pragma mark 初始化
-(id)initWithAssetsGroup:(ALAssetsGroup *)group
{
    self = [super init];
    if (self) {
        self.group = group;
    }
    return self;
}

#pragma mark 相册名称
- (NSString *)groupName
{
    NSString *groupName = [_group valueForProperty:ALAssetsGroupPropertyName];
    if ([@"Camera Roll" isEqualToString:groupName]) {
        groupName = @"相机胶卷";
    }
    return groupName;
}

#pragma mark 相册下的图片或者视频数
- (NSInteger)numberOfAssets
{
    return [_group numberOfAssets];
}

#pragma mark 缩略图
- (UIImage *)posterImage
{
    CGImageRef ref = [_group posterImage];
    return [[UIImage alloc] initWithCGImage:ref];
}

@end
