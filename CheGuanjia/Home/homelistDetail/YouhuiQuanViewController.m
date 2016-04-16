//
//  YouhuiQuanViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "YouhuiQuanViewController.h"
#import "YouhuiTableViewCell.h"
#import "HongbaoModel.h"
#define GET_MYTICKET Main_Ip"customer.asmx/selectTicket"


@interface YouhuiQuanViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation YouhuiQuanViewController
{
    UITextField *_duihuanTF;
    UITableView *_mainTableView;
    NSString *_stateStr;
    NSMutableArray *_dataArr;
    UIImageView *nodataImg;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"优惠券";
    _stateStr = @"未使用";
    _dataArr = [[NSMutableArray alloc] init];
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    [self initDuihuanView];
    
    [self getDataSource];
    
}
-(void)getDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    NSString *typeStr;
    if ([_stateStr isEqualToString:@"已过期"]) {
        typeStr = @"0";
    }else if ([_stateStr isEqualToString:@"已使用"]){
        typeStr = @"1";
    }else{
        typeStr = @"2";
    }
    
    [manager POST:GET_MYTICKET parameters:@{@"status":typeStr,@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i=0; i<carArr.count; i++) {
            NSDictionary *dic = [carArr objectAtIndex:i];
            HongbaoModel *aTicket = [HongbaoModel hongbaoWithDict:dic];
            [_dataArr addObject:aTicket];
        }
        if (!_dataArr.count==0)
        {
            nodataImg.hidden = YES;
        }else{
            nodataImg.hidden = NO;
        }
        [_mainTableView reloadData];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)initDuihuanView
{
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 55)];
//    topView.backgroundColor =[UIColor whiteColor];
//    [self.view addSubview:topView];
    
//    _duihuanTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 10,SCREEN_WIDTH/3*2-30 , 35)];
//    _duihuanTF.placeholder = @"兑换码换优惠券";
//    _duihuanTF.layer.borderWidth = 2;
//    _duihuanTF.layer.borderColor = COLOR_NAVIVIEW.CGColor;
//    _duihuanTF.layer.cornerRadius = 5;
//    _duihuanTF.layer.masksToBounds = YES;
//    _duihuanTF.delegate=self;
//    _duihuanTF.tag = 100;
//    _duihuanTF.backgroundColor=[UIColor clearColor];
//    _duihuanTF.borderStyle=UITextBorderStyleNone;
//    [topView addSubview:_duihuanTF];
//    _duihuanTF.leftViewMode = UITextFieldViewModeAlways;
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 55)];
//    _duihuanTF.leftView = view1;
//    
//    UIButton *duihuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+10, 10, SCREEN_WIDTH/3-30, 35)];
//    duihuanBtn.backgroundColor = COLOR_NAVIVIEW;
//    [duihuanBtn setTitle:@"兑换" forState:UIControlStateNormal];
//    [duihuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    duihuanBtn.layer.cornerRadius = 5;
//    duihuanBtn.layer.masksToBounds = YES;
//    duihuanBtn.layer.borderWidth = 1;
//    duihuanBtn.layer.borderColor = COLOR_NAVIVIEW.CGColor;
//    [duihuanBtn addTarget:self action:@selector(duihuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:duihuanBtn];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"未使用",@"已使用",@"已过期",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.frame = CGRectMake(30,NAVHEIGHT+10,SCREEN_WIDTH-60,30);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = COLOR_NAVIVIEW;
    [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentedControl.frame)+10 , SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT-55)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
    
    nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-49.5, (SCREEN_HEIHT-CGRectGetMaxY(segmentedControl.frame)-10)/2+CGRectGetMaxY(segmentedControl.frame)+10-62.5, 99, 125)];
    nodataImg.image = [UIImage imageNamed:@"dataNo"];
    [self.view addSubview:nodataImg];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    YouhuiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[YouhuiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    HongbaoModel *aTicket = [_dataArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",aTicket.amount];
    cell.TimeLab.text = [NSString stringWithFormat:@"过期时间:%@",aTicket.enddate];
    if ([_stateStr isEqualToString:@"已过期"]) {
        cell.bgImgV.image = [UIImage imageNamed:@"beijing2"];
    }else if ([_stateStr isEqualToString:@"已使用"]){
        cell.bgImgV.image = [UIImage imageNamed:@"beijing3"];
    }
    return cell;
}

-(void)segmentValueChanged:(UISegmentedControl *)segment{
    NSInteger selected=segment.selectedSegmentIndex;
    switch (selected) {
        case 0:
        {
            _stateStr = @"未使用";
            [_dataArr removeAllObjects];
            [self getDataSource];
            break;
        }
        case 1:
        {
            _stateStr = @"已使用";
            [_dataArr removeAllObjects];
            [self getDataSource];
            break;
        }
        case 2:
        {
            _stateStr = @"已过期";
            [_dataArr removeAllObjects];
            [self getDataSource];
            break;
        }
        default:
            break;
    }
}
#pragma mark
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    [textField resignFirstResponder];
    return YES;
}
-(void)duihuanBtnClick
{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"查询中,请稍后";
//    [HUD show:YES];
//    
//    NSDictionary *dic=@{@"GZID":self.shopIDField.text,@"username":self.userNameField.text,@"password":self.passwordField.text};
//    NSLog(@"dic===%@",dic);
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    
//    [manager POST:SHOP_LOG_IN parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"!!!!!");
//        
//        if ([responseObject isKindOfClass:[NSData class]]) {
//            
//            HUD.labelText = @"登陆成功";
//            [HUD hide:YES afterDelay:1];
//            
//            //                NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            //
//            //                NSLog(@"dic==%@",[arr firstObject]);
//            //
//            //                NSDictionary *dic = [[NSDictionary alloc] init];
//            //                dic = [arr firstObject];
//            //
//            //                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//            //                [def setObject:dic[@"GUID"] forKey:@"c_id"];
//            //                [def setObject:dic[@"photo"] forKey:@"photo"];
//            //                [def setObject:dic[@"phone"] forKey:@"phone"];
//            
//            
//            
//            ShopHomeViewController *shopHome = [[ShopHomeViewController alloc] init];
//            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopHome];
//            nav.navigationBarHidden = YES;
//            [UIApplication sharedApplication].keyWindow.rootViewController=nav;
//            
//            
//            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
//            
//            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
//        }
//    }
//     
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"%@",error);
//          }];
}

-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
