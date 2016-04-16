//
//  HomeListViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 15/12/31.
//  Copyright © 2015年 ChuMing. All rights reserved.



#import "HomeListViewController.h"
#import "chooseCityViewController.h"
#import "MyInfoViewController.h"
#import "InvMyFriendViewController.h"
#import "YouhuiQuanViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "BillViewController.h"
#import "YuyueViewController.h"
#import "MyCarListViewController.h"
#import "MemberViewController.h"
#import "CustomerModel.h"
#import "UIButton+AFNetworking.h"
#import "MyReserveViewController.h"

#define GET_MYINFO Main_Ip"customer.asmx/findByCid"



@interface HomeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIView *tableHeadView;

@end

@implementation HomeListViewController
{
    NSArray *photoArr;
    UIImageView *_headImg;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSource) name:@"changeMyInfo" object:nil];
    
    photoArr = @[@"wodedingdan",@"shoulizhongxin",@"huiyuanshangcheng",@"wodefuwu",@"wodeaiche",@"yaoqinghaoyou",@"youhuiicon",@"bangzhu"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, 250)];
    self.tableHeadView.backgroundColor = [UIColor whiteColor];
    
    NSString *cityStr;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"City"]) {
        cityStr = @"天津";
    }else{
        cityStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    }
    self.cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
    [self.cityBtn setTitle:[NSString stringWithFormat:@"%@∨",cityStr] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.tableHeadView addSubview:self.cityBtn];
    [self.cityBtn addTarget:self action:@selector(changeCityBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBtn.frame = CGRectMake(SCREEN_WIDTH/5*4/2-60, 60, 120, 120);
    self.headBtn.layer.cornerRadius = 60;
    self.headBtn.userInteractionEnabled = YES;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.headBtn.layer.borderWidth = 2;
    [self.headBtn addTarget:self action:@selector(gotoMyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeadView addSubview:self.headBtn];

    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*4/2-80, 200, 160, 20)];
    self.nameLab.text = @"账号";
    self.nameLab.textColor = [UIColor blackColor];
    self.nameLab.font = [UIFont systemFontOfSize:18];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    [self.tableHeadView addSubview:self.nameLab];
    
//    self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*4/2-80, 215, 160, 20)];
//    self.moneyLab.text = @"余额:￥0.00";
//    self.moneyLab.textColor = [UIColor grayColor];
//    self.moneyLab.font = [UIFont systemFontOfSize:17];
//    self.moneyLab.textAlignment = NSTextAlignmentCenter;
//    [self.tableHeadView addSubview:self.moneyLab];
    
    UITableView *tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*4, SCREEN_HEIHT)];
    tableV.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.tableHeaderView = self.tableHeadView;
    tableV.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableV];
    
    [self getDataSource];
    // Do any additional setup after loading the view.
}

- (void)getDataSource{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_MYINFO parameters:@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *cusInfoArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [cusInfoArr firstObject];
        CustomerModel *aCus = [CustomerModel customerWithDict:dic];
        
        self.nameLab.text = [NSString stringWithFormat:@"%@",aCus.nickname];
        
        [self.headBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Customer/%@",Main_Ip,aCus.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---城市切换
-(void)changeCityBtn
{
    chooseCityViewController *city=[[chooseCityViewController alloc]init];
    city.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:city animated:YES completion:nil];
    city.retrunBlock=^(NSString *str){
        [self.cityBtn setTitle:[NSString stringWithFormat:@"%@∨",str] forState:0];
        
    };

}
#pragma mark ---个人资料
-(void)gotoMyInfo
{
    MyInfoViewController *myInfo=[[MyInfoViewController alloc]init];
    myInfo.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myInfo];
    myInfo.navigationController.navigationBarHidden =YES;
    [self presentViewController:nav animated:YES completion:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        switch(indexPath.row){
            case 0:
            {
                cell.textLabel.text=@"我的订单";
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"受理中心";
            }
                break;
            case 2:
            {
                cell.textLabel.text=@"会员商城";
            }
                break;
            case 3:
            {
                cell.textLabel.text=@"我的服务";
            }
                break;
            case 4:
            {
                cell.textLabel.text=@"我的爱车";
            }
                break;
            case 5:
            {
                cell.textLabel.text=@"邀请好友";
            }
                break;
            case 6:
            {
                cell.textLabel.text=@"优惠券";
            }
                break;
            case 7:
            {
                cell.textLabel.text=@"帮助";
            }
                break;
                
            default:
                break;
        }
    }else
    {
        cell.textLabel.text=@"设置";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[photoArr objectAtIndex:indexPath.row]]];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"setting"];
    }
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIHT<600) {
        return 40;
    }else
    {
        return 45;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    }
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                BillViewController *bill=[[BillViewController alloc]init];
                bill.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bill];
                bill.navigationController.navigationBarHidden =YES;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 1:
            {
                YuyueViewController *yuyue=[[YuyueViewController alloc]init];
                yuyue.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:yuyue];
                yuyue.navigationController.navigationBarHidden =YES;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2:
            {
                MemberViewController *member=[[MemberViewController alloc]init];
                member.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:member];
                member.navigationController.navigationBarHidden =YES;
                member.fromWhereStr = @"侧边";
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 3:
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"]) {
                    MyReserveViewController *myReserve=[[MyReserveViewController alloc]init];
                    myReserve.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myReserve];
                    myReserve.navigationController.navigationBarHidden =YES;
                    [self presentViewController:nav animated:YES completion:nil];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置默认车型" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
                break;
            case 4:
            {
                MyCarListViewController *myCar=[[MyCarListViewController alloc]init];
                myCar.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myCar];
                myCar.navigationController.navigationBarHidden =YES;
                myCar.fromWhereStr = @"侧边";
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;

            case 5:
            {
                InvMyFriendViewController *InvFriend=[[InvMyFriendViewController alloc]init];
                InvFriend.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:InvFriend animated:YES completion:nil];
            }
                break;
            case 6:
            {
                YouhuiQuanViewController *youhui=[[YouhuiQuanViewController alloc]init];
                youhui.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:youhui animated:YES completion:nil];
            }
                break;
            case 7:
            {
                HelpViewController *help=[[HelpViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:help];
                help.navigationController.navigationBarHidden =YES;
                help.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }else
    {
        SettingViewController *setting=[[SettingViewController alloc]init];
        setting.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setting];
        setting.navigationController.navigationBarHidden =YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
