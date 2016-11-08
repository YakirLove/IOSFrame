//
//  NDAsset.m
//  NDSDK
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDAsset.h"

@interface NDAsset (){
    ALAsset *_asset;
}

@end

@implementation NDAsset

-(id)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
    }
    return self;
}

- (NSString *)imageID
{
    return [[_asset defaultRepresentation] UTI];
}


- (NSURL *)assertUrl
{
    return [[_asset defaultRepresentation] url];
}

- (UIImage *)fullScreenImage
{
    CGImageRef ref = [[_asset defaultRepresentation] fullScreenImage];
    return [[UIImage alloc] initWithCGImage:ref];
}


- (UIImage *)thumbnailImage
{
    CGImageRef ref = [_asset aspectRatioThumbnail];
    return [[UIImage alloc] initWithCGImage:ref];
}



@end
