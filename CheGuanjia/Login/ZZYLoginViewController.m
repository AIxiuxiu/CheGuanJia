//
//  ZZYLoginViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 15/12/28.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import "ZZYLoginViewController.h"
#import "HomeMainViewController.h"
#import "HomeListViewController.h"
#import "InfoListViewController.h"
#import "IdentifierValidator.h"
#import "protcolViewController.h"
#import "forgerPsdViewController.h"
#import "ShopLoginViewController.h"


//验证码
#define Get_YanZhengMa Main_Ip"Other.asmx/yzm"
//注册
#define REGISTER Main_Ip"customer.asmx/Register"
//登陆
#define LOG_IN Main_Ip"customer.asmx/login"

@interface ZZYLoginViewController ()<UITextFieldDelegate>

@end

@implementation ZZYLoginViewController
{
    BOOL _up;
    UIButton *_goLoginBtn;
    UIButton *_goRegistBtn;
    UIImageView *tfBgImgV;
    UIView *lastView;
    UIButton *loginBtn;
    UIButton *duanxinBtn;
    NSString *msg;
    BOOL _isphone;
    int secondsCountDown;//倒计时开始的秒数
    NSTimer *timer;
    UIImageView *logImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BGCOLOR_BLUE;
    [self initView];
    
    _tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:_tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _up = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(void)initView{
    
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90,30,80,30)];
    [shopBtn addTarget:self action:@selector(changeToShop) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.backgroundColor = [UIColor clearColor];
    shopBtn.contentMode=UIViewContentModeCenter;
    [shopBtn setTitle:@"切换至商户端" forState:UIControlStateNormal];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:0];
    shopBtn.layer.cornerRadius = 5;
    shopBtn.layer.masksToBounds = YES;
    shopBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    shopBtn.layer.borderWidth = 1;
    [self.view addSubview:shopBtn];
    
    logImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, 120, 120, 120)];
    if (SCREEN_HEIHT<600) {
        logImgView.frame = CGRectMake(SCREEN_WIDTH/2-50, 80, 100, 100);
    }else if (SCREEN_HEIHT<500){
        logImgView.frame = CGRectMake(SCREEN_WIDTH/2-30, 10, 60, 60);
    }
    logImgView.backgroundColor = [UIColor clearColor];
    logImgView.image=[UIImage imageNamed:@"cheLogo"];
    logImgView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:logImgView];
    

    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(30,  CGRectGetMaxY(logImgView.frame)+45, SCREEN_WIDTH-60, 30)];
    tipLab.font = [UIFont systemFontOfSize:13];

    if (SCREEN_HEIHT<600){
        tipLab.frame = CGRectMake(30,  CGRectGetMaxY(logImgView.frame)+15, SCREEN_WIDTH-60, 30);
        tipLab.font = [UIFont systemFontOfSize:12];

    }else if (SCREEN_HEIHT<500)
    {
        tipLab.frame = CGRectMake(30,  CGRectGetMaxY(logImgView.frame)+10, SCREEN_WIDTH-60, 30);
    }
    tipLab.backgroundColor = [UIColor clearColor];
    tipLab.text = @"车管家新老用户,都可以使用手机号码快速登录";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    
    tfBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(tipLab.frame)+10, SCREEN_WIDTH-60 , 50*2)];
    if (SCREEN_HEIHT<500) {
        tfBgImgV.frame = CGRectMake(30, CGRectGetMaxY(tipLab.frame)+5, SCREEN_WIDTH-60 , 50*2);
    }
    tfBgImgV.userInteractionEnabled = YES;
    tfBgImgV.layer.cornerRadius = 8;
    tfBgImgV.layer.masksToBounds = YES;
    tfBgImgV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tfBgImgV];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-60, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tfBgImgV addSubview:line];
    
    _userNameField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60 , 50)];
    _userNameField.placeholder=@"  请输入手机号码";
    _userNameField.keyboardType = UIKeyboardTypeNumberPad;
    _userNameField.delegate=self;
    _userNameField.backgroundColor=[UIColor clearColor];
    _userNameField.borderStyle=UITextBorderStyleNone;
    [tfBgImgV addSubview:_userNameField];
    _userNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _userNameField.leftView = view1;
    _userNameField.returnKeyType=UIReturnKeyNext;

    
    _passwordField=[[UITextField alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-60 , 50)];
    _passwordField.placeholder=@"  请输入验证码";
    _passwordField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordField.delegate=self;
    _passwordField.backgroundColor=[UIColor clearColor];
    _passwordField.borderStyle=UITextBorderStyleNone;
    [tfBgImgV addSubview:_passwordField];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _passwordField.leftView = view2;
    
    
    duanxinBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/3*2+2, 50, (SCREEN_WIDTH-60)/3, 50)];
    [duanxinBtn addTarget:self action:@selector(getYanZhengMa:) forControlEvents:UIControlEventTouchUpInside];
    duanxinBtn.backgroundColor = [UIColor clearColor];
    duanxinBtn.contentMode=UIViewContentModeCenter;
    [duanxinBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    duanxinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [duanxinBtn setTitleColor:COLOR_BGCOLOR_BLUE forState:0];
    [tfBgImgV addSubview:duanxinBtn];
    
    UIView *lineFenge = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/3*2+1, 50, 1, 45)];
    lineFenge.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tfBgImgV addSubview:lineFenge];

    
    
    loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(tipLab.frame)+150, SCREEN_WIDTH-60, 40)];
    
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.contentMode=UIViewContentModeCenter;
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=8;
    [loginBtn setTitle:@"一键登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLOR_BGCOLOR_BLUE forState:0];
    [self.view addSubview:loginBtn];
    
    UIButton *xieyiBtn=[[UIButton alloc] init];
    xieyiBtn.frame = CGRectMake(SCREEN_WIDTH/2-100, CGRectGetMaxY(loginBtn.frame), 200, 40);
    [xieyiBtn addTarget:self action:@selector(goToprotocol) forControlEvents:UIControlEventTouchUpInside];
    xieyiBtn.contentMode=UIViewContentModeCenter;
    xieyiBtn.layer.cornerRadius = 15;
    xieyiBtn.layer.masksToBounds = YES;
    xieyiBtn.backgroundColor= [UIColor clearColor];
    [xieyiBtn setTitle:@"★登录表示已同意服务条款" forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:[UIColor whiteColor] forState:0];
    xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:xieyiBtn];
    
}
-(void)changeToShop
{
    ShopLoginViewController *shop = [[ShopLoginViewController alloc] init];
    shop.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:shop animated:YES completion:nil];
}
-(void)goToprotocol
{
    protcolViewController *pro = [[protcolViewController alloc] init];
    [self presentViewController:pro animated:YES completion:nil];
}

#pragma mark--限制输入框方法-手机号判断
//////// 限制最大输入框的输入字数与手机号正常格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //上面的为是账户名密码字符限制
    
    if (self.userNameField == textField ) {
        
        NSString *phoneStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([phoneStr length] > 11)
        {
            NSString *ptString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            textField.text = [ptString substringToIndex:11];
        
            [self alertViewShowTitle:@"提示" Message:@"请输入正确的手机的号码"];

            return NO;
        }
        
    }
    return YES;
    
    
}
#pragma mark
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    if (textField==_userNameField) {
        [_userNameField resignFirstResponder];
    }else{
        [_yanzhengField resignFirstResponder];
    }
    return YES;
}


//在UITextField 编辑之前调用方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //设置动画的名字
    if (_up==YES) {
        [self animateTextField:textField up: NO];
    }
    [self animateTextField: textField up: YES];
    _up=YES;
    
}
//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up: NO];
    _up=NO;
}

//视图上移的方法
- (void) animateTextField: (UITextField *) textField up: (BOOL) isup
{
    //设置视图上移的距离，单位像素
    const int movementDistance = 100; // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = (isup ? -movementDistance : movementDistance);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.view.frame = CGRectOffset(self.view.frame, 0, movement);
    }];
    
}

#pragma mark--登录的方法
-(void)loginAction:(UIButton *)btn{

    if (self.userNameField.text.length == 0) {
        [self alertViewShowTitle:@"提示" Message:@"手机号不能为空"];
        return;
    }
    if (self.passwordField.text.length == 0) {
        
        [self alertViewShowTitle:@"提示" Message:@"验证码不能为空"];
        return;
    }
    
    if (![self.passwordField.text isEqualToString:msg]) {
        
        [self alertViewShowTitle:@"提示" Message:@"验证码有误"];
        
    }else{
    
        [self.view endEditing:YES];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"登陆中";
        [HUD show:YES];
        
        NSDictionary *dic=@{@"phone":self.userNameField.text};
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        [manager POST:LOG_IN parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                
                    HUD.labelText = @"登陆成功";
                    [HUD hide:YES afterDelay:1];
                    
                    NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                    NSLog(@"dic==%@",[arr firstObject]);
                    
                    NSDictionary *dic = [[NSDictionary alloc] init];
                    dic = [arr firstObject];
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:dic[@"GUID"] forKey:@"c_id"];
                    [def setObject:dic[@"photo"] forKey:@"photo"];
                    [def setObject:dic[@"phone"] forKey:@"phone"];
                    [def setObject:dic[@"nickname"] forKey:@"nickname"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
                
                    if([self.loginStateStr isEqualToString:@"重新登录"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMyInfo" object:self];
                    }
                
                    [SliderViewController sharedSliderController].mainVCClassName = @"HomeMainViewController";
                    
                    [SliderViewController sharedSliderController].LeftVC=[[HomeListViewController alloc] init];
                    [SliderViewController sharedSliderController].RightVC=[[InfoListViewController alloc] init];
                    
                    [SliderViewController sharedSliderController].LeftSContentScale=1.0;
                    [SliderViewController sharedSliderController].RightSContentScale=1.0;
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController=[[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
                    
                    
                    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];

                    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
                
                }
            }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
                HUD.labelText =@"加载失败，请检查网络";
                //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
                [HUD hide:YES afterDelay:1.5];
        }];
    }
}

#pragma mark--获取验证码
-(void)getYanZhengMa:(UIButton *)btn
{

    msg=nil;//清空上次保存的msg
    NSString *phoneNum=  [self.userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
            
            NSDictionary *dic=@{@"tel":self.userNameField.text};
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


#pragma mark--判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    else  if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//-(BOOL)validate{
//    return YES;
//}

#pragma mark
#pragma mark--TapAction
-(void)tapAction:(UIGestureRecognizer*)ges{
    //    up=NO;
    [self.view endEditing:YES];
    
}

#pragma mark--键盘通知事件
-(void)keyboardWillChangeFrame:(NSNotification*)noti{
    [self.view addGestureRecognizer:_tap];
}
-(void)keyboardWillBeHidden:(NSNotification*)noti{
    [self.view removeGestureRecognizer:_tap];
}


@end