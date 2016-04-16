//
//  chooseCityViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//
//

#import "BaseViewController.h"
#import "UIAlertView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
typedef void (^Returnblock)(NSString *str);

@interface chooseCityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *tableview;
    NSArray *arryData;
}
@property (nonatomic, copy) Returnblock retrunBlock;
@property (nonatomic,strong) NSString *fromWhere;//接受从周边服务，还是我的社区传来判断字符串
@property (strong, nonatomic) CLLocationManager* locationManager;
@end
