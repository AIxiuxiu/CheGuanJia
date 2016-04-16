//
//  YuyueViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/5.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "YuyueViewController.h"
#import "YuyueTableViewCell.h"
#import "YuyueDetailViewController.h"
#import "yuyueTableViewCell1.h"
#import "yuyueTableViewCell2.h"
#import "ReserveModel.h"
#define USER_REPLY Main_Ip"Reserve.asmx/cFindReList"
#define REPLY Main_Ip"Reserve.asmx/confirmOrder"
#define CANCEL Main_Ip"Reserve.asmx/cancalReserve"


@interface YuyueViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation YuyueViewController
{
    UITableView *_tableView;
    UIView *_scrolline;
    NSMutableArray *_dataArr;
    UIAlertView *_alertV1;
    UIAlertView *_alertV2;
    UIAlertView *_alertV3;
    UIImageView *nodataImg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"受理中心";
    self.rightBtn.hidden = YES;
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    _dataArr = [[NSMutableArray alloc] init];
    _stateStr = @"未受理";
    
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
    NSString *StateStr;
    NSString *confirmStr;
    if ([_stateStr isEqualToString:@"未受理"]) {
        StateStr = @"0";
        confirmStr = @"0";
    }else if([_stateStr isEqualToString:@"维修中"]){
        StateStr = @"1";
        confirmStr = @"0";
    }else{
        StateStr = @"2";
        confirmStr = @"0";
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"查询中,请稍后";
    [HUD show:YES];
    
    NSDictionary *dic=@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"status":StateStr,@"confirm":confirmStr};
    NSLog(@"dic===%@",dic);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:USER_REPLY parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            for (int i=0; i<arr.count; i++)
            {
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
    
    
    [topView addSubview:_scrolline];
    
    
    float btnWidth = SCREEN_WIDTH/3;
    for (int i = 0; i<3; i++) {
        
        UIButton *unDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, 60)];
        unDoneBtn.backgroundColor = [UIColor clearColor];
        [unDoneBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        unDoneBtn.tag = 100+i;
        if(i==0){
            [unDoneBtn setTitle:@"未受理" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
        }else if(i==1){
            [unDoneBtn setTitle:@"维修中" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else{
            [unDoneBtn setTitle:@"已完成" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }
        [topView addSubview:unDoneBtn];
        
        UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-1, 15, 1, 30)];
        Yline.backgroundColor = [UIColor grayColor];
        [unDoneBtn addSubview:Yline];
    }
}

-(void)chooseBtnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            _stateStr = @"未受理";
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
                                 [_tableView reloadData];
                             }];
            
            
            break;
        }
            
        case 101:
        {
            _stateStr = @"维修中";
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
                                 
                                 [_tableView reloadData];
                                 
                             }];
        }
            
            break;
        case 102:
        {
            _stateStr = @"已完成";
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
                                 
                                 [_tableView reloadData];
                                 
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
    return 178;
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
    if ([_stateStr isEqualToString:@"未受理"]) {
        yuyueTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[yuyueTableViewCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.yanzhengmaLab.text = [NSString stringWithFormat:@"预约单验证码:%@",aReserve.validate];
        cell.allSerLab.text = aReserve.pname;
        cell.timeLab.text = [NSString stringWithFormat:@"预约时间:%@",aReserve.ReservetTime];
        [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.cancelBtn.tag = 2000+indexPath.row;

        return cell;
    }else if([_stateStr isEqualToString:@"维修中"]){
        
        YuyueTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[YuyueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.yanzhengmaLab.text = [NSString stringWithFormat:@"预约单验证码:%@",aReserve.validate];
        cell.allSerLab.text = aReserve.pname;
        cell.timeLab.text = [NSString stringWithFormat:@"受理时间:%@",aReserve.ReservetTime];
        return cell;
    }else{
        yuyueTableViewCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[yuyueTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
        cell.yanzhengmaLab.text = [NSString stringWithFormat:@"预约单验证码:%@",aReserve.validate];
        cell.allSerLab.text = aReserve.pname;
        cell.timeLab.text = [NSString stringWithFormat:@"完成时间:%@",aReserve.finishtime];
        [cell.goodBtn addTarget:self action:@selector(feelGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodBtn.tag = indexPath.row + 500;
        [cell.badBtn addTarget:self action:@selector(feelBadBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.badBtn.tag = indexPath.row +1000;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReserveModel *aReserve = [_dataArr objectAtIndex:indexPath.row];
    if ([_stateStr isEqualToString:@"未受理"])
    {
        YuyueDetailViewController *yuyueDetail = [[YuyueDetailViewController alloc] init];
        yuyueDetail.passReserve = aReserve;
        yuyueDetail.passStateStr = @"未受理";
        [self.navigationController pushViewController:yuyueDetail animated:YES];

    }else if ([_stateStr isEqualToString:@"维修中"])
    {
        YuyueDetailViewController *yuyueDetail = [[YuyueDetailViewController alloc] init];
        yuyueDetail.passReserve = aReserve;
        yuyueDetail.passStateStr = @"维修中";
        [self.navigationController pushViewController:yuyueDetail animated:YES];
    }else{
        YuyueDetailViewController *yuyueDetail = [[YuyueDetailViewController alloc] init];
        yuyueDetail.passReserve = aReserve;
        yuyueDetail.passStateStr = @"已完成";
        [self.navigationController pushViewController:yuyueDetail animated:YES];
    }
}
-(void)feelGoodBtn:(UIButton *)btn
{
    _alertV1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认满意该订单?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    _alertV1.tag = btn.tag + 100;
    [_alertV1 show];
}

-(void)feelBadBtn:(UIButton *)btn
{
    _alertV2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认不满意该订单?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    _alertV2.tag = btn.tag + 100;
    [_alertV2 show];
}

-(void)cancelBtnClick:(UIButton *)btn
{
    _alertV3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认取消该订单?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    _alertV3.tag = btn.tag + 100;
    [_alertV3 show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_alertV3 == alertView)
    {
        if (buttonIndex == 1)
        {
            ReserveModel *aReserve = [_dataArr objectAtIndex:alertView.tag-2100];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"取消中,请稍后";
            [HUD show:YES];
            
            NSDictionary *dic=@{@"guid":aReserve.GUID};
            NSLog(@"GUID===%@",aReserve.GUID);
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            
            manager.responseSerializer=[AFHTTPResponseSerializer serializer];
            
            [manager POST:CANCEL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([stateNum intValue]==1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消预定成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [_dataArr removeAllObjects];
                [self getDataSource];
                [HUD hide:YES];
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
                HUD.labelText =@"加载失败，请检查网络";
                //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
                [HUD hide:YES afterDelay:1.5];
            }];
        }
    }
    else
    {
        NSString *ridStr;
        NSString *confirmStr;

        if (_alertV1 == alertView) {
            if (buttonIndex == 1) {
                ReserveModel *aReserve = [_dataArr objectAtIndex:alertView.tag-600];
                ridStr = aReserve.GUID;
                confirmStr = @"1";
            }
        }else if (_alertV2 == alertView)
        {
            if (buttonIndex == 1) {
                ReserveModel *aReserve = [_dataArr objectAtIndex:alertView.tag-1100];
                ridStr = aReserve.GUID;
                confirmStr = @"2";
            }
        }
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"评价中,请稍后";
        [HUD show:YES];
        
        NSDictionary *dic=@{@"rid":ridStr,@"confirm":confirmStr};
        NSLog(@"rid===%@,com==%@",ridStr,confirmStr);
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        [manager POST:REPLY parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([stateNum intValue]==1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评价成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
            [_dataArr removeAllObjects];
            [self getDataSource];
            [HUD hide:YES];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
    }
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
