//
//  ALAssetsLibraryRequest.h
//  NDSDK
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDAssetsLibraryRequestDelegate;

@interface NDAssetsLibraryRequest : NSObject

/**
 *  回调delegate
 */
@property(assign,nonatomic)id<NDAssetsLibraryRequestDelegate>delegate;

/**
 *  请求所有照片
 */
-(void)startRequestAllPhoto;


/**
 *  请求所有相册
 */
-(void)startRequestAllAlbum;

/**
 *  加载某个相册当中的图片
 *
 *  @param group 加载某个相册当中的图片
 */
-(void)startRequestPhotoInGroup:(NDAssetsGroup *)ndGroup;


@end

@protocol NDAssetsLibraryRequestDelegate <NSObject>


/**
 *  请求失败回调
 *
 *  @param errorMsg 请求失败回调
 */
-(void)loadPhotoFail:(NSString *)errorMsg;

@optional
/**
 *  请求所有照片成功回调
 *
 *  @param photoData 请求所有照片成功回调
 */
-(void)allPhotoDidLoad:(NSArray *)photoData;

/**
 *  请求某个相册照片成功回调
 *
 *  @param photoData 请求某个相册照片成功回调
 */
-(void)photoInGroupDidLoad:(NSArray *)photoData;


/**
 *  请求相册成功回调
 *
 *  @param albumData 请求相册成功回调
 */
-(void)allAlbumDidLoad:(NSArray *)albumData;

@end
