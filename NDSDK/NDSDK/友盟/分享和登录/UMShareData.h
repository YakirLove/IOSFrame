//
//  UMShareData.h
//  NDSDK
//
//  Created by apple on 15/10/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMShareData : NSObject

@property(copy,nonatomic)NSString *title; ///< 标题

@property(copy,nonatomic)NSString *content; ///< 内容文本

@property(copy,nonatomic)NSString *url; ///< 网址

@property(retain,nonatomic)UIImage *image; ///< 图片数据

@property(copy,nonatomic)NSString *imageUrl;  ///< 图片地址

/**
 *  根据内容来初始化
 *
 *  @param content 内容
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content;

/**
 *  根据内容来初始化
 *
 *  @param content 内容
 *  @param url     要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content url:(NSString *)url;


/**
 *  根据图片来初始化
 *
 *  @param image 图片
 *
 *  @return 对象
 */
-(id)initWithImage:(UIImage *)image;


/**
 *  根据图片来初始化
 *
 *  @param image 图片
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithImage:(UIImage *)image url:(NSString *)url;

/**
 *  根据图片来初始化
 *
 *  @param imageUrl 图片地址
 *
 *  @return 对象
 */
-(id)initWithImageUrl:(NSString *)imageUrl;


/**
 *  根据图片来初始化
 *
 *  @param imageUrl 图片地址
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithImageUrl:(NSString *)imageUrl url:(NSString *)url;

/**
 *  根据内容、图片来初始化
 *
 *  @param content 内容
 *  @param image 图片
 *  @param url   要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content image:(UIImage *)image url:(NSString *)url;


/**
 *  根据内容、图片来初始化
 *
 *  @param content   内容
 *  @param imageUrl  图片地址
 *  @param url       要分享的地址
 *
 *  @return 对象
 */
-(id)initWithContent:(NSString *)content imageUrl:(NSString *)imageUrl url:(NSString *)url;

@end
