//
//  NDBool.m
//  bool的对象型
//
//  Created by 陈峰 on 14-7-17.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDBool.h"

@implementation NDBool
@synthesize boolValue;

-(id)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        if ([@"0" isEqualToString:str]) {
            boolValue = NO;
        }else{
            boolValue = YES;
        }
    }
    return self;
}

-(id)initWithBool:(BOOL)bv
{
    self = [super init];
    if (self) {
        boolValue = bv;
    }
    return self;
}

-(int)intValue
{
    if(self.boolValue){
        return 1;
    }else{
        return 0;
    }
}


#pragma mark true
+(NDBool *)NDYES
{
#if __has_feature(objc_arc)
    NDBool *boolean = [[NDBool alloc] init];
#else
    NDBool *boolean = [[[NDBool alloc] init] autorelease];
#endif
    boolean.boolValue = YES;
    return boolean;
}

#pragma mark no
+(NDBool *)NDNO
{
#if __has_feature(objc_arc)
    NDBool *boolean = [[NDBool alloc] init];
#else
    NDBool *boolean = [[[NDBool alloc] init] autorelease];
#endif
    boolean.boolValue = NO;
    return boolean;
}

#pragma mark 打印值
-(NSString *)description
{
    return boolValue?@"YES":@"NO";
}

@end
