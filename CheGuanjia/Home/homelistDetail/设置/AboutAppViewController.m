//
//  AboutAppViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/20.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"关于车管家";
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(30, 95, SCREEN_WIDTH-60, 80)];
    logo.image = [UIImage imageNamed:@"lntroLogo"];
    [self.view addSubview:logo];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(logo.frame)+10, SCREEN_WIDTH-30, 250)];
    lab.text = @"  方向盘车管家，由国内领先的互联网平台服务公司设计开发。方向盘车管家围绕车主日常出行场景设计各种不同的保障服务产品，公司主打三款保障服务产品，涵盖车辆事故，油漆刮擦，非质保配件自然损坏等场景。用户可以通过“方向盘车管家”APP随时随地管理自己的爱车，如在保障期内遇到任何问题，仅需呼叫就近车管家服务代表，无需亲自动手即可完成，车管家将为您提供一站式上门服务。";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
    
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
