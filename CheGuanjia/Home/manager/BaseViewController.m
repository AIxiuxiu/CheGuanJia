//
//  BaseViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/5.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVHEIGHT)];
    navBar.backgroundColor=COLOR_BGCOLOR_BLUE;
    navBar.alpha=0.8;
    [self.view addSubview:navBar];
    
    UIView *navLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.6)];
    navLineView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:navLineView];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
    [self.leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:self.leftBtn];
    self.leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 14, 20)];
    self.leftImgV.image = [UIImage imageNamed:@"fanhuibai"];
    [self.leftBtn addSubview:self.leftImgV];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 64);
    [navBar addSubview:self.rightBtn];
    self.rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-35, 30, 20, 20)];
   // self.rightImgV.image = [UIImage imageNamed:@"xiaoxi"];
    [self.rightBtn addSubview:self.rightImgV];
    
    self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    self.titLab.textColor = [UIColor whiteColor];
    self.titLab.font = [UIFont systemFontOfSize:18];
    self.titLab.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:self.titLab];
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
