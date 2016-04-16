//
//  UIManager.h
//  JuNiuProject
//
//  Created by Andrew on 14/12/8.
//  Copyright (c) 2014年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIManager : NSObject
/*!
 *  @brief  弹出提示框，包含转子和内容
 *
 *  @param msg      内容
 *  @param duration 时间间隙
 *
 *  @since 
 */
+(void)showIndicator:(NSString *)msg duration:(float)duration;

/*!
 *  @brief  弹出提示，包含标题和内容
 *  @param title 标题
 *  @param msg   内容
 *
 *  @since <#version number#>
 */
+(void)showIndicatorWithTitle:(NSString *)title message:(NSString *)msg;

/*! MacBook Pro 2014-12-08 18:18 编辑
 *  @brief  提示消息
 *
 *  @param msg 消息内容
 *
 *  @since <#version number#>
 */
+(void)showIndicator:(NSString *)msg;
/*! MacBook Pro 2014-12-09 11:55 编辑
 *  @brief  弹出有时间限制的提示框
 *
 *  @param title    标题
 *  @param msg      内容
 *  @param duration 时间限制
 *
 *  @since <#version number#>
 */
+(void)showIndicatorWithTitle:(NSString *)title message:(NSString *)msg duration:(float)duration;

+(void)hiddenWithSuccess:(float)duration title:(NSString *)title;

+(void)hiddenWithError:(float)duration title:(NSString *)title;

+(void)showMsgDuration:(NSString *)msg duration:(float)duration;

+ (void)dismiss;
@end
