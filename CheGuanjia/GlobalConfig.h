//
//  GlobalConfig.h
//  PuTaoShuPro
//
//  Created by sunwei on 15/3/10.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#ifndef PuTaoShuPro_GlobalConfig_h

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : 0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : 0)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : 0)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIHT [[UIScreen mainScreen] bounds].size.height

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define NAVHEIGHT 64
#define TABBAR_HEIGHT 50
#define BANNER_HEIGHT (SCREEN_HEIHT-TABBAR_HEIGHT-64)/4

//===============颜色宏定义=================(237, 65, 53)
#define COLOR_BGCOLOR_BLUE RGBACOLOR(21, 149, 254, 1)
#define COLOR_LINE RGBACOLOR( 230, 230, 230, 1)
#define COLOR_NAVIVIEW RGBACOLOR(21, 149, 254, 1)
#define COLOR_RED RGBACOLOR(237, 65, 53, 1)
#define COLOR_BLACK RGBACOLOR(60, 65, 69, 1)
//提示消息
//#define MSG_SERVER_ERROR @"服务器正忙,请您稍后再试!"
#define MSG_LOADING @"Loading..."
//#define MSG_NOMOREDATA @"没有更多数据了!"

#pragma mark--服务器接口地址
//ip
#define Main_Ip @"http://114.113.234.38:8080/"
//http://192.168.0.6:80/
//http://114.113.234.38:8080/
#endif
