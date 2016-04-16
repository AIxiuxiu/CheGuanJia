//
//  CarInfoViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "CarModel.h"
#import "CarSeries.h"
#import "CarYear.h"
#import "NYCar.h"

@interface CarInfoViewController : BaseViewController
@property (nonatomic,strong)CarYear *passCarYear;
@property (nonatomic,strong)CarSeries *secPassCarSer;
@property (nonatomic,strong)NYCar *car;
@property (nonatomic,strong)CarModel * passCarModel;
@end
