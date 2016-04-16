//
//  CarXingViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarTypeViewController.h"
#import "CarYear.h"

@interface CarXingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *topLab;
@property(nonatomic,strong)UIImageView *photoImg;
@property (nonatomic,strong)CarYear *passCarYear;
@property (nonatomic,strong)CarSeries *secPassCarSer;
@property(nonatomic,strong)NYCar *car;
@end
