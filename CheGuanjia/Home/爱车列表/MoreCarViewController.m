//
//  MoreCarViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/7.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MoreCarViewController.h"

@interface MoreCarViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textV;
@property(nonatomic,strong)UILabel *numTextLab;
@property(nonatomic,strong)UIButton *tijiaoBtn;
@end

@implementation MoreCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = self.myTitStr;
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
    tipLab.text = @"车管家车型库匹配了绝大部分的车型。\n如果仔细查找仍没有找到您的车型，请反馈给我们。";
    tipLab.textColor = [UIColor grayColor];
    tipLab.backgroundColor = [UIColor clearColor];
    tipLab.textAlignment = NSTextAlignmentLeft;
    tipLab.font = [UIFont systemFontOfSize:15];
    tipLab.numberOfLines = 0;
    [self.view addSubview:tipLab];
    
    self.textV = [[UITextView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+60, SCREEN_WIDTH, 180)];
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.delegate = self;
    [self.view addSubview:self.textV];
    
    self.numTextLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 160, 170, 20)];
    self.numTextLab.font = [UIFont systemFontOfSize:16];
    self.numTextLab.textColor = [UIColor grayColor];
    [self.textV addSubview:self.numTextLab];
    
    [self getTextNumber];
    self.tijiaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 350, SCREEN_WIDTH-60, 40)];
    self.tijiaoBtn.backgroundColor = [UIColor redColor];
    [self.tijiaoBtn setTitle:@"立即反馈" forState:UIControlStateNormal];
    [self.tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.tijiaoBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.tijiaoBtn];
}

-(void)getTextNumber
{
    NSInteger  i =  100 - self.textV.text.length;
    self.numTextLab.text = [NSString stringWithFormat:@"您还可以输入(%ld)字",(long)i ];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    
//}


-(void)textViewDidChange:(UITextView *)textView
{
    [self getTextNumber];
    
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //判断加上输入的字符，是否超过界限
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 100)
    {
        textView.text = [str substringToIndex:100];
        return NO;
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textV resignFirstResponder];
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
