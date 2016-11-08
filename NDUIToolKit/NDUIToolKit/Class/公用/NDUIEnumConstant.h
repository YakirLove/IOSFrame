//
//  NDUIEnumConstant.h
//  NDUIToolKit
//
//  Created by zhangx on 15/8/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#ifndef NDUIEnumConstant_h
#define NDUIEnumConstant_h

///滤镜 START **********************************
typedef NS_ENUM(NSUInteger, NDUIFilterType) {
    NDUI_FILTER_TYPE_WU = 1,  ///< 无
//    NDUI_FILTER_TYPE_XIANDAI = 2,    ///< 现代
    NDUI_FILTER_TYPE_NAIXISE = 3,    ///< 奶昔色
//    NDUI_FILTER_TYPE_ROUHE = 4,    ///< 柔和
    NDUI_FILTER_TYPE_FEICUILV = 5,   ///< 翡翠绿
    NDUI_FILTER_TYPE_FUGU = 6,    ///< 复古
//    NDUI_FILTER_TYPE_XUANLI = 7,    ///< 炫丽
    NDUI_FILTER_TYPE_ZENGQIANG = 8,    ///< 增强
    NDUI_FILTER_TYPE_JINSE = 9,    ///< 金色
    NDUI_FILTER_TYPE_YANYANG = 10,    ///< 艳阳
    NDUI_FILTER_TYPE_MIHUANG = 11,    ///< 米黄
    NDUI_FILTER_TYPE_DENGGUANG = 12,  ///< 灯光
    NDUI_FILTER_TYPE_DUIBI = 13,  ///< 对比
    NDUI_FILTER_TYPE_TONGSE = 14,    ///< 铜色
    NDUI_FILTER_TYPE_DANYA = 15,  ///< 淡雅
    NDUI_FILTER_TYPE_GAOLIANG = 16,    ///< 高亮
//    NDUI_FILTER_TYPE_LENGSE = 17,    ///< 冷色
    NDUI_FILTER_TYPE_HEIBAI = 18,    ///< 黑白
};
///滤镜 END   **********************************

///工具栏状态 START **********************************
typedef NS_ENUM(NSUInteger, NDUIEditToolbarStatus) {
    NDUI_EDIT_TOOLBAR_STATUS_TEXT,  ///< 文本输入
    NDUI_EDIT_TOOLBAR_STATUS_HANDWRITE   ///< 手写
};
///工具栏状态 END   **********************************

#endif /* NDUIEnumConstant_h */
