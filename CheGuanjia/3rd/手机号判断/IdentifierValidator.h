//
//  BasicModel.h
//  PuTaoShuPro
//
//  Created by sunwei on 15/3/24.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IdentifierValidator : NSObject
//mage旋转，而不是将imageView旋转，原理就是使用quartz2D来画图片，然后使用ctm变幻来实现旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
/**
 *  判断字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return yes/no
 */
+(BOOL) isBlankString:(NSString *)string ;

+(BOOL)isValidateEmail:(NSString *)email;
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
BOOL validateCarNo(NSString* carNo);
+(BOOL)isChinaUnicomPhoneNumber:(NSString*)phonenumber;

@end
