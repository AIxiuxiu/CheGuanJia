//
//  ShumaViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/10.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ShumaViewController.h"
#import "SureServiceViewController.h"
#import "ReserveModel.h"
#import "ListCarModel.h"
#define GET_RESERVE Main_Ip"reserve.asmx/getReInfo"
#define GET_CAR Main_Ip"mycar.asmx/findCarInfoByCarId"

@interface ShumaViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *mainScrollView;
@end

@implementation ShumaViewController
{
    UITextField *_duihuanTF;
    UIImageView *_headImgV;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_renNameLabel;
    UILabel *_phoneLabel;
    UILabel *_orderLabel;
    
    UIImageView *_chePhotoImgV;
    UILabel *_cheLabel;
    UILabel *_cheModelLabel;
    UILabel *_chepaiLabel;
    UILabel *_servLabel;
    UILabel *_infoLabel;
    UIButton *_sureBtn1;
    UILabel *_stateLabel;
    
    UIImageView *_tipImgView;
    
    ReserveModel *_aReserve;
    ListCarModel *_aMycar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"订单查询";
    _aReserve = [[ReserveModel alloc] init];
   // _aMycar = [[ListCarModel alloc] init];
    [self initDuihuanView];
    
    _tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-65, (SCREEN_HEIHT-NAVHEIGHT-70)/2-90+NAVHEIGHT+70, 130, 180)];
    _tipImgView.backgroundColor = [UIColor clearColor];
    _tipImgView.image = [UIImage imageNamed:@"chaxun"];
    [self.view addSubview:_tipImgView];
}
-(void)initDuihuanView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 55)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];
    
    _duihuanTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 10,SCREEN_WIDTH/3*2-30 , 35)];
    _duihuanTF.placeholder = @"请输入验证码";
    _duihuanTF.layer.borderWidth = 2;
    _duihuanTF.layer.borderColor = COLOR_NAVIVIEW.CGColor;
    _duihuanTF.keyboardType = UIKeyboardTypeNumberPad;
    _duihuanTF.layer.cornerRadius = 5;
    _duihuanTF.layer.masksToBounds = YES;
    _duihuanTF.tag = 100;
    _duihuanTF.backgroundColor=[UIColor clearColor];
    _duihuanTF.borderStyle=UITextBorderStyleNone;
    [topView addSubview:_duihuanTF];
    _duihuanTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 55)];
    _duihuanTF.leftView = view1;
    
    UIButton *duihuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+10, 10, SCREEN_WIDTH/3-30, 35)];
    duihuanBtn.backgroundColor = COLOR_NAVIVIEW;
    [duihuanBtn setTitle:@"查询" forState:UIControlStateNormal];
    [duihuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    duihuanBtn.layer.cornerRadius = 5;
    duihuanBtn.layer.masksToBounds = YES;
    duihuanBtn.layer.borderWidth = 1;
    duihuanBtn.layer.borderColor = COLOR_NAVIVIEW.CGColor;
    [duihuanBtn addTarget:self action:@selector(duihuanBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:duihuanBtn];
    
    
    
}

-(void)initView
{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT+70, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT-70)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    _headImgV.backgroundColor = [UIColor blackColor];
    _headImgV.layer.cornerRadius = 15;
    _headImgV.layer.masksToBounds = YES;
    [_headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Customer/%@",Main_Ip,_aReserve.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [self.mainScrollView addSubview:_headImgV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    _nameLabel.text = [NSString stringWithFormat:@"%@",_aReserve.myName];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.mainScrollView addSubview:_nameLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, SCREEN_WIDTH-150, 30)];
    _stateLabel.text = @"未受理";
    _stateLabel.textColor = COLOR_RED;
    _stateLabel.textAlignment = NSTextAlignmentRight;
    _stateLabel.font = [UIFont systemFontOfSize:15];
    [self.mainScrollView addSubview:_stateLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:lineView1];
    
    _chePhotoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame)+20, 80, 60)];
    _chePhotoImgV.backgroundColor = [UIColor blackColor];
    _chePhotoImgV.layer.cornerRadius = 5;
    _chePhotoImgV.layer.masksToBounds = YES;
    _chePhotoImgV.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
    _chePhotoImgV.layer.borderWidth = 1;
    [_chePhotoImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip, _aMycar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [self.mainScrollView addSubview:_chePhotoImgV];
    
    _cheLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, SCREEN_WIDTH-100, 30)];
    _cheLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_aMycar.carbrand,_aMycar.carseries,_aMycar.caryear];
    _cheLabel.textAlignment = NSTextAlignmentLeft;
    _cheLabel.font = [UIFont systemFontOfSize:16];
    [self.mainScrollView addSubview:_cheLabel];
    
    _cheModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 90, SCREEN_WIDTH-100, 20)];
    _cheModelLabel.text = _aMycar.carmodel;
    _cheModelLabel.textAlignment = NSTextAlignmentLeft;
    _cheModelLabel.font = [UIFont systemFontOfSize:14];
    _cheModelLabel.textColor = [UIColor grayColor];
    [self.mainScrollView addSubview:_cheModelLabel];
    
    _chepaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, SCREEN_WIDTH-100, 20)];
    _chepaiLabel.textAlignment = NSTextAlignmentLeft;
    _chepaiLabel.text = _aMycar.licenseID;
    _chepaiLabel.font = [UIFont systemFontOfSize:14];
    _chepaiLabel.textColor = [UIColor grayColor];
    [self.mainScrollView addSubview:_chepaiLabel];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:lineView2];
    
    _servLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, SCREEN_WIDTH-10, 30)];
    _servLabel.textAlignment = NSTextAlignmentLeft;
    _servLabel.text =[NSString stringWithFormat:@"服务项目:%@",_aReserve.pname];
    _servLabel.font = [UIFont systemFontOfSize:14];
    _servLabel.textColor = [UIColor grayColor];
    [self.mainScrollView addSubview:_servLabel];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH-10, 40)];
    _infoLabel.textAlignment = NSTextAlignmentLeft;
    _infoLabel.text = [NSString stringWithFormat:@"备注:%@",_aReserve.Remark];
    _infoLabel.numberOfLines = 0;
    _infoLabel.font = [UIFont systemFontOfSize:14];
    _infoLabel.textColor = [UIColor grayColor];
    [self.mainScrollView addSubview:_infoLabel];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:lineView3];
    
    _renNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, SCREEN_WIDTH-10, 20)];
    _renNameLabel.text =[NSString stringWithFormat:@"联系人:%@",_aReserve.myName];
    _renNameLabel.textColor = [UIColor blackColor];
    _renNameLabel.textAlignment = NSTextAlignmentLeft;
    _renNameLabel.font = [UIFont systemFontOfSize:14];
    [self.mainScrollView addSubview:_renNameLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, SCREEN_WIDTH-10, 20)];
    _phoneLabel.text =[NSString stringWithFormat:@"联系电话:%@",_aReserve.phone];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.mainScrollView addSubview:_phoneLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, SCREEN_WIDTH-10, 20)];
    _timeLabel.text =[NSString stringWithFormat:@"预约时间:%@",_aReserve.ReservetTime];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.mainScrollView addSubview:_timeLabel];
    
//    _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 345, SCREEN_WIDTH-10, 30)];
//    _orderLabel.text = @"验证码:231212423513451345";
//    _orderLabel.textColor = COLOR_RED;
//    _orderLabel.textAlignment = NSTextAlignmentLeft;
//    _orderLabel.font = [UIFont systemFontOfSize:16];
//    [self.mainScrollView addSubview:_orderLabel];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 385, SCREEN_WIDTH, 1)];
    lineView4.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:lineView4];
    
    
    
    _sureBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 405, SCREEN_WIDTH/2, 30)];
    _sureBtn1.backgroundColor = COLOR_RED;
    _sureBtn1.layer.cornerRadius = 5;
    _sureBtn1.layer.masksToBounds = YES;
    [_sureBtn1 setTitle:@"已验证,上传凭证" forState:0];
    [_sureBtn1 setTitleColor:[UIColor whiteColor] forState:0];
    [self.mainScrollView addSubview:_sureBtn1];
    [_sureBtn1 addTarget:self action:@selector(beginOrder) forControlEvents:UIControlEventTouchUpInside];
}


-(void)duihuanBtnClick1
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"查询中,请稍后";
    [HUD show:YES];
    
    NSDictionary *dic=@{@"validate":_duihuanTF.text};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_RESERVE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {

            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if (arr.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单不存在或已受理" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
            }else{
                NSDictionary *dic = [[NSDictionary alloc] init];
                dic = [arr firstObject];
                _aReserve = [ReserveModel reserveWithDict:dic];
                [self getMycar];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
    
}
-(void)getMycar
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"查询中,请稍后";
    [HUD show:YES];
    
    NSDictionary *dic=@{@"mycarid":_aReserve.mycarid};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_CAR parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = [arr firstObject];
            _aMycar = [ListCarModel myCarWithDict:dic];
            [self initView];
            _tipImgView.hidden = YES;

        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)beginOrder
{

    SureServiceViewController *sure =[[SureServiceViewController alloc] init];
    sure.passReserve = _aReserve;
    [self.navigationController pushViewController:sure animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
