//
//  ChooseHongBaoViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "HongbaoModel.h"

@interface ChooseHongBaoViewController : BaseViewController

typedef void (^HongBaoblock)(HongbaoModel *aHongbao);
@property (nonatomic, strong) NSMutableArray *passHongArr;
@property (nonatomic, strong) HongBaoblock Block;
@end