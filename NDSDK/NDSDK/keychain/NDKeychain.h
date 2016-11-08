//
//  NDKeychain.h
//  Chat
//
//  Created by 网龙技术部 on 14-9-3.
//  Copyright (c) 2014年 吴焰基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDKeychain : NSObject

+ (id)defaultKeychain;

-(BOOL)saveApnid:(NSString *)apn_id;

-(NSString *)getApnid;

@end
