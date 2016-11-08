//
//  constant.h
//  NDUIToolKit
//
//  Created by zhangx on 15/7/9.
//  Copyright © 2015年 nd. All rights reserved.
//

#ifndef NDUIConstant_h
#define NDUIConstant_h


#endif /* NDUIConstant_h */


#define NDUI_BUNDLE_NAME @ "NDUIToolKitBundle.bundle"
#define NDUI_BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: NDUI_BUNDLE_NAME]
#define NDUI_BUNDLE [NSBundle bundleWithPath: NDUI_BUNDLE_PATH]

///常量 START **********************************
#define NDUI_NAV_BAR_HEIGHT 44 ///< 导航栏高度
#define NDUI_TOP_BAR_HEIGHT 64 ///< 顶部栏高度（状态栏+导航栏）
#define NDUI_TOOL_BAR_HEIGHT 44 ///< 工具栏高度
#define NDUI_LABEL_DEFUALT_FONT_SIZE 14.0f ///< label默认字体大小
#define NDUI_PHOTOBROWSE_TABLEVIEW_SPACE 3.0f ///< 图片间隔
#define NDUI_ROW_PHOTO_CNT 3 ///< 每一行图片数量
#define NDUI_ANIMATE_TIME 0.3 ///< 动画时间
#define NDUI_MAX_PHOTOS_PICKED 10 ///< 最多一次选中的图片数
#define NDUI_COLOR_IMAGE_WIDTH 7 ///< 颜色条宽度
#define NDUI_MAX_PEN_SIZE 40  ///< 最大画笔尺寸度
#define NDUI_COLOR_PANEL_WIDTH 30  ///< 颜色面板宽度
///常量 END   **********************************


///COLOR START **********************************
#define NDUI_SYSTEM_DEFUALT_FONT_COLOR @"#007BFF"  ///< 默认字体颜色
#define NDUI_SYSTEM_DEFUALT_FONT_HIGHLIGHT_COLOR @"#50007BFF"  ///< 默认字体高亮颜色
#define NDUI_SYSTEM_DEFUALT_FONT_DISABLE_COLOR @"#C3C3C3"  ///< 默认字体颜色不可用颜色
#define NDUI_MASK_COLOR @"#30222222"  ///< 遮罩颜色
#define NDUI_COLOR_F8F8F8 @"#F8F8F8"
#define NDUI_DEFAULT_BLUE_COLOR @"007AFF"  ///< 默认蓝色
///COLOR END   **********************************

///通知定义 START **********************************
#define ALBUMS_PHOTO_CHANGED @"ALBUMS_PHOTO_CHANGED"  ///< 相册图片修改
///通知定义 END   **********************************


///宏定义 START **********************************
#define NDUI_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width  ///< 屏幕宽度
#define NDUI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height  ///< 屏幕高度
#define NDUI_SCREEN_BOUNDS [UIScreen mainScreen].bounds.size.height  ///< 屏幕大小
///宏定义 END   **********************************

///宏方法 START **********************************
#define ALERT_MSG(title,msg)\
{\
UIAlertView*_alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
[_alert show];\
}  ///< 警告框

#define IPHONE4S ([[UIScreen mainScreen] currentMode].size.height < 961)?1:0

///宏方法 END   **********************************