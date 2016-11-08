//
//  NSString+NDJson.h
//  SystemJsonParse
//
//  Created by zhangx on 15/4/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NDJson_JsonParsing)

/**
 *  字符串转Json对象
 *
 *  @return Json对象
 */
- (id)JSONValue;

@end


@interface NSObject (NDJson_JsonWriting)

/**
 *  Json对象转字符串
 *
 *  @return Json 字符串
 */
- (NSString *)JSONRepresentation;

@end