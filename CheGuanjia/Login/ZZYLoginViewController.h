//
//  ZZYLoginViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 15/12/28.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZYLoginViewController : UIViewController
@property (nonatomic,strong)UITextField *userNameField;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UITextField *phoneNumField;
@property (nonatomic,strong)UITextField *yanzhengField;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,strong)NSString *loginStateStr;
@end
