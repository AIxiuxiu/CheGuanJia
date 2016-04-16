//
//  CarInfoViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarInfoViewController.h"
#import "ZHPickView.h"
#import "MyCarListViewController.h"
#define kBtnViewW8 (SCREEN_WIDTH-80)/9

#define ADD_MYCAR Main_Ip"MyCar.asmx/addnew"


@interface CarInfoViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ZHPickViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)ZHPickView *pickview;

@end

@implementation CarInfoViewController
{
    BOOL _up;
    UILabel *_recLiLab;
    UILabel *_buyCarTime;
    UILabel *_lastLiLab;
    UILabel *_lastBaoTime;
    UIButton *_areaBtn;
    UIView *_areaChooseView;
    UIButton *_EightBtn;
    BOOL _IsShow;
    NSArray *_TitleArr;
    UITextField *_LiTF1;
    UITextField *_LiTF2;
    UIView *helpView;
    BOOL _ishelp;
    UITextField *chepaiTF;
    UITextField *chejiaTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"填写车辆信息";
    [self initScrollerView];
    
    _IsShow = NO;
    _ishelp = NO;
    _areaChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT, SCREEN_WIDTH, 220)];
    _areaChooseView.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [self.view addSubview:_areaChooseView];
    
    _TitleArr = @[@"京",@"津",@"黑",@"吉",@"辽",@"冀",@"豫",@"鲁",@"晋",@"陕",@"内",@"宁",@"甘",@"新",@"青",@"藏",@"鄂",@"皖",@"苏",@"沪",@"浙",@"闵",@"湘",@"赣",@"川",@"渝",@"贵",@"云",@"粤",@"桂",@"琼"];
    
    CGFloat marginX8 = (SCREEN_WIDTH - 9 * kBtnViewW8) / (9 + 1);
    
    for (int i = 0; i < 31; i++) {
        // 行
        int row = i / 9;
        // 列
        int col = i % 9;
        
        CGFloat x = marginX8 + col * (marginX8 + kBtnViewW8);
        CGFloat y = 10 + row * 50;
        
        // 设置Btn
        
        _EightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _EightBtn.frame = CGRectMake(x, y, kBtnViewW8, 40);
        _EightBtn.alpha = 0.8;
        _EightBtn.tag = i + 600;
        _EightBtn.backgroundColor = [UIColor clearColor];
        [_EightBtn setTitle:[_TitleArr objectAtIndex:i] forState:UIControlStateNormal];
        [_EightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_EightBtn addTarget:self action:@selector(chooseAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _EightBtn.adjustsImageWhenHighlighted = NO;
        [_areaChooseView addSubview:_EightBtn];
    }
    
    _tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:_tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _up = NO;
    
}
-(void)initScrollerView{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    [self initView];
    
}
-(void)initView
{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 100)];
    infoView.backgroundColor = [UIColor whiteColor];
    UIImageView *photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 60)];
    photoImg.layer.cornerRadius = 5;
    photoImg.layer.masksToBounds = YES;
    photoImg.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
    photoImg.layer.borderWidth = 1;
    [photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip, self.car.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [infoView addSubview:photoImg];
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(98, 20, SCREEN_WIDTH-68, 30)];
    nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.car.vname,self.secPassCarSer.sclass,self.secPassCarSer.vname,self.passCarYear.vname];;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [infoView addSubview:nameLab];
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(98, 60, SCREEN_WIDTH-68, 20)];
    typeLab.text = [NSString stringWithFormat:@"%@",self.passCarModel.vname];
    typeLab.textAlignment = NSTextAlignmentLeft;
    typeLab.font = [UIFont systemFontOfSize:15];
    typeLab.textColor = [UIColor grayColor];
    [infoView addSubview:typeLab];
    
    [self.mainScrollView addSubview:infoView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [infoView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [infoView addSubview:line2];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(infoView.frame), SCREEN_WIDTH-15, 35)];
    lab1.text = @"完善车辆信息，能帮您更准确制定养车计划";
    lab1.textColor = RGBACOLOR(38, 38, 38, 1);
    lab1.backgroundColor = [UIColor clearColor];
    lab1.font = [UIFont systemFontOfSize:13];
    lab1.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:lab1];
    
    UIView *chepaiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame), SCREEN_WIDTH, 50)];
    chepaiView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:chepaiView];
    
    UILabel *chepaiLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    chepaiLab.backgroundColor = [UIColor clearColor];
    chepaiLab.text = @"车牌号码";
    chepaiLab.textColor = RGBACOLOR(83, 83, 83, 1);
    chepaiLab.textAlignment = NSTextAlignmentCenter;
    chepaiLab.font = [UIFont systemFontOfSize:16];
    [chepaiView addSubview:chepaiLab];
    _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chepaiLab.frame), 8, 45, 34)];
    _areaBtn.backgroundColor = [UIColor clearColor];
    [_areaBtn setTitle:@"京" forState:UIControlStateNormal];
    [_areaBtn setTitleColor:RGBACOLOR(237, 65, 53, 1) forState:UIControlStateNormal];
    _areaBtn.layer.cornerRadius = 5;
    _areaBtn.layer.masksToBounds = YES;
    _areaBtn.layer.borderWidth = 1;
    _areaBtn.layer.borderColor = RGBACOLOR(237, 65, 53, 1).CGColor;
    [_areaBtn addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [chepaiView addSubview:_areaBtn];
    chepaiTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_areaBtn.frame)+15, 0, SCREEN_WIDTH-CGRectGetMaxX(_areaBtn.frame)-15, 50)];
    chepaiTF.placeholder = @"请输入车牌号码";
    chepaiTF.delegate=self;
    chepaiTF.tag = 100;
    chepaiTF.backgroundColor=[UIColor clearColor];
    chepaiTF.borderStyle=UITextBorderStyleNone;
    [chepaiView addSubview:chepaiTF];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(chepaiView.frame), SCREEN_WIDTH-15, 35)];
    lab2.text = @"以下内容为非必填项";
    lab2.textColor = RGBACOLOR(38, 38, 38, 1);
    lab2.backgroundColor = [UIColor clearColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:lab2];
    
    UIView *chejiaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame), SCREEN_WIDTH, 50)];
    chejiaView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:chejiaView];
    
    UILabel *chejiaLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    chejiaLab.backgroundColor = [UIColor clearColor];
    chejiaLab.text = @"车架号码";
    chejiaLab.textColor = RGBACOLOR(83, 83, 83, 1);
    chejiaLab.textAlignment = NSTextAlignmentCenter;
    chejiaLab.font = [UIFont systemFontOfSize:16];
    [chejiaView addSubview:chejiaLab];
    
    chejiaTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chejiaLab.frame)+5, 0, SCREEN_WIDTH-CGRectGetMaxX(chejiaLab.frame)-5, 50)];
    chejiaTF.placeholder = @"请输入车架号后6位";
    chejiaTF.delegate=self;
    chejiaTF.tag = 101;
    chejiaTF.backgroundColor=[UIColor clearColor];
    chejiaTF.borderStyle=UITextBorderStyleNone;
    [chejiaView addSubview:chejiaTF];
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 12, 26, 26)];
    helpBtn.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [helpBtn setTitle:@"?" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpBtn.layer.cornerRadius = 13;
    helpBtn.layer.masksToBounds = YES;
    [helpBtn addTarget:self action:@selector(goHelp) forControlEvents:UIControlEventTouchUpInside];
    [chejiaView addSubview:helpBtn];
    
    //-----------------里程View1
    UIView *btn1View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(chejiaView.frame)+20, SCREEN_WIDTH, 100)];
    btn1View.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:btn1View];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line3.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line3];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 1)];
    line5.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line5];
    
    UIButton *selBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    selBtn1.backgroundColor = [UIColor clearColor];
    [btn1View addSubview:selBtn1];
    UILabel *selBtn1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    selBtn1Lab.backgroundColor = [UIColor clearColor];
    selBtn1Lab.text = @"当前里程";
    selBtn1Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn1Lab.textAlignment = NSTextAlignmentCenter;
    selBtn1Lab.font = [UIFont systemFontOfSize:16];
    [selBtn1 addSubview:selBtn1Lab];
    _recLiLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 35, 50)];
    _recLiLab.backgroundColor = [UIColor clearColor];
    _recLiLab.text = @"公里";
    _recLiLab.textColor = RGBACOLOR(83, 83, 83, 1);
    _recLiLab.textAlignment = NSTextAlignmentRight;
    _recLiLab.font = [UIFont systemFontOfSize:14];
    [selBtn1 addSubview:_recLiLab];
    
    _LiTF1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-150, 30)];
    _LiTF1.textColor = RGBACOLOR(237, 65, 53, 1);
    _LiTF1.textAlignment = NSTextAlignmentRight;
    _LiTF1.placeholder = @"0";
    _LiTF1.delegate=self;
    _LiTF1.tag = 50;
    _LiTF1.backgroundColor=[UIColor clearColor];
    _LiTF1.borderStyle=UITextBorderStyleNone;
    [selBtn1 addSubview:_LiTF1];
    
    UIButton *selBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
    selBtn2.backgroundColor = [UIColor clearColor];
    selBtn2.tag = 1000;
    [selBtn2 addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [btn1View addSubview:selBtn2];
    UILabel *selBtn2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    selBtn2Lab.backgroundColor = [UIColor clearColor];
    selBtn2Lab.text = @"购车时间";
    selBtn2Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn2Lab.textAlignment = NSTextAlignmentCenter;
    selBtn2Lab.font = [UIFont systemFontOfSize:16];
    [selBtn2 addSubview:selBtn2Lab];
    
    _buyCarTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, SCREEN_WIDTH-170, 50)];
    _buyCarTime.backgroundColor = [UIColor clearColor];
    _buyCarTime.text = @"选择时间";
    _buyCarTime.textColor = RGBACOLOR(237, 65, 53, 1);
    _buyCarTime.textAlignment = NSTextAlignmentRight;
    _buyCarTime.font = [UIFont systemFontOfSize:14];
    [selBtn2 addSubview:_buyCarTime];
    
    UIImageView *ima2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 18, 10, 14)];
    ima2.image = [UIImage imageNamed:@"jiantou"];
    [selBtn2 addSubview:ima2];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH, 1)];
    line4.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn1View addSubview:line4];
    
    //-----------------里程View2
    UIView *btn2View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1View.frame)+20, SCREEN_WIDTH, 100)];
    btn2View.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:btn2View];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line6.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn2View addSubview:line6];
    
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 1)];
    line8.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn2View addSubview:line8];
    
    UIButton *selBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    selBtn3.backgroundColor = [UIColor clearColor];
    [btn2View addSubview:selBtn3];
    UILabel *selBtn3Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    selBtn3Lab.backgroundColor = [UIColor clearColor];
    selBtn3Lab.text = @"上次保养里程";
    selBtn3Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn3Lab.textAlignment = NSTextAlignmentCenter;
    selBtn3Lab.font = [UIFont systemFontOfSize:16];
    [selBtn3 addSubview:selBtn3Lab];
    
    _lastLiLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, SCREEN_WIDTH-155, 50)];
    _lastLiLab.backgroundColor = [UIColor clearColor];
    _lastLiLab.text = @"公里";
    _lastLiLab.textColor = RGBACOLOR(83, 83, 83, 1);
    _lastLiLab.textAlignment = NSTextAlignmentRight;
    _lastLiLab.font = [UIFont systemFontOfSize:14];
    [selBtn3 addSubview:_lastLiLab];
    
    _LiTF2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-150, 30)];
    _LiTF2.textColor = RGBACOLOR(237, 65, 53, 1);
    _LiTF2.textAlignment = NSTextAlignmentRight;
    _LiTF2.placeholder = @"0";
    _LiTF2.delegate=self;
    _LiTF2.tag = 51;
    _LiTF2.backgroundColor=[UIColor clearColor];
    _LiTF2.borderStyle=UITextBorderStyleNone;
    [selBtn3 addSubview:_LiTF2];
    
    
    UIButton *selBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
    selBtn4.backgroundColor = [UIColor clearColor];
    selBtn4.tag = 1001;
    [selBtn4 addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [btn2View addSubview:selBtn4];
    UILabel *selBtn4Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    selBtn4Lab.backgroundColor = [UIColor clearColor];
    selBtn4Lab.text = @"上次保养时间";
    selBtn4Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn4Lab.textAlignment = NSTextAlignmentCenter;
    selBtn4Lab.font = [UIFont systemFontOfSize:16];
    
    [selBtn4 addSubview:selBtn4Lab];
    
    _lastBaoTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, SCREEN_WIDTH-170, 50)];
    _lastBaoTime.backgroundColor = [UIColor clearColor];
    _lastBaoTime.text = @"选择时间";
    _lastBaoTime.textColor = RGBACOLOR(237, 65, 53, 1);
    _lastBaoTime.textAlignment = NSTextAlignmentRight;
    _lastBaoTime.font = [UIFont systemFontOfSize:14];
    [selBtn4 addSubview:_lastBaoTime];
    
    UIImageView *ima4 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 18, 10, 14)];
    ima4.image = [UIImage imageNamed:@"jiantou"];
    [selBtn4 addSubview:ima4];
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH, 1)];
    line7.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btn2View addSubview:line7];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn2View.frame)+15, SCREEN_WIDTH-40, 40)];
    sureBtn.backgroundColor = RGBACOLOR(237, 65, 53, 1);
    [sureBtn setTitle:@"添加爱车" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 8;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(makeSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:sureBtn];
    
    
}

#pragma mark ----------- 全部按钮点击方法
-(void)chooseArea:(UIButton *)btn
{
    if (_IsShow == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            _areaChooseView.frame=CGRectMake(0,SCREEN_HEIHT-220,SCREEN_WIDTH,220);
        }];
        _IsShow=YES;
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _areaChooseView.frame=CGRectMake(0,SCREEN_HEIHT,SCREEN_WIDTH,220);
        }];
        _IsShow=NO;
    }
}
-(void)chooseAreaBtnClick:(UIButton *)btn
{
    [_areaBtn setTitle:[_TitleArr objectAtIndex:btn.tag-600] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _areaChooseView.frame=CGRectMake(0,SCREEN_HEIHT,SCREEN_WIDTH,220);
    }];
    _IsShow=NO;
}
-(void)chooseTime:(UIButton *)btn
{
    [self.view endEditing:YES];
    [_pickview remove];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    if (btn.tag==1000) {
        _pickview.tag = 2000;
    }else{
        _pickview.tag = 2001;
    }
    _pickview.delegate=self;
    
    [_pickview show];
}
#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSString *dateStr = [resultString substringToIndex:10];
    if (pickView.tag == 2000) {
        _buyCarTime.text = dateStr;
    }else{
        _lastBaoTime.text = dateStr;
    }
    
}

-(void)goHelp
{
    if (_ishelp==NO) {
        
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             helpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIHT-64)];
             helpView.backgroundColor = [UIColor blackColor];
             helpView.alpha = 0.8;
             [self.view addSubview:helpView];
             UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHelp)];
             [helpView addGestureRecognizer:ges];
         }
                         completion:^(BOOL finished){
                             UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, SCREEN_WIDTH-80, 300)];
                             imagV.backgroundColor = [UIColor clearColor];
                             imagV.image = [UIImage imageNamed:@"chejiahao"];
                             [helpView addSubview:imagV];
                         }];
        _ishelp =YES;
    }
}
-(void)hideHelp{
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         [helpView removeFromSuperview];
     }completion:^(BOOL finished){
         
     }];
    _ishelp = NO;
}

-(void)makeSureBtn
{
    NSString *chepaiStr = [NSString stringWithFormat:@"%@%@",_areaBtn.titleLabel.text,chepaiTF.text];
    if ([chepaiTF.text length]==0) {
        [self alertViewShowTitle:@"提示" Message:@"车牌号不能为空"];
        return;
    }
    if ([chejiaTF.text length]==0) {
        [self alertViewShowTitle:@"提示" Message:@"车架号不能为空"];
        return;
    }
    if([_LiTF1.text length]==0)
    {
        [self alertViewShowTitle:@"提示" Message:@"请填写当前行驶里程"];
        return;
    }
    if([_LiTF2.text length]==0)
    {
        [self alertViewShowTitle:@"提示" Message:@"请填写上次保养里程"];
        return;
    }
    if([_buyCarTime.text isEqual:@"选择时间"])
    {
        [self alertViewShowTitle:@"提示" Message:@"请选择爱车购买时间"];
        return;
    }
    if([_lastBaoTime.text isEqual:@"选择时间"])
    {
        [self alertViewShowTitle:@"提示" Message:@"请选择上次保养时间"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults]objectForKey:@"c_id"],@"carbrand":self.car.GUID,@"carseries":self.secPassCarSer.GUID,@"caryear":self.passCarYear.GUID,@"carmodel":self.passCarModel.GUID,@"licenseID":chepaiStr,@"frameID":chejiaTF.text,@"mileage":_LiTF1.text,@"buytime":_buyCarTime.text,@"maintenanceMileage":_LiTF2.text,@"maintenanceTime":_lastBaoTime.text};
    
    [manager POST:ADD_MYCAR parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([stateNum intValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MyCarListViewController *carlist = [[MyCarListViewController alloc] init];
        [self.navigationController pushViewController:carlist animated:YES];
        carlist.fromWhereStr = @"添加";
    }
}


#pragma mark -------代理等----

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==101)
    {
        NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([aString length] > 6) {
            
            textField.text = [aString substringToIndex:6];
            
            [self alertViewShowTitle:@"提示" Message:@"您已超过限制字数"];
            
            return NO;
        }
        
    }
    return YES;
}
//在UITextField 编辑之前调用方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 51) {
        //设置动画的名字
        if (_up==YES) {
            [self animateTextField:textField up: NO];
        }
        [self animateTextField: textField up: YES];
        _up=YES;
    }
    
}
//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        if (textField.text.length == 6) {
            return;
        }else
        {
            [self alertViewShowTitle:@"提示" Message:@"车牌号有误"];
        }
    }
    
    if (textField.tag == 51) {
        [self animateTextField:textField up: NO];
        _up=NO;
    }
    
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
#pragma mark
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    [textField resignFirstResponder];
    return YES;
}
#pragma mark--TapAction
-(void)tapAction:(UIGestureRecognizer*)ges{
    [self.view endEditing:YES];
    
}

#pragma mark--键盘通知事件
-(void)keyboardWillChangeFrame:(NSNotification*)noti{
    [self.view addGestureRecognizer:_tap];
}
-(void)keyboardWillBeHidden:(NSNotification*)noti{
    [self.view removeGestureRecognizer:_tap];
}
#pragma mark--添加提示框
-(void)alertViewShowTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
