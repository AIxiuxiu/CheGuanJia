//
//  goHomeViewController.m
//  OuJia
//
//  Created by GuoZi on 15/11/23.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "goHomeViewController.h"
#import "ShopModel.h"
#define GET_ROUND Main_Ip"Organization.asmx/getDisDic"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
    BOOL _isShow;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface goHomeViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *_dataArr;
    BMKUserLocation *myLocation;
    BMKRouteSearch *_routesearch;
}

@end


@implementation goHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titLab.text = @"周边维修点";
    _isShow = YES;
    
    _mapDic = [[NSDictionary alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+(SCREEN_HEIHT-NAVHEIGHT)/2, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *lifeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 12, 100, 20)];
    lifeLab.text = @"选择维修点";
    lifeLab.backgroundColor = [UIColor clearColor];
    lifeLab.textAlignment = NSTextAlignmentCenter;
    lifeLab.textColor = [UIColor grayColor];
    lifeLab.font = [UIFont systemFontOfSize:15];
    [view addSubview:lifeLab];
    
    //左线
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMidY(lifeLab.frame), lifeLab.frame.origin.x-15, 0.5)];
    leftLine.backgroundColor = [UIColor grayColor];
    [view addSubview:leftLine];
    
    //右线
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lifeLab.frame), CGRectGetMidY(lifeLab.frame), lifeLab.frame.origin.x-15, 0.5)];
    rightLine.backgroundColor = [UIColor grayColor];
    [view addSubview:rightLine];
    
    [self.view addSubview:view];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+(SCREEN_HEIHT-NAVHEIGHT)/2+40, SCREEN_WIDTH, (SCREEN_HEIHT-NAVHEIGHT)/2-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    
    //地图页面
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, (SCREEN_HEIHT-NAVHEIGHT)/2)];
    //调节初始地图坐标
    _mapView.zoomLevel = 19;
    [self.view addSubview:_mapView];
    
    
    //放大
    UIButton *zoomBtn = [[UIButton alloc] init];
    zoomBtn.frame = CGRectMake(SCREEN_WIDTH -95, _mapView.frame.size.height-40+NAVHEIGHT, 30, 30);
    [zoomBtn setBackgroundImage:[UIImage imageNamed:@"ditu_fangda"] forState:UIControlStateNormal];
    [zoomBtn addTarget:self action:@selector(zoomMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoomBtn];
    //缩小
    UIButton *subBtn = [[UIButton alloc] init];
    subBtn.frame = CGRectMake(SCREEN_WIDTH -45, _mapView.frame.size.height-40+NAVHEIGHT, 30, 30);
    [subBtn setBackgroundImage:[UIImage imageNamed:@"ditu_suoxiao"] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(subMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subBtn];
    
    //定位
    _locService = [[BMKLocationService alloc] init];
    myLocation = [[BMKUserLocation alloc] init];
    _routesearch = [[BMKRouteSearch alloc]init];


    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    
    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _mapView = nil;
    _routesearch.delegate = nil; // 不用时，置nil
}


- (void)getPoint:(ShopModel *)aShop
{
    
 //   _mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [aShop.lat floatValue];
    coor.longitude = [aShop.lng floatValue];
    
    NSLog(@"%f,,,,%f",coor.latitude,coor.longitude);
    annotation.coordinate = coor;
    
    //中心位置显示
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.001, 0.001));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate: coor animated:YES];
}
#pragma mark 地图zoomlevel++
-(void)zoomMap
{
    _mapView.zoomLevel = _mapView.zoomLevel++;
}
//地图放大缩小
#pragma mark 地图ZoomLevel--
-(void)subMap
{
    _mapView.zoomLevel = _mapView.zoomLevel--;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region;
    
    region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.05, 0.05));//越小地图显示越详细
    [_mapView setRegion:region animated:YES];//执行设定显示范围
    
    region.center = coordinate;
    [_mapView setCenterCoordinate:coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    myLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    
    if (userLocation != nil&&!(userLocation.location.coordinate.latitude==0))
    {
        [_locService stopUserLocationService];
        
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];   //使地图移动到定位的地方
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:_mapView.centerCoordinate radius:500];
        [_mapView addOverlay:circle];
        
        [self getDataSource];
        
        NSLog(@"######%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//        [_locService stopUserLocationService];
    }
}

- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error＝＝＝%@",error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"查询中,请稍后";
    [HUD show:YES];
    
    NSDictionary *dic=@{@"lat":[NSString stringWithFormat:@"%f",myLocation.location.coordinate.latitude],@"lng":[NSString stringWithFormat:@"%f",myLocation.location.coordinate.longitude]};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_ROUND parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = [arr objectAtIndex:i];
                ShopModel *aShop = [ShopModel shopWithDict:dic];
                [_dataArr addObject:aShop];
                [self getPoint:aShop];
            }
            NSLog(@"_da==%@",_dataArr);
            [self.tableView reloadData];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
    
}
#pragma mark -tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ShopModel *aShop = [_dataArr objectAtIndex:indexPath.row];
    if (_dataArr) {
        
        cell.textLabel.text= [NSString stringWithFormat:@"%@",aShop.vname];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"联系电话:%@",aShop.phone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!!!!!!");
    CLLocationCoordinate2D coors[2] = {0};
    
    coors[0].latitude =myLocation.location.coordinate.latitude;
    coors[0].longitude =myLocation.location.coordinate.longitude;
    
    coors[1].latitude = latitude;
    coors[1].longitude = longitude;
    
//    [self searchWithDrive];
    ShopModel *aShop = [_dataArr objectAtIndex:indexPath.row];
    
    if (self.retrunBlock) {
        
        self.retrunBlock(aShop.vname);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
-(void)searchWithDrive
{
    CLLocationCoordinate2D coors[2] = {0};
    
    coors[0].latitude =myLocation.location.coordinate.latitude;
    coors[0].longitude =myLocation.location.coordinate.longitude;
    
    coors[1].latitude = latitude;
    coors[1].longitude = longitude;
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = coors[0];
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = coors[1];
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

//实现Deleage处理回调结果

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}


//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end