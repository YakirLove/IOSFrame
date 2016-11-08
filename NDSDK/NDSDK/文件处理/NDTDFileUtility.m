//
//  NDTDFileUtility.m
//  NDSDK
//
//  Created by 林 on 10/10/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import "NDTDFileUtility.h"
#include <sys/xattr.h>
#include <sys/stat.h>
#include <dirent.h>

@implementation NDTDFileUtility

//设置"do not back up"扩展属性,阻止iTunes或iCloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (NSString *)getDocumentPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)getLibraryPath
{
    NSString *path = NSHomeDirectory();
    NSString *libraryPath = [NSString stringWithFormat:@"%@/Library/Caches",path];
    return libraryPath;
}

+ (NSString *)createPath:(NSString *)filePath isLibraryPath:(BOOL)isLibraryPath
{
    return [NDTDFileUtility getPath:isLibraryPath fileName:filePath];
}

+(NSString *)getPath:(BOOL)isLibraryPath fileName:(NSString *)tFileName
{
    NSString *filePath = @"";
    if (isLibraryPath == YES) {
        filePath = [NSString stringWithFormat:@"%@/%@", [NDTDFileUtility getLibraryPath], tFileName];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@", [NDTDFileUtility getDocumentPath], tFileName];
    }
    if([tFileName rangeOfString:@"/"].length>0)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:[filePath stringByDeletingLastPathComponent]]){
            [fm createDirectoryAtPath:[filePath stringByDeletingLastPathComponent]
          withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
        }

    }
    
    return filePath;

}

//判断文件是否存在
+ (BOOL)isFileExist:(NSString*)tFileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:tFileName];
    BOOL iSFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return iSFile;
}

+ (BOOL)saveDictToFile:(NSDictionary *)dict fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:tFileName];
    BOOL isSave = [dict writeToFile:filePath atomically:YES];
    NSURL *dbURLPath = [NSURL URLWithString:filePath];
    [NDTDFileUtility addSkipBackupAttributeToItemAtURL:dbURLPath];
    return isSave;
}

//取本地保存的字典
+ (NSMutableDictionary *)readDictWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath
{
    NSMutableDictionary *localSettingDict = nil;
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:fileName];
    if ([NDTDFileUtility isFileExist:fileName isLibraryPath:isLibraryPath]) {
        localSettingDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        return localSettingDict;
    }
    return localSettingDict;
}

+ (BOOL)saveArrayToFile:(NSArray *)array fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:tFileName];
    BOOL isSave = [array writeToFile:filePath atomically:YES];
    NSURL *dbURLPath = [NSURL URLWithString:filePath];
    [NDTDFileUtility addSkipBackupAttributeToItemAtURL:dbURLPath];
    return isSave;
}

+ (NSArray *)readArrayWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:fileName];
    NSArray *localSettingArray = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        localSettingArray = [[NSArray alloc] initWithContentsOfFile:filePath];
        return localSettingArray;
    }
    return localSettingArray;
}

+ (BOOL)saveDataToFile:(NSData *)data fileName:(NSString *)tFileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:tFileName];
    BOOL isSave = [data writeToFile:filePath atomically:YES];
    NSURL *dbURLPath = [NSURL URLWithString:filePath];
    [NDTDFileUtility addSkipBackupAttributeToItemAtURL:dbURLPath];
    return isSave;
}

+ (NSData *)readDataWithFileName:(NSString *)fileName isLibraryPath:(BOOL)isLibraryPath
{
    NSString *filePath = [NDTDFileUtility getPath:isLibraryPath fileName:fileName];
    NSData *localSettingData = nil;
    if ([NDTDFileUtility isFileExist:filePath isLibraryPath:isLibraryPath]) {
        localSettingData = [[NSData alloc] initWithContentsOfFile:filePath];
        return localSettingData;
    }
    return localSettingData;
}

//文件的创建时间
+ (NSDate*)getFileCreateTime:(NSString*)filePath
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate *date = [fileAttributes objectForKey:NSFileCreationDate];
    //时间校正
    NSDate *date2=[date timeZoneCorrection:[date dateWithFormat:@""] format:@""];
    NSTimeInterval dateTime = [date2 timeIntervalSince1970];
    date = [NSDate dateWithTimeIntervalSince1970:dateTime];
    return date;
}

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

/**
 *  删除文件
 *
 *  @param filePath 文件地址
 */
+ (void)deleteFile:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        [manager removeItemAtPath:filePath error:nil];
    }
}



@end
