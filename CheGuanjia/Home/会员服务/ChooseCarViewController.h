//
//  ChooseCarViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/8.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "ListCarModel.h"

typedef void (^CarListblock)(ListCarModel *aCar);

@interface ChooseCarViewController : BaseViewController
@property (nonatomic, strong) CarListblock retrunBlock;
@end
