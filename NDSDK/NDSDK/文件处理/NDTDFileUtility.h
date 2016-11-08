//
//  NDTDFileUtility.h
//  NDSDK
//
//  Created by 林 on 10/10/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
          用户生成的文件放在documents，自己的文件放在library里面

 简单的说明：如果你做个记事本的app，那么用户写了东西，总要把东西存起来。那么这个文件则是用户自行生成的，就放在documents文件夹里面。
 
 如果你有一个app，需要和服务器配合，经常从服务器下载东西，展示给用户看。那么这些下载下来的东西就放在library/cache。
 
 apple对这个很严格，放错了就会被拒。主要原因是ios的icloud的同步问题。
 
 */


@interface NDTDFileUtility : NSObject

//设置"do not back up"扩展属性,阻止iTunes或iCloud备份,没设置这个app store上不了
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//获取tDocument目录，用户生成的文件放在此目录,区别请看上面说明
+ (NSString *)getDocumentPath;

//获取Library目录，应用生成文件的放在此目录,区别请看上面说明
+ (NSString *)getLibraryPath;

/**
 *  创建文件夹路径
 *
 *  @param filePath      创建文件路径 如:tempImage/image/...
 *  @param isLibraryPath 是否在Library目录中创建,yes:在Library目录中创建，no:在Document目录创建
 *
 *  @return 返回创建的路径
 */
+ (NSString *)createPath:(NSString *)filePath isLibraryPath:(BOOL)isLibraryPath;

/**
 *  判断文件是否存在
 *
 *  @param tFileName     目标文件
 *  @param isLibraryPath 是否在Library目录检查,yes:检查Library目录，no:检查Document目录
 *
 *  @return 返回结果
 */
+ (BOOL)isFileExist:(NSString*)tFileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  保存字典到本地
 *
 *  @param dict          需要保存的数据
 *  @param tFileName     保存的文件名
 *  @param isLibraryPath 是否保存到Library目录，yes:保存到Library目录，no:保存到Document目录
    @return 返回是否保存成功
 */
+ (BOOL)saveDictToFile:(NSDictionary *)dict fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  取指定目录保存的字典
 *
 *  @param fileName      目标文件名
 *  @param isLibraryPath yes:在Library目录文件中获取，no:在Document目录文件中获取
 *
 *  @return 返回数据
 */
+ (NSMutableDictionary *)readDictWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  保存数组到本地
 *
 *  @param array         需要保存的数据
 *  @param tFileName     保存的文件名
 *  @param isLibraryPath 是否保存到Library目录，yes:保存到Library目录，no:保存到Document目录
    @return 返回是否保存成功
 */
+ (BOOL)saveArrayToFile:(NSArray *)array fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  取指定目录保存的数组
 *
 *  @param fileName      目标文件名称
 *  @param isLibraryPath isLibraryPath yes:在Library目录文件中获取，no:在Document目录文件中获取
 *
 *  @return 返回取到的数据
 */
+ (NSArray *)readArrayWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  保存二进制流到本地，可保存图片，字符串等
 *
 *  @param data          需要保存的数据
 *  @param tFileName     保存到的文件名
 *  @param isLibraryPath 是否保存到Library目录，yes:保存到Library目录，no:保存到Document目录
 *
 *  @return  返回是否保存成功
 */
+ (BOOL)saveDataToFile:(NSData *)data fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath;

/**
 *  取指定目录保存的二进制流
 *
 *  @param fileName      目标文件
 *  @param isLibraryPath isLibraryPath yes:在Library目录文件中获取，no:在Document目录文件中获取
 *
 *  @return 返回数据
 */
+ (NSData *)readDataWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath;

//获取文件创建时间
+ (NSDate*)getFileCreateTime:(NSString*)filePath;

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath;
// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath;

/**
 *  删除文件
 *
 *  @param filePath 文件地址
 */
+ (void)deleteFile:(NSString *)filePath;

@end
