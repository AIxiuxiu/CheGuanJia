//
//  RefusesViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"

@interface RefusesViewController : BaseViewController< UITextViewDelegate,UITextViewDelegate>

@property (strong, nonatomic)UITextView *textV;
@property (strong, nonatomic)UIButton *tijiaoBtn;
@property (strong, nonatomic)UILabel *numTextLab;
@property (strong, nonatomic)NSString *addressStr;
@property (strong, nonatomic)NSString *addressIDStr;
@end
