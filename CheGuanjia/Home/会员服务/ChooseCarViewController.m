//
//  ChooseCarViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/8.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

//
#import "ChooseCarViewController.h"
#import "ListCarModel.h"
#import "CarBrandViewController.h"
#define GET_CARLIST Main_Ip"mycar.asmx/find_c_guid"


@interface ChooseCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseCarViewController
{
    NSMutableArray *_allMycarArr;
    UITableView *tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"选择爱车";
    _allMycarArr = [[NSMutableArray alloc] init];
    
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
    lab.text = @"添加新车";
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
    [_allMycarArr removeAllObjects];
    [self getDataSource];
}
-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults]objectForKey:@"c_id"]};
    [manager POST:GET_CARLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<carArr.count; i++) {
            ListCarModel *aCar = [[ListCarModel alloc] initWithDict:[carArr objectAtIndex:i]];
            [_allMycarArr addObject:aCar];
        }
        
        [tableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)addNewAdress
{
    CarBrandViewController *add = [[CarBrandViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    ListCarModel *aCar = [_allMycarArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =aCar.carbrand;
    cell.detailTextLabel.text = aCar.licenseID;
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _allMycarArr.count;
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
    
        if (self.retrunBlock) {
            ListCarModel *model = [_allMycarArr objectAtIndex:indexPath.row];
            
            self.retrunBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
