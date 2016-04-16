//
//  CarTypeViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "NYCar.h"

@interface CarTypeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *topLab;
@property(nonatomic,strong)UIImageView *photoImg;
@property(nonatomic,strong)NYCar *car;
@end
