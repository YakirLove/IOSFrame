//
//  NDKeychain.m
//  Chat
//
//  Created by 网龙技术部 on 14-9-3.
//  Copyright (c) 2014年 吴焰基. All rights reserved.
//

#import "NDKeychain.h"

#define KEYCHAIN_STRING @"com.xingxiaoban.star"

@implementation NDKeychain

+ (id)defaultKeychain
{
    static NDKeychain *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}



-(BOOL)saveApnid:(NSString *)apn_id
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass, KEYCHAIN_STRING, (__bridge id)kSecAttrAccount,[apn_id dataUsingEncoding:NSUTF8StringEncoding], (__bridge id)kSecValueData, nil];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    return (status == errSecSuccess);
}

-(NSString *)getApnid
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                           KEYCHAIN_STRING, (__bridge id)kSecAttrAccount,
                           (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                           (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnData,
                           nil];
    CFTypeRef result = nil;
    OSStatus s = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
//    NSLog(@"select all : %d",s);
//    NSLog(@"%@",result);
    
    if (s == errSecSuccess && result != NULL)
    {
        NSDictionary *list = (__bridge_transfer NSDictionary *)result;
        NSData *data  = [list objectForKey:(__bridge id)kSecValueData];
        
        NSString *password = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
        if(password == nil)
        {
            password = [self generateImei];
            [self saveApnid:password];
        }
        return password;
    }
    else
    {
        NSString *string = [self generateImei];
        [self saveApnid:string];
        return string;
    }
    
    return nil;
}

//生成随即imei
-(NSString *)generateImei
{
    const int N = 12;
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"ios_"] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    
    return result;
}

@end
