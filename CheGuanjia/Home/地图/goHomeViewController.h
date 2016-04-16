
//  BaiduMapViewController.h
//  OrderNet
//
//  Created by User on 6/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^CurrentCityBlock)(NSString *cityString);

@interface goHomeViewController : BaseViewController<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arry;
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    CurrentCityBlock currentCity;
    float latitude;
    float longitude;
}
typedef void (^Returnblock)(NSString *str);

@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)NSDictionary *mapDic;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) CLLocationManager* locationMgr;

@property (nonatomic, strong) Returnblock retrunBlock;

@property(nonatomic,strong) CLLocation *cl;
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
