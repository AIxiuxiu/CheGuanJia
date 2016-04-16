//
//  MyCarListViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/5.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyCarListViewController.h"
#import "CarBrandViewController.h"
#import "MyCarTableViewCell.h"
#import "MyCarTableViewCell2.h"
#import "ListCarModel.h"
#import "CarListDetailViewController.h"

#define GET_MYCAR Main_Ip"MyCar.asmx/find_c_guid"
#define DEL_MYCAR Main_Ip"MyCar.asmx/delete"

@interface MyCarListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation MyCarListViewController
{
    NSMutableArray *_allCarModelArr;
    NSString *_delCarGUID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"爱车档案";
    _allCarModelArr = [[NSMutableArray alloc] init];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH- 90, 25, 80, 30);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"添加车辆" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(AddNewMyCar) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.fromWhereStr isEqualToString:@"侧边"]) {
        
        [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    }else if ([self.fromWhereStr isEqualToString:@"添加"]){
        self.leftBtn.hidden = YES;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
        [self.view addSubview:backBtn];
        UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 14, 20)];
        leftImgV.image = [UIImage imageNamed:@"fanhuibai"];
        [backBtn addSubview:leftImgV];
        [backBtn addTarget:self action:@selector(ToMainView) forControlEvents:UIControlEventTouchUpInside];
    }

    [self initMainTableView];
    [self getDataSource];
}
-(void)ToMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]};
    
    [manager POST:GET_MYCAR parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carListArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i = 0; i<carListArr.count; i++) {
            ListCarModel *listCar = [[ListCarModel alloc] initWithDict:[carListArr objectAtIndex:i]];
            [_allCarModelArr addObject:listCar];
        }
        [self.mainTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)delMyCar:(NSString *)CarID
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"删除中";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"guid":CarID};
    
    NSLog(@"dic===%@",dic);
    [manager POST:DEL_MYCAR parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *delState =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([delState intValue]==1) {
            
            [HUD hide:YES afterDelay:1];
            [_allCarModelArr removeAllObjects];
            [self getDataSource];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *defCarGUID = [def valueForKey:@"defCarGUIDStr"];
            if ([CarID isEqualToString:defCarGUID]) {
                [def setObject:@"" forKey:@"defCarPhotoStr"];
                [def setObject:@"" forKey:@"defCarGUIDStr"];
                [def setObject:@"" forKey:@"defCarCGuidStr"];
                [def setObject:@"" forKey:@"defCarbrandStr"];
                [def setObject:@"" forKey:@"defCarseriesStr"];
                [def setObject:@"" forKey:@"defCaryearStr"];
                [def setObject:@"" forKey:@"defCarmodelStr"];
                [def setObject:@"" forKey:@"defCarIDStr"];
                [def setObject:@"" forKey:@"defCarFrameIDStr"];
                [def setObject:@"" forKey:@"defCarMileageStr"];
                [def setObject:@"" forKey:@"defCarBuytimeStr"];
                [def setObject:@"" forKey:@"defCarMaintenanceMileageStr"];
                [def setObject:@"" forKey:@"defCarMaintenanceTimeStr"];
            }
            [self.mainTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)initMainTableView
{
    self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIHT-65)];
    self.mainTableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.mainTableView];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *defCarIDStr = [def valueForKey:@"defCarIDStr"];
    NSString *defCarbrandStr = [def valueForKey:@"defCarbrandStr"];
    NSString *defCarseriesStr = [def valueForKey:@"defCarseriesStr"];
    NSString *defCaryearStr = [def valueForKey:@"defCaryearStr"];
    NSString *defCarPhotoStr = [def valueForKey:@"defCarPhotoStr"];
    
    if (indexPath.section == 0) {

        static NSString *cellID=@"cellID";
        MyCarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if(cell==nil){
            cell=[[MyCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([defCarIDStr isEqualToString:@""]||!defCarIDStr) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.photoImg.image = [UIImage imageNamed:@"add_new"];
            cell.nameLab.text = @"   请选择默认车型";
            cell.nameLab.font = [UIFont systemFontOfSize:20];
            cell.chepaiLab.text = @"";
        }else{
            [cell.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,defCarPhotoStr]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
            cell.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@",defCarbrandStr,defCarseriesStr,defCaryearStr];
            cell.nameLab.font = [UIFont systemFontOfSize:18];
            cell.chepaiLab.text = [NSString stringWithFormat:@"%@",defCarIDStr];
        }
     
        return cell;
    }else{
        static NSString *cellID=@"cellID2";
        MyCarTableViewCell2 *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if(cell==nil){
            cell=[[MyCarTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ListCarModel *aCar = [_allCarModelArr objectAtIndex:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.defView.hidden = YES;
        if ([aCar.licenseID isEqualToString:defCarIDStr]) {
            cell.defView.hidden = NO;
        }
        
        [cell.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,aCar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@",aCar.carbrand,aCar.carseries,aCar.caryear];
        cell.chepaiLab.text = [NSString stringWithFormat:@"%@",aCar.licenseID];
        [cell.defBtn addTarget:self action:@selector(MakeDefCheXing:) forControlEvents:UIControlEventTouchUpInside];
        cell.defBtn.tag = indexPath.row +800;
        [cell.delBtn addTarget:self action:@selector(delCheXing:) forControlEvents:UIControlEventTouchUpInside];
        cell.delBtn.tag = indexPath.row +500;
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _allCarModelArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 15;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else
    {
        return 100;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else{
        
        CarListDetailViewController *detail = [[CarListDetailViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
        detail.passCar = [_allCarModelArr objectAtIndex:indexPath.row];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
    
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为默认车型" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            ListCarModel *aCar = [_allCarModelArr objectAtIndex:indexPath.row];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:aCar.photo forKey:@"defCarPhotoStr"];
            [def setObject:aCar.GUID forKey:@"defCarGUIDStr"];
            [def setObject:aCar.c_guid forKey:@"defCarCGuidStr"];
            [def setObject:aCar.carbrand forKey:@"defCarbrandStr"];
            [def setObject:aCar.carseries forKey:@"defCarseriesStr"];
            [def setObject:aCar.caryear forKey:@"defCaryearStr"];
            [def setObject:aCar.carmodel forKey:@"defCarmodelStr"];
            [def setObject:aCar.licenseID forKey:@"defCarIDStr"];
            [def setObject:aCar.frameID forKey:@"defCarFrameIDStr"];
            [def setObject:aCar.mileage forKey:@"defCarMileageStr"];
            [def setObject:aCar.buytime forKey:@"defCarBuytimeStr"];
            [def setObject:aCar.maintenanceMileage forKey:@"defCarMaintenanceMileageStr"];
            [def setObject:aCar.maintenanceTime forKey:@"defCarMaintenanceTimeStr"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefCar" object:self];

            [_mainTableView reloadData];
            
        }];
        editAction.backgroundColor = [UIColor orangeColor];
        
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除该车型"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            ListCarModel *aCar = [_allCarModelArr objectAtIndex:indexPath.row];
            _delCarGUID = aCar.GUID;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该车型及其相关信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction,editAction];
        
    }else{
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除默认车型"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"" forKey:@"defCarPhotoStr"];
            [def setObject:@"" forKey:@"defCarGUIDStr"];
            [def setObject:@"" forKey:@"defCarCGuidStr"];
            [def setObject:@"" forKey:@"defCarbrandStr"];
            [def setObject:@"" forKey:@"defCarseriesStr"];
            [def setObject:@"" forKey:@"defCaryearStr"];
            [def setObject:@"" forKey:@"defCarmodelStr"];
            [def setObject:@"" forKey:@"defCarIDStr"];
            [def setObject:@"" forKey:@"defCarFrameIDStr"];
            [def setObject:@"" forKey:@"defCarMileageStr"];
            [def setObject:@"" forKey:@"defCarBuytimeStr"];
            [def setObject:@"" forKey:@"defCarMaintenanceMileageStr"];
            [def setObject:@"" forKey:@"defCarMaintenanceTimeStr"];
            
            [_mainTableView reloadData];
            
            
        }];
        deleteAction.backgroundColor = [UIColor orangeColor];
        return @[deleteAction];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        [self delMyCar:_delCarGUID];
    }
}

-(void)MakeDefCheXing:(UIButton *)btn
{
    ListCarModel *aCar = [_allCarModelArr objectAtIndex:btn.tag-800];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:aCar.photo forKey:@"defCarPhotoStr"];
    [def setObject:aCar.GUID forKey:@"defCarGUIDStr"];
    [def setObject:aCar.c_guid forKey:@"defCarCGuidStr"];
    [def setObject:aCar.carbrand forKey:@"defCarbrandStr"];
    [def setObject:aCar.carseries forKey:@"defCarseriesStr"];
    [def setObject:aCar.caryear forKey:@"defCaryearStr"];
    [def setObject:aCar.carmodel forKey:@"defCarmodelStr"];
    [def setObject:aCar.licenseID forKey:@"defCarIDStr"];
    [def setObject:aCar.frameID forKey:@"defCarFrameIDStr"];
    [def setObject:aCar.mileage forKey:@"defCarMileageStr"];
    [def setObject:aCar.buytime forKey:@"defCarBuytimeStr"];
    [def setObject:aCar.maintenanceMileage forKey:@"defCarMaintenanceMileageStr"];
    [def setObject:aCar.maintenanceTime forKey:@"defCarMaintenanceTimeStr"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefCar" object:self];
    
    [_mainTableView reloadData];
}
-(void)delCheXing:(UIButton *)btn
{
    ListCarModel *aCar = [_allCarModelArr objectAtIndex:btn.tag-500];
    _delCarGUID = aCar.GUID;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该车型及其相关信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)AddNewMyCar
{
    CarBrandViewController *add = [[CarBrandViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
