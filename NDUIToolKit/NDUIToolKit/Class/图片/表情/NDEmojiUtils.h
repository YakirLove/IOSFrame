//
//  NDEmojiUtils.h
//  NDUIToolKit
//
//  Created by zhangx on 15/9/16.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDEmojiUtils : NSObject

/**
 *  编码带emoji的字符串
 *
 *  @param originStr 源字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString *)emojiEncode:(NSString *)originStr;


/**
 *  解码带emoji的字符串
 *
 *  @param decodedStr 编码后字符串
 *
 *  @return 解码后的字符串
 */
+ (NSString *)emojiDecode:(NSString *)decodedStr;



@end
