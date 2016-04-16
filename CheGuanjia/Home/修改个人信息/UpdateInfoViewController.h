//
//  UpdateInfoViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/19.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateInfoViewController : BaseViewController< UITextViewDelegate,UITextViewDelegate>

typedef void (^Returnblock)(NSString *str);

@property (nonatomic,strong)NSString *titStr;
@property (strong, nonatomic)UITextView *textV;
@property (strong, nonatomic)UIButton *tijiaoBtn;
@property (strong, nonatomic)UILabel *numTextLab;
@property (strong, nonatomic)NSString *fromWhereStr;
@property (strong, nonatomic)NSString *addressStr;
@property (strong, nonatomic)NSString *addressIDStr;
@property (nonatomic, strong) Returnblock retrunBlock;

@end