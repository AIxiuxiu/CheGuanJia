//
//  SettingViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutAppViewController.h"
#import "SuggestionViewController.h"
#import "ZZYLoginViewController.h"
#import "newfeature.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"设置";
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT , SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 2){
        return 1;
    }else
    {
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.0;
    }else{
        return 15;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 80;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"关于车管家";
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.8)];
            line.backgroundColor = COLOR_LINE;
            [cell.contentView addSubview:line];
        }else{
            cell.textLabel.text = @"欢迎页";
        }
    }else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = 0;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-160, 50)];
        btn.backgroundColor = COLOR_NAVIVIEW;
        [btn setTitle:@"退出账号" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [cell.contentView addSubview:btn];
        [btn addTarget:self action:@selector(outMyInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AboutAppViewController *about = [[AboutAppViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            SuggestionViewController *suggest = [[SuggestionViewController alloc] init];
            [self.navigationController pushViewController:suggest animated:YES];
            
        }else{
            newfeature *nfc = [[newfeature alloc] init];
            nfc.whereStr = @"设置";
            [self presentViewController:nfc animated:YES completion:nil];

        }
    }else{
    
    }
}
-(void)outMyInfo
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否注销用户" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    [alert show];
}
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        /**
         *  注销用户
         */
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:nil forKey:@"c_id"];
        [def setObject:nil forKey:@"nickname"];
        [def setObject:nil forKey:@"photo"];
        [def setObject:nil forKey:@"phone"];
        
        [def setObject:nil forKey:@"defCarPhotoStr"];
        [def setObject:nil forKey:@"defCarGUIDStr"];
        [def setObject:nil forKey:@"defCarCGuidStr"];
        [def setObject:nil forKey:@"defCarbrandStr"];
        [def setObject:nil forKey:@"defCarseriesStr"];
        [def setObject:nil forKey:@"defCaryearStr"];
        [def setObject:nil forKey:@"defCarmodelStr"];
        [def setObject:nil forKey:@"defCarIDStr"];
        [def setObject:nil forKey:@"defCarFrameIDStr"];
        [def setObject:nil forKey:@"defCarMileageStr"];
        [def setObject:nil forKey:@"defCarBuytimeStr"];
        [def setObject:nil forKey:@"defCarMaintenanceMileageStr"];
        [def setObject:nil forKey:@"defCarMaintenanceTimeStr"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefCar" object:self];
        
//        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//        [def removePersistentDomainForName:appDomain];
        
        
        ZZYLoginViewController *login=[[ZZYLoginViewController alloc]init];
        login.loginStateStr = @"重新登录";
        [self presentViewController:login animated:YES completion:nil];
    
    }
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
