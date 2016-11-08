//
//  UMShareData.m
//  NDSDK
//
//  Created by apple on 15/10/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UMShareData.h"

@implementation UMShareData

/**
 *  根据内容来初始化
 *
 *  @param content 内容
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content
{
    return [self initWithContent:content image:nil imageUrl:nil url:nil];
}

/**
 *  根据内容来初始化
 *
 *  @param content 内容
 *  @param url     要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content url:(NSString *)url
{
    return [self initWithContent:content image:nil imageUrl:nil url:url];
}


/**
 *  根据图片来初始化
 *
 *  @param imageUrl 图片地址
 *
 *  @return 对象
 */
-(id)initWithImageUrl:(NSString *)imageUrl
{
    return [self initWithContent:nil image:nil imageUrl:imageUrl url:nil];
}


/**
 *  根据图片来初始化
 *
 *  @param imageUrl 图片地址
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithImageUrl:(NSString *)imageUrl url:(NSString *)url
{
    return [self initWithContent:nil image:nil imageUrl:imageUrl url:url];
}


/**
 *  根据图片来初始化
 *
 *  @param image 图片
 *
 *  @return 对象
 */
-(id)initWithImage:(UIImage *)image
{
    return [self initWithContent:nil image:image imageUrl:nil url:nil];
}


/**
 *  根据图片来初始化
 *
 *  @param image 图片
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithImage:(UIImage *)image url:(NSString *)url
{
    return [self initWithContent:nil image:image imageUrl:nil url:url];
}

/**
 *  根据内容、图片来初始化
 *
 *  @param content 内容
 *  @param image 图片
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content image:(UIImage *)image url:(NSString *)url
{
    return [self initWithContent:content image:image imageUrl:nil url:url];
}



/**
 *  根据内容、图片来初始化
 *
 *  @param content   内容
 *  @param imageUrl  图片地址
 *  @param url       要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content imageUrl:(NSString *)imageUrl url:(NSString *)url
{
    return [self initWithContent:content image:nil imageUrl:imageUrl url:url];
}



-(id)initWithContent:(NSString *)content image:(UIImage *)image imageUrl:(NSString *)imageUrl url:(NSString *)url
{
    self = [super init];
    if (self) {
        self.content = content;
        self.image = image;
        self.imageUrl = imageUrl;
        self.url = url;
    }
    return self;
}

@end
