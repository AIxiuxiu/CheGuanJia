//
//  BillDetailViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/14.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BillDetailViewController.h"
#import "PayViewController.h"

@interface BillDetailViewController ()

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"订单详情";
    [self initView];
}
-(void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10+NAVHEIGHT, SCREEN_WIDTH, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.orderNumLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-15, 25)];
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",self.passOrder.oid];
    self.orderNumLab.textAlignment = NSTextAlignmentLeft;
    self.orderNumLab.font = [UIFont systemFontOfSize:14];
    self.orderNumLab.textColor = [UIColor blackColor];
    [bgView addSubview:self.orderNumLab];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.orderNumLab.frame)+5, SCREEN_WIDTH, 1)];
    line1.backgroundColor = COLOR_LINE;
    [bgView addSubview:line1];
    
    self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line1.frame)+20, 80, 60)];
    self.photoImg.layer.cornerRadius = 5;
    self.photoImg.layer.masksToBounds =YES;
    [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@photo/Product/%@",Main_Ip,self.passOrder.buyPhoto]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [bgView addSubview:self.photoImg];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(line1.frame)+5, SCREEN_WIDTH-115, 25)];
    self.nameLab.text = [NSString stringWithFormat:@"%@",self.passOrder.buyName];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = [UIFont systemFontOfSize:17];
    self.nameLab.textColor = [UIColor blackColor];
    [bgView addSubview:self.nameLab];
    
    self.stateLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 5, 80, 20)];
    if ([self.passOrder.status isEqualToString:@"0"]) {
        self.stateLab.text = @"待支付";
        self.stateLab.textColor = COLOR_RED;


    }else{
        self.stateLab.text = @"已支付";
        self.stateLab.textColor = [UIColor grayColor];

    }
    self.stateLab.textAlignment = NSTextAlignmentRight;
    self.stateLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:self.stateLab];
    
    self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(115,CGRectGetMaxY(self.nameLab.frame)+5, 200, 30)];
    self.detailLab.text = [NSString stringWithFormat:@"%@",self.passOrder.buyIntro];
    self.detailLab.textAlignment = NSTextAlignmentLeft;
    self.detailLab.font = [UIFont systemFontOfSize:14];
    self.detailLab.numberOfLines = 0;
    self.detailLab.textColor = [UIColor grayColor];
    [bgView addSubview:self.detailLab];
    
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(self.detailLab.frame)+5, SCREEN_WIDTH-151, 40)];
    float price = [self.passOrder.buyPrice floatValue];
    self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元/年",price];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.font = [UIFont systemFontOfSize:18];
    self.priceLab.textColor = COLOR_RED;
    [bgView addSubview:self.priceLab];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLab.frame)+5, SCREEN_WIDTH, 1)];
    line3.backgroundColor = COLOR_LINE;
    [bgView addSubview:line3];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.priceLab.frame)+5, SCREEN_WIDTH-50, 40)];
    self.timeLab.text = @"订单生成时间: 2015-11-20 周五 15:09:11";
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.textColor = [UIColor grayColor];
    [bgView addSubview:self.timeLab];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLab.frame)+5, SCREEN_WIDTH, 5)];
    line2.backgroundColor = COLOR_LINE;
    [bgView addSubview:line2];
    
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, 40)];
    totalLab.text = [NSString stringWithFormat:@"  合计:%0.2f元",price];
    totalLab.textAlignment = NSTextAlignmentLeft;
    totalLab.backgroundColor = [UIColor whiteColor];
    totalLab.font = [UIFont systemFontOfSize:18];
    totalLab.textColor = COLOR_RED;
    [self.view addSubview:totalLab];
    
    if ([self.passOrder.status isEqualToString:@"0"]) {
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-45   , SCREEN_WIDTH, 45)];
        btnView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btnView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = [UIColor grayColor];
        [btnView addSubview:line2];
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH/2-30, 35)];
        buyBtn.backgroundColor = [UIColor orangeColor];
        [buyBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.layer.cornerRadius = 10;
        buyBtn.layer.masksToBounds = YES;
        [buyBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:buyBtn];
        
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+15, 5, SCREEN_WIDTH/2-30, 35)];
        cancelBtn.backgroundColor = [UIColor grayColor];
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.layer.cornerRadius = 10;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:cancelBtn];
    }
    
}

-(void)payBtnClick
{
    PayViewController *pay = [[PayViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
    pay.passStateStr = @"我的订单";
    pay.orderIDStr = self.passOrder.oid;
    pay.timeStr = self.passOrder.ordertime;
    pay.secPassOrder = self.passOrder;
    //pay.timeStr = timeStr;
    //pay.passType = _nextProductType;
}

-(void)cancelBtnClick
{
    
    
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
