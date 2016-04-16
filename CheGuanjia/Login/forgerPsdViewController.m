//
//  forgerPsdViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/19.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "forgerPsdViewController.h"
#import "IdentifierValidator.h"

//验证码
#define Get_YanZhengMa Main_Ip"Other.asmx/yzm"

@interface forgerPsdViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *userNameField;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UITextField *phoneNumField;
@property (nonatomic,strong)UITextField *yanzhengField;
@end

@implementation forgerPsdViewController
{
    UIButton *duanxinBtn;
    NSString *msg;
    BOOL _isphone;
    int secondsCountDown;//倒计时开始的秒数
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text =@"忘记密码";
    [self.leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self initView];
}
-(void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,NAVHEIGHT + 20, SCREEN_WIDTH , 50*4)];
   // bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:line];
    
    _userNameField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 50)];
    _userNameField.placeholder=@"  请输入账号(6~12位)";
    _userNameField.delegate=self;
    _userNameField.backgroundColor=[UIColor clearColor];
    _userNameField.borderStyle=UITextBorderStyleNone;
    [bgView addSubview:_userNameField];
    _userNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _userNameField.leftView = view1;
    _userNameField.returnKeyType=UIReturnKeyNext;
    
    
    _passwordField=[[UITextField alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH , 50)];
    _passwordField.placeholder=@"  请输入密码(6~12位)";
    _passwordField.secureTextEntry=YES;
    _passwordField.delegate=self;
    _passwordField.backgroundColor=[UIColor clearColor];
    _passwordField.borderStyle=UITextBorderStyleNone;
    [bgView addSubview:_passwordField];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _passwordField.leftView = view2;
    
    
    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
    
    _phoneNumField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60 , 50)];
    _phoneNumField.placeholder=@"  请输入手机号";
    _phoneNumField.delegate=self;
    _phoneNumField.backgroundColor=[UIColor clearColor];
    _phoneNumField.borderStyle=UITextBorderStyleNone;
    [bgView addSubview:_phoneNumField];
    _phoneNumField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _phoneNumField.leftView = view3;
    [lastView addSubview:_phoneNumField];
    
    UIView *lineY1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineY1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [lastView addSubview:lineY1];
    
    _yanzhengField=[[UITextField alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH/3*2, 50)];
    _yanzhengField.placeholder=@"  请输入验证码";
    _yanzhengField.delegate=self;
    _yanzhengField.backgroundColor=[UIColor clearColor];
    _yanzhengField.borderStyle=UITextBorderStyleNone;
    _yanzhengField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _yanzhengField.leftView = view4;
    [lastView addSubview:_yanzhengField];
    
    UIView *lineY = [[UIView alloc] initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 1)];
    lineY.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [lastView addSubview:lineY];
    
    duanxinBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+2, 50, SCREEN_WIDTH/3, 50)];
    [duanxinBtn addTarget:self action:@selector(getYanZhengMa:) forControlEvents:UIControlEventTouchUpInside];
    duanxinBtn.backgroundColor = [UIColor clearColor];
    duanxinBtn.contentMode=UIViewContentModeCenter;
    [duanxinBtn setTitle:@"获取短信" forState:UIControlStateNormal];
    [duanxinBtn setTitleColor:COLOR_BGCOLOR_BLUE forState:0];
    [lastView addSubview:duanxinBtn];
    
    UIView *lineFenge = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+1, 50, 1, 45)];
    lineFenge.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [lastView addSubview:lineFenge];
    
    [bgView addSubview:lastView];
    
    
    
    
    UIButton *uploadPsdBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(bgView.frame)+30, SCREEN_WIDTH-100, 40)];
    [uploadPsdBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    uploadPsdBtn.backgroundColor = COLOR_BGCOLOR_BLUE;
    uploadPsdBtn.contentMode=UIViewContentModeCenter;
    uploadPsdBtn.layer.cornerRadius = 8;
    [uploadPsdBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [uploadPsdBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:uploadPsdBtn];
}

-(void)changePwd
{
    
    
    
    
}

#pragma mark--获取验证码
-(void)getYanZhengMa:(UIButton *)btn
{
    
    msg=nil;//清空上次保存的msg
    NSString *phoneNum=  [self.phoneNumField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL bank=[IdentifierValidator isBlankString:phoneNum];
    
    if (bank) {
        
        [self alertViewShowTitle:@"提示" Message:@"手机号码不能为空!!!"];
        
    }else{
        
        _isphone=[IdentifierValidator isChinaUnicomPhoneNumber:phoneNum];
        if (_isphone==NO) {
            
            [self alertViewShowTitle:@"提示" Message:@"手机号码不符合规格!!!"];
            
        }else{
            secondsCountDown=60;
            duanxinBtn.enabled=NO;
            
            timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
            
            NSDictionary *dic=@{@"tel":self.phoneNumField.text};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            
            manager.responseSerializer=[AFHTTPResponseSerializer serializer];
            
            [manager POST:Get_YanZhengMa parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSArray *dataArr =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"data====%@",[dataArr firstObject]);
                if (dataArr){
                    [self alertViewShowTitle:@"提示" Message:@"验证码已发送..."];
                    NSDictionary *dic = [dataArr firstObject];
                    msg=dic[@"yzm"];
                    
                }else{
                    duanxinBtn.enabled=YES;
                    [timer invalidate];
                    [duanxinBtn setTitle:@"获取验证码" forState:0];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self alertViewShowTitle:@"提示" Message:@"请检查您的网络"];
            }];
        }
    }
}
#pragma mark--计时器
//倒计时；
-(void)timeFireMethod:(NSTimer *)countDownTimer{
    secondsCountDown--;
    NSString *str=[NSString stringWithFormat:@"%d秒",secondsCountDown];
    [duanxinBtn setTitle:str forState:0];
    duanxinBtn.enabled=NO;
    if(secondsCountDown==0) {
        duanxinBtn.enabled=YES;
        [countDownTimer invalidate];
        [duanxinBtn setTitle:@"重新获取" forState:0];
        
    }
}

#pragma mark--添加提示框
-(void)alertViewShowTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
