//
//  YuyueDetailViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/15.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "YuyueDetailViewController.h"
#import "goHomeViewController.h"
#import "ListCarModel.h"
#import "ShopModel.h"
#define GET_CAR Main_Ip"mycar.asmx/findCarInfoByCarId"
#define GET_SHOP Main_Ip"Organization.asmx/findCarInfoByCarId"

@interface YuyueDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIImageView *phtotImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *introLab;
@end

@implementation YuyueDetailViewController
{
    UILabel *areaLab;
    ListCarModel *_aMycar;
    UILabel *yunLab;
    ShopModel *_aShop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"预约详情";
    [self initScrollerView];
    [self getMycar];
    
    if (![self.passStateStr isEqualToString:@"未受理"])
    {
        [self getShopDataSource];
    }
}

-(void)getMycar
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSDictionary *dic=@{@"mycarid":self.passReserve.mycarid};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_CAR parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = [arr firstObject];
            _aMycar = [ListCarModel myCarWithDict:dic];
            [self.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip, _aMycar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
            self.titleLab.text = [NSString stringWithFormat:@"%@ %@ %@",_aMycar.carbrand,_aMycar.carseries,_aMycar.caryear];
            self.introLab.text = _aMycar.carmodel;
            self.priceLab.text = _aMycar.licenseID;
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}

-(void)getShopDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSDictionary *dic=@{@"guid":self.passReserve.Shopid};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_SHOP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            [HUD hide:YES];
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = [arr firstObject];
            _aShop = [ShopModel shopWithDict:dic];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}

-(void)initScrollerView{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    [self initView];
}

-(void)initView
{
    UIView *line1= [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 1)];
    line1.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:line1];
    
    UIButton *areaBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH, 45)];
    areaBtn1.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:areaBtn1];
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
    imag.image = [UIImage imageNamed:@"shangjia"];
    [areaBtn1 addSubview:imag];
    
    areaLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH -50, 20)];
    areaLab.backgroundColor = [UIColor clearColor];
    areaLab.text = @"请等待商家受理";
    areaLab.textColor = [UIColor blackColor];
    areaLab.textAlignment = NSTextAlignmentLeft;
    areaLab.font = [UIFont systemFontOfSize:15];
    [areaBtn1 addSubview:areaLab];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 15, 10, 20)];
    imag1.image = [UIImage imageNamed:@"jiantou"];
    [areaBtn1 addSubview:imag1];
    
    UIView *line2= [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 1)];
    line2.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:line2];
    
    if ([self.passStateStr isEqualToString:@"未受理"])
    {
        imag1.hidden = YES;
        
    }else if ([self.passStateStr isEqualToString:@"维修中"])
    {
        areaLab.text = _aShop.vname;
        [areaBtn1 addTarget:self action:@selector(gotoMap) forControlEvents:UIControlEventTouchUpInside];
    }else{
        areaLab.text = _aShop.vname;
        [areaBtn1 addTarget:self action:@selector(gotoMap) forControlEvents:UIControlEventTouchUpInside];
    }

    //-----------产品服务信息
    
    UIView *SerView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 140)];
    SerView.backgroundColor = [UIColor clearColor];
    [self.mainScrollView addSubview:SerView];
    
    if (SCREEN_HEIHT<600) {
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 80, 55)];
    }else{
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 100, 70)];
    }
    self.phtotImg.layer.cornerRadius = 5;
    self.phtotImg.layer.masksToBounds =YES;
    self.phtotImg.backgroundColor = [UIColor lightGrayColor];
    [SerView addSubview:self.phtotImg];
    
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 22, SCREEN_WIDTH-CGRectGetMaxX(self.phtotImg.frame)-8, 20)];
    self.titleLab.textAlignment=NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.text = @"保时捷";
    [SerView addSubview:self.titleLab];

    
    self.introLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8, 45,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 30)];
    self.introLab.textAlignment=NSTextAlignmentLeft;
    self.introLab.font = [UIFont systemFontOfSize:15];
    self.introLab.textColor = [UIColor grayColor];
    self.introLab.numberOfLines = 0;
    self.introLab.text = @"车型";
    [SerView addSubview:self.introLab];
    
    self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 75,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 25)];
    self.priceLab.textAlignment=NSTextAlignmentLeft;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    self.priceLab.textColor = [UIColor grayColor];
    self.priceLab.text = @"车牌";
    [SerView addSubview:self.priceLab];
    
//    UIButton *pingjiaBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(self.phtotImg.frame), 70, 30)];
//    pingjiaBtn.backgroundColor = [UIColor whiteColor];
//    pingjiaBtn.layer.borderWidth = 1;
//    pingjiaBtn.layer.borderColor = COLOR_RED.CGColor;
//    [pingjiaBtn setTitle:@"评价" forState:0];
//    [pingjiaBtn setTitleColor:COLOR_RED forState:0];
//    pingjiaBtn.titleLabel.font =[UIFont systemFontOfSize:15];
//    [SerView addSubview:pingjiaBtn];
    
    //验证码
    UIView *yunView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(SerView.frame), SCREEN_WIDTH, 50)];
    yunView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:yunView];
    
    yunLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15, 30)];
    yunLab.text = [ NSString stringWithFormat:@"预约单验证码:%@",self.passReserve.validate];
    yunLab.textColor = COLOR_RED;
    yunLab.font = [UIFont systemFontOfSize:18];
    yunLab.textAlignment = NSTextAlignmentCenter;
    [yunView addSubview:yunLab];
    
    UILabel *yuyueLab = [[UILabel alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(yunView.frame), SCREEN_WIDTH+2, 30)];
    yuyueLab.text = @"    预约信息";
    yuyueLab.layer.borderWidth =1;
    yuyueLab.layer.borderColor = COLOR_LINE.CGColor;
    yuyueLab.textColor = [UIColor grayColor];
    yuyueLab.textAlignment = NSTextAlignmentLeft;
    yuyueLab.font = [UIFont systemFontOfSize:17];
    [self.mainScrollView addSubview:yuyueLab];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yuyueLab.frame), SCREEN_WIDTH, 300)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:infoView];
    
    float labWidth = SCREEN_WIDTH/5;
    float labHeight = 25;
    
    NSArray *titArr = @[@"姓名:",@"手机号:",@"取车地址:",@"服务项目:",@"预约备注:",@"预约时间:"];
    NSArray *detailArr = [[NSArray alloc] initWithObjects:self.passReserve.vname,self.passReserve.phone,self.passReserve.adress,self.passReserve.pname,self.passReserve.Remark,self.passReserve.ReservetTime, nil];

    
    for (int i= 0; i<6; i++) {
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+i*30, labWidth, labHeight)];
        titLab.text = [titArr objectAtIndex:i];
        titLab.textColor = [UIColor grayColor];
        titLab.font = [UIFont systemFontOfSize:15];
        titLab.textAlignment = NSTextAlignmentLeft;
        [infoView addSubview:titLab];
        
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15+labWidth+5, 10+i*30, SCREEN_WIDTH-labWidth-20, labHeight)];
        infoLab.text = [detailArr objectAtIndex:i];
        infoLab.textColor = [UIColor blackColor];
        infoLab.font = [UIFont systemFontOfSize:15];
        infoLab.textAlignment = NSTextAlignmentLeft;
        [infoView addSubview:infoLab];
    }
    
}
-(void)gotoMap
{
    goHomeViewController *gohome = [[goHomeViewController alloc] init];
    [self.navigationController pushViewController:gohome animated:YES];
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
