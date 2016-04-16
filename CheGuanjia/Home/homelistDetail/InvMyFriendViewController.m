//
//  InvMyFriendViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "InvMyFriendViewController.h"

#import "SDWebImageManager.h"
#import "UIButton+FUNButtonBlock.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "CustomerModel.h"

#define APP_SHARE_URL @"https://www.pgyer.com/fwBV?sig=cKClK6T8oTL7h3kppSz0Wo0jmcHWsXRKJNRYyQY0ZYAT%2FFXFlh5KcP6cgoKQ6%2B2W"
//友盟分享
#define UM_QQ_APPID @"1105262040"
#define UM_QQ_APPSECRET @"YVsqMFzYAX7H8F53"

#define UM_WX_APPID @"wxddb7b1f8967dd93d"
#define UM_WX_APPSECRET @"00e35f9d919dc98087c4947f73355b77"

#define APP_DOWNLOAD_URL APP_SHARE_URL

#define GET_MYINV Main_Ip"customer.asmx/getInvite"
#define ADD_OTHERINV Main_Ip"customer.asmx/addInvite"
#define GET_INVLIST Main_Ip"customer.asmx/myInviteList"

@interface InvMyFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSMutableArray *arrFriendsInfo;
    NSString *strMyInvieCode;
    UILabel *myShareLab;
    UITextField *maTF;
    UIButton *bangBtn;
    NSMutableArray *_listArr;
}
@property (strong, nonatomic)UITableView *tableViewMain;
@property (strong, nonatomic)UIButton *btShareApp;
@property (strong, nonatomic)UILabel *lbMyInviteCode;
@property (strong, nonatomic)UIView *tableHeadView;


@end

@implementation InvMyFriendViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"邀请好友";
    _listArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, (SCREEN_HEIHT-NAVHEIGHT)/2)];
    self.tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT) style:UITableViewStyleGrouped];
    self.tableViewMain.delegate=self;
    self.tableViewMain.dataSource=self;
    self.tableViewMain.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableViewMain];
    self.tableViewMain.tableHeaderView = self.tableHeadView;
    _tableViewMain.tableFooterView = [UIView new];
    
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, (SCREEN_HEIHT-NAVHEIGHT)/2-40)];
    bgImg.image = [UIImage imageNamed:@"yaoBg"];
    bgImg.userInteractionEnabled = YES;
    [self.tableHeadView addSubview:bgImg];
    
    UIImageView *maImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 60, 40, 40)];
    if (iPhone5) {
        maImg.frame = CGRectMake(20, 60, 30, 30);
    }
    maImg.image = [UIImage imageNamed:@"ma_black"];
    [bgImg addSubview:maImg];
    
    myShareLab = [[UILabel alloc] initWithFrame:CGRectMake(90,60,SCREEN_WIDTH-150,40)];
    myShareLab.font = [UIFont systemFontOfSize:20];

    if (iPhone5) {
        myShareLab.frame =CGRectMake(60,55,SCREEN_WIDTH-150,40);
        myShareLab.font = [UIFont systemFontOfSize:16];
    }
    myShareLab.text = @"我的邀请码:00000000";
    myShareLab.textColor = [UIColor blackColor];
    myShareLab.textAlignment = NSTextAlignmentLeft;
    [bgImg addSubview:myShareLab];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20-45, 118, 100, 30)];
    shareBtn.layer.cornerRadius = 15;
    if (iPhone5) {
        shareBtn.frame = CGRectMake(SCREEN_WIDTH/2-20-50, 100, 100, 20);
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        shareBtn.layer.cornerRadius = 10;

    }
    [shareBtn setTitle:@"邀请好友" forState:0];
    [shareBtn setTitleColor:COLOR_RED forState:0];
    shareBtn.layer.borderColor = COLOR_RED.CGColor;
    shareBtn.layer.borderWidth = 2;
    [shareBtn addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:shareBtn];
    
    maTF=[[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(shareBtn.frame)+10, SCREEN_WIDTH-150 , 40)];
    maTF.layer.borderWidth = 2;
    maTF.layer.borderColor = COLOR_LINE.CGColor;
    maTF.placeholder=@"  请输入好友邀请码";
    maTF.keyboardType = UIKeyboardTypeNumberPad;
    maTF.delegate=self;
    maTF.backgroundColor=[UIColor clearColor];
    maTF.borderStyle=UITextBorderStyleNone;
    [bgImg addSubview:maTF];
    maTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    maTF.leftView = view2;
    
    
    bangBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(maTF.frame)+10, CGRectGetMaxY(shareBtn.frame)+15, 70, 30)];
    [bangBtn addTarget:self action:@selector(helpFriend) forControlEvents:UIControlEventTouchUpInside];
    bangBtn.backgroundColor = COLOR_RED;
    bangBtn.contentMode=UIViewContentModeCenter;
    [bangBtn setTitle:@"助力好友" forState:UIControlStateNormal];
    bangBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bangBtn setTitleColor:[UIColor whiteColor] forState:0];
    bangBtn.layer.cornerRadius = 5;
    [bgImg addSubview:bangBtn];
    
    [self getMyInventInfo];
    [self getFriendList];
    
    __weak InvMyFriendViewController *weakself = self;
    [_btShareApp addMethodBlock:^(UIButton *bt) {
        
        [weakself shareApp];
        
    } withEvent:UIControlEventTouchUpInside];
}

- (void)shareApp
{
    NSString *strUrlDownload = APP_SHARE_URL;
    
    [UMSocialQQHandler setQQWithAppId:UM_QQ_APPID appKey:UM_QQ_APPSECRET url:strUrlDownload];
    
    [UMSocialWechatHandler setWXAppId:UM_WX_APPID appSecret:UM_WX_APPSECRET url:strUrlDownload];
    
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4066775297"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    NSString *strShare = [NSString stringWithFormat:@"我的方向盘车管家邀请码是【%@】,快来加入我们，为您的爱车保障吧。",strMyInvieCode];
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@",strShare,strUrlDownload];
    //   友盟sdk
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"方向盘车管家,为您的爱车护航";
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:nil];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:strShare
                                     shareImage:[UIImage imageNamed:@"share_icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil]
                                       delegate:nil];
}

- (void)getMyInventInfo
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:GET_MYINV parameters:@{@"guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [carArr objectAtIndex:0];
        strMyInvieCode = dic[@"invite"];
        myShareLab.text =[NSString stringWithFormat:@"我的邀请码:%@",strMyInvieCode];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)getFriendList
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:GET_INVLIST parameters:@{@"guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *listArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for(int i = 0;i < listArr.count ; i++) {
            
            NSDictionary *dic = [listArr objectAtIndex:i];
            CustomerModel *aCus = [CustomerModel customerWithDict:dic];
            [_listArr addObject:aCus];
        }
        [self.tableViewMain reloadData];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)helpFriend
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    if ([strMyInvieCode isEqualToString:@""]) {
        return;
    }
    NSLog(@"ma===%@",maTF.text);
    if ([maTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入好友邀请码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [HUD hide:YES];
        
    }else{
    
        [manager POST:ADD_OTHERINV parameters:@{@"yao":maTF.text,@"bei":strMyInvieCode} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"!!!!!!");
            NSNumber *stanum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([stanum intValue] == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"助力成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [HUD hide:YES];
            }
            [HUD hide:YES];
            [self.view endEditing:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
    }
}
#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (arrFriendsInfo.count == 0) {
        return SCREEN_HEIHT - 110;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (_listArr.count == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-114)/2, 80, 114, 114)];
        [noDataImg setImage:[UIImage imageNamed:@"haoyou_kong"]];
        noDataImg.hidden = NO;
        noDataImg.userInteractionEnabled = YES;
        [view addSubview:noDataImg];
        
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, 204, 130, 18)];
        noDataLabel.font = [UIFont systemFontOfSize:12];
        noDataLabel.text = @"您暂时还没有邀请好友";
        noDataLabel.textColor = RGBACOLOR(174, 174, 174,1);
        noDataLabel.hidden = NO;
        noDataLabel.userInteractionEnabled = YES;
        [view addSubview:noDataLabel];
        
        return view;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *DataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    DataLabel.backgroundColor = [UIColor whiteColor];
    DataLabel.font = [UIFont systemFontOfSize:18];
    DataLabel.text = @"  已邀请的好友";
    DataLabel.textColor = [UIColor blackColor];
    [view addSubview:DataLabel];
    
    return view;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerModel *aCus = _listArr[indexPath.row];
    
    UITableViewCell *cell = [_tableViewMain dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,aCus.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",aCus.vname];
    cell.detailTextLabel.text = aCus.phone;
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];

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


