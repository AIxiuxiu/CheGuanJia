//
//  chooseCityViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "chooseCityViewController.h"
#define GET_CITY Main_Ip"city.asmx/find_all"
#import "AddressModel.h"

@interface chooseCityViewController ()

@end

@implementation chooseCityViewController
{
    NSMutableArray *_allCityArr;
}

- (void)getDataSource{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    
        
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:GET_CITY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i=0; i<carArr.count; i++) {
            NSDictionary *dic = [carArr objectAtIndex:i];
            AddressModel *aDdress = [[AddressModel alloc] initWithDict:dic];
            [_allCityArr addObject:aDdress];
        }
        [tableview reloadData];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titLab.text = @"选择城市";
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    _allCityArr = [[NSMutableArray alloc]init];
    [_allCityArr addObject:@"北京"];
    [_allCityArr addObject:@"天津"];
    [_allCityArr addObject:@"邯郸"];

    [self initTableView];
//    [self getDataSource];
    [self startLocation];
    
    
}
-(void)initTableView{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIHT-65)style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
}
#pragma mark--tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *cellID=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text=@"获取中...";
        cell.tag = 100;
        
        return cell;
        
    }else{
        static NSString *cellID=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[_allCityArr objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cityStr = cell.textLabel.text;
    NSArray *array = [cityStr componentsSeparatedByString:@"市"];
    NSString *city = [array firstObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"City"];
    
    if (self.retrunBlock) {
        self.retrunBlock(cityStr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:self];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15, 25)];
        lab.text = @"定位当前城市";
        [view addSubview:lab];
        return view;

    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15, 25)];
        lab.text = @"已开通服务城市";
        [view addSubview:lab];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _allCityArr.count;
    }
}
//开始定位
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            UITableViewCell *cell = [self.view viewWithTag:100];
            
            cell.textLabel.text = [test objectForKey:@"City"];
        }
    }];
    
}
-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

