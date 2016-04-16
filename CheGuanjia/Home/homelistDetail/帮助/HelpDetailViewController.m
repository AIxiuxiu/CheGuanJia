//
//  HelpDetailViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/24.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController ()

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"帮助详情";
    
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    // 测试字串
    NSString *s = @"A:服务生效后，可以在【首页】——【预约服务】选择对应服务项目进行预约，或者直接通过【首页】-【呼叫车管家】联系车管家客服平台预约相应服务";
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    CGFloat length = [s boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    label.frame = CGRectMake(10, 75, SCREEN_WIDTH-20, length);
    label.text = s;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
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
