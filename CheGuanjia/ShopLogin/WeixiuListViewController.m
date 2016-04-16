//
//  WeixiuListViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/10.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "WeixiuListViewController.h"
#import "wexiuTableViewCell.h"
#import "ReserveModel.h"
#import "weixiuDetailViewController.h"

#define GET_WEXIULIST Main_Ip"Reserve.asmx/shopReserveList"
#define COMPLETE_WEXIU Main_Ip"Reserve.asmx/finish"


@interface WeixiuListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation WeixiuListViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    UIImageView *nodataImg;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"维修列表";
    _dataArr = [[NSMutableArray alloc] init];
    self.rightBtn.hidden = YES;
    self.leftBtn.hidden = YES;
    UIButton *theleftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    theleftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
    [theleftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:theleftBtn];
    
    UIImageView *tleftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 14, 20)];
    tleftImgV.image = [UIImage imageNamed:@"fanhuibai"];
    [theleftBtn addSubview:tleftImgV];
    
    [self initTableView];
    
    nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-49.5, (SCREEN_HEIHT-NAVHEIGHT)/2+NAVHEIGHT-62.5, 99, 125)];
    nodataImg.image = [UIImage imageNamed:@"dataNo"];
    [self.view addSubview:nodataImg];
    
    [self getData];
}
-(void)Goback
{
    if([self.fromWhereStr isEqualToString:@"完成"])
    {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getData
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:GET_WEXIULIST parameters:@{@"shopid":@"DEE70E3F-AFB5-4671-9090-4BE0E9576D31"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i=0; i<carArr.count; i++) {
            NSDictionary *dic = [carArr objectAtIndex:i];
            ReserveModel *aReserve = [ReserveModel reserveWithDict:dic];
            [_dataArr addObject:aReserve];
        }
        
        if (!_dataArr.count==0)
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
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT) style:UITableViewStylePlain];
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
        return 225;
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
    wexiuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    if (!cell) {
        cell=[[wexiuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,aReserve.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    cell.nameLabel.text = aReserve.myName;
    cell.yanzhengLab.text = [NSString stringWithFormat:@"订单验证码:%@",aReserve.validate];
    cell.servLabel.text =[NSString stringWithFormat:@"服务项目:%@",aReserve.pname];
    cell.infoLabel.text = [NSString stringWithFormat:@"备注:%@",aReserve.Remark];
    cell.timeLabel.text = [NSString stringWithFormat:@"受理时间:%@",aReserve.accepteTime];
    [cell.btn1 addTarget:self action:@selector(completeService:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn1.tag = 100+indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
    weixiuDetailViewController *detail = [[weixiuDetailViewController alloc] init];
    detail.passYanzhengma = aReserve.validate;
    detail.orderStateStr = @"维修中";
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)completeService:(UIButton *)btn
{

    ReserveModel *aReserve = [_dataArr objectAtIndex:btn.tag-100];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    NSLog(@"guid===%@",aReserve.GUID);
    [manager POST:COMPLETE_WEXIU parameters:@{@"guid":aReserve.GUID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([stateNum intValue]==1) {
            HUD.labelText = @"您已成功确认维修完成";
            [_dataArr removeObjectAtIndex:btn.tag-100];
            [_tableView reloadData];
            [HUD hide:YES afterDelay:2];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
    
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


