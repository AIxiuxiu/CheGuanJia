//
//  UpdateInfoViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/19.
//  Copyright © 2016年 ChuMing. All rights reserved.
#define BOOKMARK_WORD_LIMIT 100
#import "UpdateInfoViewController.h"

#define UPDATE_ADDRESS Main_Ip"address.asmx/update"
#define ADD_ADDRESS Main_Ip"address.asmx/addnew"

@interface UpdateInfoViewController ()<UIAlertViewDelegate>

@end

@implementation UpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titLab.text = self.titStr;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.textV = [[UITextView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+30, SCREEN_WIDTH, 100)];
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.text = self.addressStr;
    self.textV.delegate = self;
    if([self.titLab.text isEqualToString:@"修改驾龄"])
    {
        self.textV.keyboardType = UIKeyboardTypeNumberPad;
    }
    [self.view addSubview:self.textV];
    
    
//    self.numTextLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, NAVHEIGHT +30, 170, 20)];
//    self.numTextLab.font = [UIFont systemFontOfSize:16];
//    self.numTextLab.textColor = [UIColor grayColor];
//    [self.view addSubview:self.numTextLab];
//    
//    [self getTextNumber];
    self.tijiaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 240, SCREEN_WIDTH-60, 40)];
    self.tijiaoBtn.backgroundColor = COLOR_NAVIVIEW;
    [self.tijiaoBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.tijiaoBtn.layer.cornerRadius = 6;
    [self.tijiaoBtn addTarget:self action:@selector(baocunBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tijiaoBtn];
    
    self.leftBtn.hidden= YES;
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
    [popBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 14, 20)];
    img.image = [UIImage imageNamed:@"fanhuibai"];
    [popBtn addSubview:img];
    
}
-(void)popBtnClick
{
    UIAlertView * arr = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未保存修改后信息"delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"放弃修改",  nil];

    [arr show];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}
-(void)getTextNumber
{
    NSInteger  i =  100 - self.textV.text.length;
    self.numTextLab.text = [NSString stringWithFormat:@"您还可以输入(%ld)字",(long)i ];
    NSLog(@"%@",self.numTextLab.text);
}

-(void)baocunBtnClick
{
    if ([self.fromWhereStr isEqualToString:@"修改地址"]) {
        
            
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"保存中";
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSDictionary *dic = @{@"guid":self.addressIDStr,@"address":self.textV.text};
        [manager POST:UPDATE_ADDRESS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSNumber *stateNum =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([stateNum intValue]==1) {
                [HUD hide:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
            
        
        
    }else if ([self.fromWhereStr isEqualToString:@"添加地址"]){
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"保存中";
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
        NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"address":self.textV.text};
        [manager POST:ADD_ADDRESS parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            NSNumber *stateNum =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([stateNum intValue]==1) {
                [HUD hide:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];

    }
    
    else{
        
        if (self.retrunBlock) {
            
            self.retrunBlock(self.textV.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
    
  //  [self getTextNumber];
    
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
    if (str.length > BOOKMARK_WORD_LIMIT)
    {
        textView.text = [str substringToIndex:BOOKMARK_WORD_LIMIT];
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

