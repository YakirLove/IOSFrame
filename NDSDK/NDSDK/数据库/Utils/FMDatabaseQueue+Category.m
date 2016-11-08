//
//  FMDatabaseQueue+Category.m
//  Demo
//
//  Created by zhangx on 15/7/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "FMDatabaseQueue+Category.h"
#import "FMDatabase.h"
#import "FMDatabase+Category.h"
/**
 *  增加加密功能的适配
 */
@implementation FMDatabaseQueue (Category)

-(FMDatabase *)queuedb
{
    return _db;
}


+ (void)load
{
    Class c = [FMDatabaseQueue class];
    AutoCloseSwizzle(c, @selector(initWithPath:flags:), @selector(override_initWithPath:flags:));
}


static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;
- (instancetype)override_initWithPath:(NSString*)aPath flags:(int)openFlags
{
    id idValue = [super init];
    
    if (idValue != nil) {
        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        FMDBRetain(_db);
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:openFlags];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"Could not create database queue for path %@", aPath);
            FMDBRelease(self);
            return 0x00;
        }
        _path = FMDBReturnRetained(aPath);
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        _openFlags = openFlags;
    }
    return idValue;
}
@end
