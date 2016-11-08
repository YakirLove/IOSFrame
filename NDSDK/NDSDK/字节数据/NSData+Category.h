//
//  NSData+Category.h
//  NDSDK
//
//  Created by zhangx on 15/9/16.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSData拓展
 */
@interface NSData (Category)

/**
 *  十六进制字符串转nsdata 例：@"FF60"->{0xFF,0x60}
 *
 *  @param str 十六进制字符串
 *
 *  @return nsdata
 */
+ (NSData *) stringToHexData:(NSString *)str;

@end
