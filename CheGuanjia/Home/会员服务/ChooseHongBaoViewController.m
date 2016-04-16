//
//  ChooseHongBaoViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
#import "ChooseHongBaoViewController.h"

@interface ChooseHongBaoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseHongBaoViewController
{
    UITableView *tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"选择优惠券";
    
    tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    tableV.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableV];
    
//    UIButton *bottonBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-40, SCREEN_WIDTH, 40)];
//    bottonBtn.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottonBtn];
//    [bottonBtn addTarget:self action:@selector(addNewAdress) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView * imagV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, 5, 30, 30)];
//    imagV.image = [UIImage imageNamed:@"add-shop-button_down"];
//    [bottonBtn addSubview:imagV];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, 5, 120, 30)];
//    lab.text = @"添加新车";
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.textColor = [UIColor grayColor];
//    [bottonBtn addSubview:lab];
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    line.backgroundColor = COLOR_LINE;
//    [bottonBtn addSubview:line];
}
-(void)addNewAdress
{

    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    HongbaoModel *aHongbao = [self.passHongArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@元优惠券",aHongbao.amount];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"过期时间:%@",aHongbao.enddate];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.passHongArr.count;
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
    
    if (self.Block) {
        HongbaoModel *model = [self.passHongArr objectAtIndex:indexPath.row];
        
        self.Block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

