//
//  PayViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "PayViewController.h"
#import "ChooseCarViewController.h"
#import "HongbaoModel.h"
#import "ChooseHongBaoViewController.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Pingpp.h"

#define KBtn_width        200
#define KBtn_height       40
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          20

#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kPlaceHolder      @"支付金额"
#define kMaxAmount        9999999

#define kUrlScheme      @"wxddb7b1f8967dd93d" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

//http://192.168.0.6:80/Pay.asmx
//http://218.244.151.190/demo/charge

#define GET_CHARGE Main_Ip"Pay.asmx/getcharge"
#define GET_HONGBAO Main_Ip"customer.asmx/selectTicket"

@interface PayViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *photoImg;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *dingdanLab;
@property(nonatomic,strong) UILabel *buyTime;
@property(nonatomic,strong) UILabel *chepaiLab;
@property(nonatomic,strong) UILabel *defLab;

@property(nonatomic,strong)UIImageView *phtotImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *introLab;

@property(nonatomic,strong)UITextField *lefMesgTf;
@property(nonatomic,strong)UILabel *hongbaoLab;

@property(nonatomic,strong) UILabel *totalLab;
@property(nonatomic,strong) NSMutableArray *hongbaoArr;
@end

@implementation PayViewController
{
    UIAlertView* mAlert;
    UIImageView *selImg;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titLab.text = @"订单详情";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.leftBtn.hidden = YES;
    self.channel = @"null";
    
    UIButton *leftBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn1.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
    [leftBtn1 addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn1];
    
    UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 14, 20)];
    leftImgV.image = [UIImage imageNamed:@"fanhuibai"];
    [leftBtn1 addSubview:leftImgV];
    
    self.hongbaoArr = [[NSMutableArray alloc] init];
    [self initScrollView];
    [self getHongBao];
}
-(void)backBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单已经生成,是否确定取消支付?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃支付", nil];
    alert.tag = 8888;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8888) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)getHongBao
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:GET_HONGBAO parameters:@{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"status":@"2"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<arr.count; i++) {
            HongbaoModel *aHongbao = [HongbaoModel hongbaoWithDict:[arr objectAtIndex:i]];
            [self.hongbaoArr addObject:aHongbao];
        }
        if (self.hongbaoArr.count == 0) {
            _hongbaoLab.text = @"暂无可用优惠券";
        }else{
            _hongbaoLab.text = @"您有可选优惠券";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
-(void)initScrollView{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
//    BANNER_HEIGHT+150+200+250
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+250);
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    [self initView];
    [self initBottomView];
}
-(void)initView
{
    UIButton *topBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    topBgBtn.backgroundColor = [UIColor whiteColor];
    topBgBtn.userInteractionEnabled =YES;
    [self.mainScrollView addSubview:topBgBtn];
    [topBgBtn addTarget:self action:@selector(changeCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
    line2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line2];
    
    self.defLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 23, 100)];
    self.defLab.text = @"\n默\n认\n";
    self.defLab.textColor = [UIColor whiteColor];
    self.defLab.backgroundColor = [UIColor orangeColor];
    self.defLab.textAlignment = NSTextAlignmentCenter;
    self.defLab.font = [UIFont systemFontOfSize:16];
    self.defLab.numberOfLines = 0;
    [topBgBtn addSubview:self.defLab];
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *carBrand = [def objectForKey:@"defCarbrandStr"];
    NSString *carseries = [def objectForKey:@"defCarseriesStr"];
    NSString *caryear = [def objectForKey:@"defCaryearStr"];
    NSString *carmodel = [def objectForKey:@"defCarmodelStr"];
    NSString *chepaiLab = [def objectForKey:@"defCarIDStr"];
    NSString *photo = [def objectForKey:@"defCarPhotoStr"];

    self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 60)];
    self.photoImg.layer.cornerRadius = 5;
    self.photoImg.layer.masksToBounds = YES;
    self.photoImg.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
    self.photoImg.layer.borderWidth = 1;
    [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [topBgBtn addSubview:self.photoImg];
    
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 20, SCREEN_WIDTH-118, 30)];
    self.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",carBrand,carseries,caryear,carmodel];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = [UIFont systemFontOfSize:18];
    [topBgBtn addSubview:self.nameLab];
    
    self.chepaiLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 60, SCREEN_WIDTH-118, 20)];
    self.chepaiLab.text = chepaiLab;
    self.chepaiLab.textAlignment = NSTextAlignmentLeft;
    self.chepaiLab.font = [UIFont systemFontOfSize:15];
    self.chepaiLab.textColor = [UIColor grayColor];
    [topBgBtn addSubview:self.chepaiLab];
    
    UILabel *moreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 60, 60, 20)];
    moreLab.text = @"更多>>";
    moreLab.textAlignment = NSTextAlignmentLeft;
    moreLab.font = [UIFont systemFontOfSize:15];
    moreLab.textColor = [UIColor grayColor];
    [topBgBtn addSubview:moreLab];
    
    self.dingdanLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    self.dingdanLab.text = [NSString stringWithFormat:@"订单号:%@",self.orderIDStr];
    self.dingdanLab.textAlignment = NSTextAlignmentLeft;
    self.dingdanLab.font = [UIFont systemFontOfSize:14];
    self.dingdanLab.textColor = [UIColor blackColor];
    [self.mainScrollView addSubview:self.dingdanLab];
    
    self.buyTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dingdanLab.frame)+20, 100, SCREEN_WIDTH-(CGRectGetMaxX(self.dingdanLab.frame)+20), 50)];
    self.buyTime.text = self.timeStr;
    self.buyTime.textAlignment = NSTextAlignmentLeft;
    self.buyTime.font = [UIFont systemFontOfSize:14];
    self.buyTime.textColor = [UIColor grayColor];
    [self.mainScrollView addSubview:self.buyTime];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buyTime.frame), SCREEN_WIDTH, 1)];
    line3.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [self.mainScrollView addSubview:line3];

    //-----------------
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buyTime.frame)+1, SCREEN_WIDTH, 121)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:topView];
    if (SCREEN_HEIHT<600) {
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 80, 55)];
    }else{
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 100, 70)];
    }
    self.phtotImg.layer.cornerRadius = 5;
    self.phtotImg.layer.masksToBounds =YES;
    self.phtotImg.backgroundColor = [UIColor lightGrayColor];
    if ([self.passStateStr isEqualToString:@"我的订单"])
    {
        [self.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,self.secPassOrder.buyPhoto]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    }else{
        [self.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,self.SpassProduct.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    }
    [topView addSubview:self.phtotImg];
    
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 22, 110, 20)];
    self.titleLab.textAlignment=NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textColor = [UIColor blackColor];
    if ([self.passStateStr isEqualToString:@"我的订单"])
    {
        self.titleLab.text = self.secPassOrder.buyName;
    }else{
        self.titleLab.text = self.SpassProduct.title;

    }
    [topView addSubview:self.titleLab];
    
    self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8+115 , 22,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+110+10) , 25)];
    self.priceLab.textAlignment=NSTextAlignmentRight;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    self.priceLab.textColor = RGBACOLOR(237, 65, 53, 1);
    float price = [self.passType.price floatValue];
    if([self.stateStr isEqualToString:@"出行宝"])
    {
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元/年",price];
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元",price];
    }
    [topView addSubview:self.priceLab];
    
    self.introLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 42,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 40)];
    self.introLab.textAlignment=NSTextAlignmentLeft;
    self.introLab.font = [UIFont systemFontOfSize:13];
    self.introLab.textColor = [UIColor lightGrayColor];
    self.introLab.numberOfLines = 0;
    if ([self.passStateStr isEqualToString:@"我的订单"])
    {
        self.introLab.text = self.secPassOrder.buyIntro;
    }else{
        self.introLab.text = self.SpassProduct.introduction;

    }
    [topView addSubview:self.introLab];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) , SCREEN_WIDTH, 8)];
    line5.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainScrollView addSubview:line5];
    
    UIView *btn1View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line5.frame), SCREEN_WIDTH, 100)];
    btn1View.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:btn1View];
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line6.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line6];
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 1)];
    line7.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line7];

    UILabel *selBtn1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    selBtn1Lab.backgroundColor = [UIColor clearColor];
    selBtn1Lab.text = @"购买备注:";
    selBtn1Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn1Lab.textAlignment = NSTextAlignmentCenter;
    selBtn1Lab.font = [UIFont systemFontOfSize:16];
    [btn1View addSubview:selBtn1Lab];
    
    _lefMesgTf = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-100, 30)];
    _lefMesgTf.textColor = RGBACOLOR(237, 65, 53, 1);
    _lefMesgTf.textAlignment = NSTextAlignmentLeft;
    _lefMesgTf.placeholder = @"可以添加您想要用的品牌";
    _lefMesgTf.delegate=self;
    _lefMesgTf.tag = 50;
    _lefMesgTf.backgroundColor=[UIColor clearColor];
    _lefMesgTf.borderStyle=UITextBorderStyleNone;
    [btn1View addSubview:_lefMesgTf];
    
    UIButton *selBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
    selBtn2.backgroundColor = [UIColor clearColor];
    selBtn2.tag = 1000;
    [selBtn2 addTarget:self action:@selector(chooseYouhui) forControlEvents:UIControlEventTouchUpInside];
    [btn1View addSubview:selBtn2];
    UILabel *selBtn2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    selBtn2Lab.backgroundColor = [UIColor clearColor];
    selBtn2Lab.text = @"优惠券:";
    selBtn2Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn2Lab.textAlignment = NSTextAlignmentCenter;
    selBtn2Lab.font = [UIFont systemFontOfSize:16];
    [selBtn2 addSubview:selBtn2Lab];
    
    _hongbaoLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH-120, 50)];
    _hongbaoLab.backgroundColor = [UIColor clearColor];
    _hongbaoLab.text = @"暂无可用优惠券";
    _hongbaoLab.textColor = RGBACOLOR(237, 65, 53, 1);
    _hongbaoLab.textAlignment = NSTextAlignmentLeft;
    _hongbaoLab.font = [UIFont systemFontOfSize:16];
    [selBtn2 addSubview:_hongbaoLab];
    
    UIImageView *ima2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 18, 10, 14)];
    ima2.image = [UIImage imageNamed:@"jiantou"];
    [selBtn2 addSubview:ima2];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH, 1)];
    line4.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line4];
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
    line8.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line8];
    
    UIView *zhifuTit = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1View.frame), SCREEN_WIDTH, 40)];
    zhifuTit.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainScrollView addSubview:zhifuTit];
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 40)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.text = @"请选择支付方式:";
    titLab.textColor = RGBACOLOR(83, 83, 83, 1);
    titLab.textAlignment = NSTextAlignmentLeft;
    titLab.font = [UIFont systemFontOfSize:16];
    [zhifuTit addSubview:titLab];
    
    NSArray *titArr = @[@"支付宝支付",@"微信支付",@"银联支付"];
    NSArray *titIcon = @[@"ali",@"wechat",@"union"];
    
    for (int i = 0; i<3; i++) {
        
        UIButton *zhifuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(zhifuTit.frame)+ i*50, SCREEN_WIDTH, 50)];
        zhifuBtn.tag = 100 + i;
        [zhifuBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:zhifuBtn];
        
        UIImageView *photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        photoImg.backgroundColor = [UIColor clearColor];
        photoImg.image = [UIImage imageNamed:[titIcon objectAtIndex:i]];
        [zhifuBtn addSubview:photoImg];
        
        UILabel *zhifuLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 180, 50)];
        zhifuLab.text = [titArr objectAtIndex:i];
        zhifuLab.textAlignment = NSTextAlignmentLeft;
        [zhifuBtn addSubview:zhifuLab];
        
        selImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 30, 30)];
        selImg.backgroundColor = [UIColor clearColor];
        selImg.layer.cornerRadius = 15;
        selImg.layer.masksToBounds = YES;
        selImg.tag = 500+i;
        selImg.image = [UIImage imageNamed:@"weixuanzhong"];
        [zhifuBtn addSubview:selImg];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        line.backgroundColor = RGBACOLOR(220, 220, 220, 1);
        [zhifuBtn addSubview:line];
    }
    
    
}

-(void)changeCar
{
    ChooseCarViewController *chooseCar = [[ChooseCarViewController alloc] init];
    [self.navigationController pushViewController:chooseCar animated:YES];
    chooseCar.retrunBlock=^(ListCarModel *aCar){
        [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/%@",Main_Ip,aCar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        self.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",aCar.carbrand,aCar.carseries,aCar.caryear,aCar.carmodel];
        self.chepaiLab.text = aCar.licenseID;
        
        
    };
}
-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-45            , SCREEN_WIDTH, 45)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [bottomView addSubview:line1];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.text = @"价格:";
    titLab.textColor = [UIColor blackColor];
    titLab.textAlignment = NSTextAlignmentLeft;
    titLab.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:titLab];
    
    self.totalLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 30)];
    self.totalLab.backgroundColor = [UIColor clearColor];
    float price = [self.passType.price floatValue];
    self.totalLab.text = [NSString stringWithFormat:@"%0.2f",price];
    self.totalLab.textColor = [UIColor orangeColor];
    self.totalLab.textAlignment = NSTextAlignmentLeft;
    self.totalLab.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:self.totalLab];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-135, 5, 120, 35)];
    buyBtn.backgroundColor = [UIColor orangeColor];
    [buyBtn setTitle:@"确认结算" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 5;
    buyBtn.layer.masksToBounds = YES;
    [buyBtn addTarget:self action:@selector(normalPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    
}
-(void)chooseYouhui
{
    if ([_hongbaoLab.text isEqualToString:@"暂无可用优惠券"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您暂无可用优惠券" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        ChooseHongBaoViewController *youhui = [[ChooseHongBaoViewController alloc] init];
        [self.navigationController pushViewController:youhui animated:YES];
        youhui.passHongArr = self.hongbaoArr;
        youhui.Block=^(HongbaoModel *aHongbao){
            
            _hongbaoLab.text = [NSString stringWithFormat:@"您已选择%@元优惠券",aHongbao.amount];
        };
    }
}

-(void)chooseType:(UIButton *)btn
{
    UIImageView *imag1 = [self.view viewWithTag:500];
    imag1.image = [UIImage imageNamed:@"weixuanzhong"];
    UIImageView *imag2 = [self.view viewWithTag:501];
    imag2.image = [UIImage imageNamed:@"weixuanzhong"];
    UIImageView *imag3 = [self.view viewWithTag:502];
    imag3.image = [UIImage imageNamed:@"weixuanzhong"];

    
    UIImageView *imag = [self.view viewWithTag:btn.tag + 400];
    imag.image = [UIImage imageNamed:@"xuanzhong"];
    
    NSInteger tag = ((UIButton*)btn).tag;
    if (tag == 102) {
        self.channel = @"upacp";
    } else if (tag == 101) {
        self.channel = @"wx";
    } else if (tag == 100) {
        self.channel = @"alipay";

    } else {
        return;
    }
}
- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}

- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

- (void)normalPayAction:(id)sender
{
    long long amount = [[self.totalLab.text stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
    if (amount == 0) {
        return;
    }
    NSString *amountStr = [NSString stringWithFormat:@"%lld", amount];
    
    if ([self.channel isEqualToString:@"null"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        PayViewController * __weak weakSelf = self;
        [self showAlertWait];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10;
    
        [manager POST:GET_CHARGE parameters:@{@"oid":self.orderIDStr,@"amount":amountStr,@"channel":self.channel,@"beizhu":@"11111222",@"carid":@"bf156514-3613-4786-a481-c5eb89bc55f8"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                if ([responseObject isKindOfClass:[NSData class]]) {
                    
                NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    NSDictionary *dic = [carArr objectAtIndex:0];
                NSLog(@"########%@",carArr);
                    
                [Pingpp createPayment:dic viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    NSLog(@"completion block: %@", result);
                    if ([result isEqualToString:@"success"]) {
                        // 支付成功
                    } else {
                        // 支付失败或取消
                        NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                    }
                    [weakSelf showAlertMessage:result];
                }];
                [weakSelf hideAlert];
            }

        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);

        }];
    }
    
//    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
//    [postRequest setHTTPMethod:@"POST"];
//    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    PayViewController * __weak weakSelf = self;
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [self showAlertWait];
//    
//    
//    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//            [weakSelf hideAlert];
//            if (httpResponse.statusCode != 200) {
//                NSLog(@"statusCode=%ld error = %@", (long)httpResponse.statusCode, connectionError);
//                [weakSelf showAlertMessage:kErrorNet];
//                return;
//            }
//            if (connectionError != nil) {
//                NSLog(@"error = %@", connectionError);
//                [weakSelf showAlertMessage:kErrorNet];
//                return;
//            }
//            NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"charge = %@", charge);
//            
//            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                NSLog(@"completion block: %@", result);
//                if (error == nil) {
//                    NSLog(@"PingppError is nil");
//                } else {
//                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
//                }
//                [weakSelf showAlertMessage:result];
//            }];
//        });
//    }];
}


- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.mainScrollView endEditing:YES];
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
