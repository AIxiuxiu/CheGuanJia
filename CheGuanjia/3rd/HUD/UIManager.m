//
//  UIManager.m
//  JuNiuProject
//
//  Created by Andrew on 14/12/8.
//  Copyright (c) 2014年 Andrew. All rights reserved.
//

#import "UIManager.h"
#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"

@implementation UIManager
/*! MacBook Pro 2014-12-08 11:16 编辑
 *  @brief  弹出提示框
 *
 *  @param msg
 *  @param duration
 *
 *  @since <#version number#>
 */
+(void)showIndicator:(NSString *)msg duration:(float)duration{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:msg];
    
    double delayInSeconds =duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismiss];
    });
}

+(void)showIndicator:(NSString *)msg{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:msg];
}

+ (void)dismiss{
    [MMProgressHUD dismiss];
}

+(void)showMsgDuration:(NSString *)msg duration:(float)duration{
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:msg status:@""];
    [MMProgressHUD showWithStatus:msg];
    double delayInSeconds =duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismiss];
    });
}
//
///*!
// *  @brief  弹出提示框，提供标题和内容
// *  @param title 标题
// *  @param msg   内容
// *
// *  @since
// */
+(void)showIndicatorWithTitle:(NSString *)title message:(NSString *)msg{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:title status:msg];
}

+(void)showIndicatorWithTitle:(NSString *)title message:(NSString *)msg duration:(float)duration{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:title status:msg];
    
    
    double delayInSeconds =duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismiss];
    });
}
//
+(void)hiddenWithSuccess:(float)duration title:(NSString *)title{
    double delayInSeconds = duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismissWithSuccess:title];
    });
}

+(void)hiddenWithError:(float)duration title:(NSString *)title{
    double delayInSeconds = duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismissWithError:title];
    });
}



@end
