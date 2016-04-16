//
//  ShopHomeViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/7.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ShopHomeViewController.h"
//#import "ShopYuYueViewController.h"
#import "ShumaViewController.h"
#import "WeixiuListViewController.h"
#import "ReplyViewController.h"
#import "ShopSettingViewController.h"

@interface ShopHomeViewController ()<UIScrollViewDelegate>

@end

@implementation ShopHomeViewController
{
    UIButton *_fourBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titLab.text = @"商户端";
    self.leftBtn.hidden = YES;
    [self initView];
}
-(void)initView
{
    
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    UIImageView *topBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT+50)];
    topBgImg.backgroundColor = [UIColor clearColor];
    topBgImg.image = [UIImage imageNamed:@"shopBg"];
    [self.mainScrollView addSubview:topBgImg];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, (BANNER_HEIGHT+50)/2-50, 100, 100)];
    logoImg.layer.cornerRadius = 50;
    logoImg.layer.masksToBounds = YES;
    logoImg.backgroundColor = [UIColor clearColor];
    [logoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Customer/%@",Main_Ip,[[NSUserDefaults standardUserDefaults] objectForKey:@"shop_photo"]]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [self.mainScrollView addSubview:logoImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (BANNER_HEIGHT+50)/2+60 , SCREEN_WIDTH, 20)];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = [NSString stringWithFormat:@"店员:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shoper_name"]];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:nameLab];
    
    NSArray *imageArr = @[@"shumachaxun",@"yuyueliebiao",@"pingjiaguanli",@"shezhi"];
    NSArray *colorArr = @[RGBACOLOR(230, 88, 95, 1),RGBACOLOR(253, 121, 98, 1),RGBACOLOR(78, 208, 176, 1),RGBACOLOR(244, 196, 86, 1)];
    
    for (int i = 0; i < 4; i++) {
        int col = i % 2;
        
        CGFloat x =  col * SCREEN_WIDTH/2;
        CGFloat y;
        if (i<2) {
            
             y = BANNER_HEIGHT+50+10;
        }else{
             y = BANNER_HEIGHT+50+120+10;
        }
        
        _fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fourBtn.frame = CGRectMake(x, y, SCREEN_WIDTH/2, 120);
        _fourBtn.tag = i + 500;
        
        _fourBtn.backgroundColor = [colorArr objectAtIndex:i];
        
        [_fourBtn addTarget:self action:@selector(fourbtnChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _fourBtn.adjustsImageWhenHighlighted = NO;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, _fourBtn.bounds.size.width, 20)];
        NSArray *twoTitArr = @[@"订单查询",@"维修列表",@"订单反馈",@"设置"];
        nameLabel.text=[twoTitArr objectAtIndex:i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor whiteColor];
        
        [_fourBtn addSubview:nameLabel];
        
        
        UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-30,20,60,60)];
        logoImg.backgroundColor = [UIColor clearColor];
        logoImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArr objectAtIndex:i]]];
        [_fourBtn addSubview:logoImg];
        
        
        [self.mainScrollView addSubview:_fourBtn];
    }
}
-(void)fourbtnChangeAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 500:
        {
            ShumaViewController *shuma = [[ShumaViewController alloc] init];
            [self.navigationController pushViewController:shuma animated:YES];
        }
            break;
        case 501:
        {
            WeixiuListViewController *list = [[WeixiuListViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 502:
        {
            ReplyViewController *reply = [[ReplyViewController alloc] init];
            [self.navigationController pushViewController:reply animated:YES];
        }
            break;
        case 503:
        {
            ShopSettingViewController *set = [[ShopSettingViewController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
        default:
            break;
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
