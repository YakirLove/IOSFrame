//
//  UMAccountInfo.h
//  NDSDK
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMAccountInfo : NSObject

@property (nonatomic ,strong) NSString *umengKey;
@property (nonatomic ,strong) NSString *wxAppId;
@property (nonatomic ,strong) NSString *wxAppSecret;
@property (nonatomic ,strong) NSString *qqAppId;
@property (nonatomic ,strong) NSString *qqAppSecret;
@property (nonatomic ,strong) NSString *sinaSSOUrl;
@property (nonatomic ,strong) NSString *shareUrl;
@property (nonatomic ,strong) NSString *sinaAppId;
@property (nonatomic ,strong) NSString *sinaAppSecret;

+(UMAccountInfo *)shareInstance;

@end
