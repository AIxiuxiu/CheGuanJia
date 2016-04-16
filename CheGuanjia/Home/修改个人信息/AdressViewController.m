//
//  AdressViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/20.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "AdressViewController.h"
#import "AddressModel.h"
#import "UpdateInfoViewController.h"
#define GET_ADDRESS Main_Ip"address.asmx/find_c_guid"
#define ADD_ADDRESS Main_Ip"address.asmx/addnew"


@interface AdressViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AdressViewController
{
    NSMutableArray *_allAddressArr;
    UITableView *tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"我的地址";
    _allAddressArr = [[NSMutableArray alloc] init];
    
    tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    tableV.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableV];
    
    UIButton *bottonBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-40, SCREEN_WIDTH, 40)];
    bottonBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottonBtn];
    [bottonBtn addTarget:self action:@selector(addNewAdress) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imagV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, 5, 30, 30)];
    imagV.image = [UIImage imageNamed:@"add-shop-button_down"];
    [bottonBtn addSubview:imagV];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, 5, 120, 30)];
    lab.text = @"添加常用地址";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor grayColor];
    [bottonBtn addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [bottonBtn addSubview:line];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_allAddressArr removeAllObjects];
    [self getDataSource];
}
-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]};
    [manager POST:GET_ADDRESS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *addressArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<addressArr.count; i++) {
            AddressModel *adress = [[AddressModel alloc] initWithDict:[addressArr objectAtIndex:i]];
            [_allAddressArr addObject:adress];
        }
        
        [tableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
-(void)addNewAdress
{
    UpdateInfoViewController *update = [[UpdateInfoViewController alloc] init];
    [self.navigationController pushViewController:update animated:YES];
    update.titStr =@"添加地址信息";
    update.fromWhereStr = @"添加地址";
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    AddressModel *address = [_allAddressArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =address.address;
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _allAddressArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.fromStr isEqualToString:@"选择"]) {
        if (self.retrunBlock) {
            AddressModel *model = [_allAddressArr objectAtIndex:indexPath.row];

            self.retrunBlock(model.address);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        AddressModel *model = [_allAddressArr objectAtIndex:indexPath.row];
        UpdateInfoViewController *update = [[UpdateInfoViewController alloc] init];
        [self.navigationController pushViewController:update animated:YES];
        update.titStr =@"修改地址信息";
        update.fromWhereStr = @"修改地址";
        update.addressStr = model.address;
        update.addressIDStr = model.GUID;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
