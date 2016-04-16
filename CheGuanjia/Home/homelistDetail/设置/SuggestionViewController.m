//
//  SuggestionViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/20.
//  Copyright © 2016年 ChuMing. All rights reserved.
//
#import "SuggestionViewController.h"
#define ADD_ADVICE Main_Ip"city.asmx/addAdvice"


@interface SuggestionViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textV;
@property(nonatomic,strong)UILabel *numTextLab;
@property(nonatomic,strong)UIButton *tijiaoBtn;
@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"意见反馈";
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
    tipLab.text = @"如果您对我们有什么好的建议，请反馈给我们，我们会根据您的建议及时进行改进，谢谢！";
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
    [self.tijiaoBtn addTarget:self action:@selector(tijiaoReply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tijiaoBtn];
}

-(void)tijiaoReply
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"提交中";
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:ADD_ADVICE parameters:@{@"content":self.textV.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([stateNum intValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        

        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
    
    
    
}

-(void)getTextNumber
{
    NSInteger  i =  100 - self.textV.text.length;
    self.numTextLab.text = [NSString stringWithFormat:@"您还可以输入(%ld)字",(long)i ];
}


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


    
