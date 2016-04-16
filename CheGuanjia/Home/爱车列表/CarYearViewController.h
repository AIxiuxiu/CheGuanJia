//
//  CarYearViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarTypeViewController.h"
#import "CarSeries.h"

@interface CarYearViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *topLab;
@property(nonatomic,strong)UIImageView *photoImg;
@property (nonatomic,strong)CarSeries *passCarSer;
@property(nonatomic,strong)NYCar *car;
@end
