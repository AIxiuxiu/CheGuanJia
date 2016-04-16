//
//  ReplyViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/10.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ReplyViewController.h"

#import "YuyueDetailViewController.h"
#import "ShopYuYueViewController.h"
#import "YuYueTableViewCell1.h"
#import "YuYueTableViewCell2.h"
#import "YuYueTableViewCell3.h"
#import "SureServiceViewController.h"
#import "RefusesViewController.h"
#import "ReserveModel.h"
#import "weixiuDetailViewController.h"
#define GET_REPLYLIST Main_Ip"Reserve.asmx/oFindReList"

@interface ReplyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ReplyViewController
{
    UITableView *_tableView;
    UIView *_scrolline;
    NSMutableArray *_dataArr;
    UIImageView *nodataImg;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"订单反馈";
    _dataArr = [[NSMutableArray alloc] init];
    self.rightBtn.hidden = YES;
    
    _stateStr = @"待确认";

    _scrolline = [[UIView alloc] init];
    _scrolline.frame = CGRectMake(20, 55, SCREEN_WIDTH/3-40, 3);
    _scrolline.backgroundColor = [UIColor redColor];
    _scrolline.layer.cornerRadius =3;
    
    [self initTopView];
    [self initTableView];
    
    nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-49.5, (SCREEN_HEIHT-NAVHEIGHT-60)/2+NAVHEIGHT+60-62.5, 99, 125)];
    nodataImg.image = [UIImage imageNamed:@"dataNo"];
    [self.view addSubview:nodataImg];
    
    [self getDataSource];
}
-(void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topView addSubview:line1];
    
    
    [topView addSubview:_scrolline];
    
    
    float btnWidth = SCREEN_WIDTH/3;
    for (int i = 0; i<3; i++) {
        
        UIButton *unDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, 60)];
        unDoneBtn.backgroundColor = [UIColor clearColor];
        [unDoneBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        unDoneBtn.tag = 100+i;
        if(i==0){
            [unDoneBtn setTitle:@"待确认" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
        }else if(i==1){
            [unDoneBtn setTitle:@"满意" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else{
            [unDoneBtn setTitle:@"不满意" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }
        [topView addSubview:unDoneBtn];
        
        UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-1, 15, 1, 30)];
        Yline.backgroundColor = [UIColor grayColor];
        [unDoneBtn addSubview:Yline];
    }
}
-(void)getDataSource
{
    NSString *typeState;
    if ([_stateStr isEqualToString:@"待确认"]) {
        typeState = @"0";
    }else if([_stateStr isEqualToString:@"满意"]){
        typeState = @"1";
    }else{
        typeState = @"2";
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"查询中,请稍后";
    [HUD show:YES];
    
    NSDictionary *dic=@{@"Shopid":[[NSUserDefaults standardUserDefaults] objectForKey:@"o_guid"],@"status":@"2",@"confirm":typeState};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_REPLYLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            for (int i=0; i<arr.count; i++) {
                
                NSDictionary *dic = [arr objectAtIndex:i];
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
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)chooseBtnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            _stateStr = @"待确认";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(20, 55, SCREEN_WIDTH/3-40, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:102];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                  [_dataArr removeAllObjects];
                                  [self getDataSource];
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            
            
            break;
        }
            
        case 101:
        {
            _stateStr = @"满意";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3+20, 55, SCREEN_WIDTH/3-40, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:102];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                  [_dataArr removeAllObjects];
                                  [self getDataSource];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
            
            break;
        case 102:
        {
            _stateStr = @"不满意";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3*2+20, 55, SCREEN_WIDTH/3-40, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:102];
                                 [btn2 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:101];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 [_dataArr removeAllObjects];
                                 [self getDataSource];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
            
            break;
            
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
    if ([_stateStr isEqualToString:@"待确认"]) {
        YuYueTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,aReserve.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.nameLabel.text = aReserve.vname;
        cell.yanzhengLab.text = [NSString stringWithFormat:@"订单验证码:%@",aReserve.validate];
        cell.servLabel.text =[NSString stringWithFormat:@"服务项目:%@",aReserve.pname];
        cell.infoLabel.text = [NSString stringWithFormat:@"备注:%@",aReserve.Remark];
        cell.timeLabel.text = [NSString stringWithFormat:@"维修完成时间:%@",aReserve.finishtime];
        [cell.btn1 addTarget:self action:@selector(makeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn1.tag = 100+indexPath.row;
        
        return cell;
    }else if ([_stateStr isEqualToString:@"满意"]){
        YuYueTableViewCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,aReserve.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.nameLabel.text = aReserve.myName;
        cell.yanzhengLab.text = [NSString stringWithFormat:@"订单验证码:%@",aReserve.validate];
        cell.servLabel.text =[NSString stringWithFormat:@"服务项目:%@",aReserve.pname];
        cell.infoLabel.text = [NSString stringWithFormat:@"备注:%@",aReserve.Remark];
        cell.timeLabel.text = [NSString stringWithFormat:@"维修完成时间:%@",aReserve.finishtime];
        
        return cell;
    }else{
        YuYueTableViewCell3 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,aReserve.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.nameLabel.text = aReserve.myName;
        cell.yanzhengLab.text = [NSString stringWithFormat:@"订单验证码:%@",aReserve.validate];
        cell.servLabel.text =[NSString stringWithFormat:@"服务项目:%@",aReserve.pname];
        cell.infoLabel.text = [NSString stringWithFormat:@"备注:%@",aReserve.Remark];
        cell.timeLabel.text = [NSString stringWithFormat:@"维修完成时间:%@",aReserve.finishtime];
        [cell.btn1 addTarget:self action:@selector(makeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn1.tag = 100+indexPath.row;
        return cell;
    }
    
}

-(void)makeCallBtn:(UIButton *)btn
{
    ReserveModel *aReserve = [_dataArr objectAtIndex:btn.tag-100];
    NSString *number = aReserve.phone;
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
    weixiuDetailViewController *detail = [[weixiuDetailViewController alloc] init];
    detail.passYanzhengma = aReserve.validate;
    NSString *typeState;
    if ([_stateStr isEqualToString:@"待确认"]) {
        typeState = @"待确认";
    }else if([_stateStr isEqualToString:@"满意"]){
        typeState = @"满意";
    }else{
        typeState = @"不满意";
    }
    detail.orderStateStr = typeState;
    [self.navigationController pushViewController:detail animated:YES];
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

