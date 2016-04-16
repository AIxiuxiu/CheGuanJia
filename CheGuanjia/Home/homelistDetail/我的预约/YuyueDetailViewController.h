//
//  YuyueDetailViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/15.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "ReserveModel.h"

@interface YuyueDetailViewController : BaseViewController
@property (nonatomic,strong)ReserveModel *passReserve;
@property (nonatomic,strong)NSString *passStateStr;
@end
