//
//  AdressViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/20.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"

@interface AdressViewController : BaseViewController

typedef void (^Returnblock)(NSString *str);

@property (nonatomic, strong) Returnblock retrunBlock;
@property (nonatomic, strong) NSString *fromStr;
@end
