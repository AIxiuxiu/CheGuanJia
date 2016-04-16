//
//  YuyueViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/5.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "BillDetailViewController.h"
#import "OrderModel.h"
#import "product.h"

#define GET_ORDERLIST Main_Ip"pay.asmx/getOrderList"
#define GET_PRODUCT_DETAIL Main_Ip"product.asmx/getProduct"
@interface BillViewController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BillViewController
{
    UITableView *_tableView;
    UIView *_scrolline;
    NSMutableArray *_dataArr;
    UIImageView *nodataImg;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc] init];
    
    self.titLab.text = @"我的订单";
    self.rightBtn.hidden = YES;
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    _stateStr = @"全部";
    _scrolline = [[UIView alloc] initWithFrame:CGRectMake(10,55,SCREEN_WIDTH/3 -20,3)];
    _scrolline.backgroundColor = [UIColor redColor];
    _scrolline.layer.cornerRadius =3;
    
    [self initTopView];
    [self initTableView];
    
    nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-49.5, (SCREEN_HEIHT-NAVHEIGHT)/2+NAVHEIGHT-62.5, 99, 125)];
    nodataImg.image = [UIImage imageNamed:@"dataNo"];
    [self.view addSubview:nodataImg];
    
    [self getDataSource];
}

-(void)getDataSource
{
    [_dataArr removeAllObjects];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    
    NSDictionary *paraDic;
    
    if ([_stateStr isEqualToString:@"全部"]) {
        
        paraDic = @{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"status":@"2"};
        
    }else if ([_stateStr isEqualToString:@"待付款"])
    {
        paraDic = @{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"status":@"0"};
    }else
    {
        paraDic = @{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"status":@"1"};
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:GET_ORDERLIST parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *listArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i=0; i<listArr.count; i++) {
            
            NSDictionary *dic = [listArr objectAtIndex:i];
            OrderModel *aProduct = [OrderModel orderWithDict:dic];
            [_dataArr addObject:aProduct];
        }
        
        if (!(_dataArr.count==0))
        {
            nodataImg.hidden = YES;
        }else{
            nodataImg.hidden = NO;
        }
        [_tableView reloadData];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}

-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topView addSubview:line1];
    
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 60)];
    allBtn.backgroundColor = [UIColor clearColor];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    allBtn.tag = 99;
    [allBtn addTarget:self action:@selector(TwobtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:allBtn];
    
    [topView addSubview:_scrolline];
    
    UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 15, 1,30)];
    Yline.backgroundColor = [UIColor grayColor];
    [allBtn addSubview:Yline];
    
    float btnWidth = SCREEN_WIDTH/3;
    for (int i = 0; i<2; i++) {
        
        UIButton *unDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allBtn.frame)+btnWidth*i, 0, btnWidth, 60)];
        unDoneBtn.backgroundColor = [UIColor clearColor];
        [unDoneBtn addTarget:self action:@selector(TwobtnAction:) forControlEvents:UIControlEventTouchUpInside];
        unDoneBtn.tag = 100+i;
        if(i==0){
            [unDoneBtn setTitle:@"已付款" forState:UIControlStateNormal];
        }else{
            [unDoneBtn setTitle:@"待付款" forState:UIControlStateNormal];
        }
        [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topView addSubview:unDoneBtn];
        
        UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-1, 15, 1, 30)];
        Yline.backgroundColor = [UIColor grayColor];
        [unDoneBtn addSubview:Yline];
    }
}

-(void)TwobtnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            _stateStr = @"已付款";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3+10, 55, SCREEN_WIDTH/3 -20, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:99];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 [self getDataSource];
                                 
                             }completion:nil];
            
            
            break;
        }
            
        case 101:
        {
            _stateStr = @"待付款";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3*2, 55, SCREEN_WIDTH/3 -20, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:99];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];

                                 [self getDataSource];
                             }completion:nil];
        }
            
            break;
            
        case 99:
        {
            _stateStr = @"全部";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(10, 55, SCREEN_WIDTH/3-20, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:99];
                                 [btn3 setTitleColor:COLOR_RED forState:0];

                                 [self getDataSource];
                             }completion:nil];
        }

            
        default:
            break;
    }
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+60, SCREEN_WIDTH, SCREEN_HEIHT-60-NAVHEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置数据源
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    //加载上去
    [self.view addSubview:_tableView];
}

//返回表里应该有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return line2;
}
//设置单元格方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BillTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[BillTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    OrderModel *aOrder = [_dataArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@", aOrder.oid];
    cell.nameLab.text = aOrder.buyName;
    if ([aOrder.status isEqualToString:@"0"]) {
        cell.stateLab.text = @"待付款";
        cell.stateLab.textColor = COLOR_RED;
        cell.timeLab.text = [NSString stringWithFormat:@"订单生成时间:%@",aOrder.ordertime];
    }else{
        cell.stateLab.text = @"已付款";
        cell.stateLab.textColor = [UIColor greenColor];
        cell.timeLab.text = [NSString stringWithFormat:@"订单支付时间:%@",aOrder.paytime];
    }
    cell.detailLab.text = aOrder.buyIntro;
    
    [cell.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@photo/Product/%@",Main_Ip,aOrder.buyPhoto]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    
    float price = [aOrder.buyPrice floatValue];
    cell.priceLab.text = [NSString stringWithFormat:@"%0.2f元/年",price];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *aOrder = [_dataArr objectAtIndex:indexPath.row];
    BillDetailViewController *billDetail = [[BillDetailViewController alloc] init];
    [self.navigationController pushViewController:billDetail animated:YES];
    billDetail.passOrder = aOrder;
    
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

