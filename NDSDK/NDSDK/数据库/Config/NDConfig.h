//
//  NDConfig.h
//  配置文件
//
//  Created by 陈峰 on 14-7-21.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NDDataFormat.h"
#import "NDDataBaseModel.h"

#define DB_KEY @"my_data_base"
#define DB_NEED_ENCODE 0 //数据库是否要加密

#define ND_NEED_SQL 0 //是否需要打印sql 1、需要 0、不需要

#define ND_DEBUG_LOG 1 //是否打印网盟日志

#define ND_NEED_ENCODE 1 //是否需要对敏感字段加密 1、需要 0、不需要

#if ND_DEBUG_LOG
#define DEBUG_LOG NSLog     //输出debug日志
#else
#define DEBUG_LOG(...) {}        //不输出debug日志
#endif



//数据库默认文件名
#define ND_DB_FILE_NANE @"NdDefaultDb"

