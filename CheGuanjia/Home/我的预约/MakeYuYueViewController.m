//
//  MakeYuYueViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/13.
//  Copyright © 2016年 ChuMing. All rights reserved.
//
#import "MakeYuYueViewController.h"
#import "photoCollectionViewCell.h"
#import "SJAvatarBrowser.h"
#import "HSDatePickerViewController.h"
#import "AdressViewController.h"
#import "goHomeViewController.h"
#import "product.h"
#import "ChooseCarViewController.h"
#import "ListCarModel.h"
#import "YuyueViewController.h"
#define BOOKMARK_WORD_LIMIT 100

#define ADD_NEW_RESERVE Main_Ip"reserve.asmx/addnew"
#define GET_MYPRODUCT Main_Ip"MyProduct.asmx/findOrderByCar"


@interface MakeYuYueViewController ()<HSDatePickerViewControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *photoImg;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *chepaiLab;
@property(nonatomic,strong) UILabel *defLab;
@property(nonatomic,strong) UIView *sevView;
@property(nonatomic,strong) NSString *typeStr;

@property (nonatomic, strong) NSDate *selectedDate;
@end

@implementation MakeYuYueViewController
{
    BOOL _up;
    UICollectionView *_collectionView;
    NSArray *MenuList;
    NSMutableArray *_allPhotoArr;
    UILabel *_yuyueTime;
    
    UILabel *_homeAreaLab;
    UILabel *goShop;
    CGFloat _serViewHight;
    CGFloat _serViewHight1;
    UITextView *textview;
    
    UIButton *_selImgBtn1;
    UIButton *_selImgBtn2;
    
    NSString* _imageString;
    NSString *_IDStr;
    NSString *_nameStr;
    
    NSMutableArray *serListArr;
    NSMutableArray *serIDListArr;
    NSDictionary *strDic;
    
    UIButton *button;
    NSMutableArray *_btnArr;
    
    NSMutableArray *serListArr1;
    
    UIButton *button1;
    NSMutableArray *_btnArr1;
    
    UITextField *nameTF;
    UITextField *telTF;
    
    NSMutableArray *serNameArr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titLab.text = @"预约服务";
    // Do any additional setup after loading the view.
    
    _up = NO;
    _serViewHight = 28;
    _serViewHight1 = 28;
    _allPhotoArr = [[NSMutableArray alloc] init];
    
    serListArr = [[NSMutableArray alloc] init];
    serIDListArr = [[NSMutableArray alloc] init];
    _btnArr = [[NSMutableArray alloc] init];
    
    serListArr1 = [[NSMutableArray alloc] init];
    _btnArr1 = [[NSMutableArray alloc] init];
    
    serNameArr = [[NSMutableArray alloc] init];

    UIImage *noImg = [UIImage imageNamed:@"plus_camera"];
    [_allPhotoArr addObject:noImg];

    [self getSerArrDataSource];
    
    
}
-(void)getSerArrDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"获取服务中请稍后";
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *Dic=@{@"mycarid":[[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"],@"type":@"2"};
    
    [manager POST:GET_MYPRODUCT parameters:Dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<arr.count ; i++) {
            product *aProduct = [[product alloc] initWithDict:[arr objectAtIndex:i]];
            [serListArr addObject:aProduct];
        }
        
        if (serListArr.count == 0 && serListArr1.count ==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先为该车购买服务" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.tag=9999;
            [alert show];
        }
        
        [self initScrollView];
        [self initDetailView];
        
        [HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }];
    

}
-(void)initScrollView
{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+220+80+150);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
}
-(void)initCollectionView{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sevView.frame)+10, SCREEN_WIDTH, 30)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = @"   上传样本照片(最多可上传10张图片)";
    lab.textColor = [UIColor blackColor];
    [self.mainScrollView addSubview:lab];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(SCREEN_WIDTH/5-20, SCREEN_WIDTH/5-20);
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 10, 0, 10);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.sevView.frame)+40,SCREEN_WIDTH,(SCREEN_WIDTH/5-20+12)*2) collectionViewLayout:flowLayout];
    [self.mainScrollView addSubview:_collectionView];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [_collectionView registerClass:[photoCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView reloadData];
    
//    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, (SCREEN_WIDTH/4-20+5)*3-15, 170, 15)];
//    tipLab.text = @"最多可上传8张图片";
//    tipLab.textColor = [UIColor grayColor];
//    [_collectionView addSubview:tipLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:line];
}

-(void)initDetailView
{
    UIButton *topBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    topBgBtn.backgroundColor = [UIColor whiteColor];
    topBgBtn.userInteractionEnabled =YES;
    [self.mainScrollView addSubview:topBgBtn];
    [topBgBtn addTarget:self action:@selector(changeCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
    line2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line2];
    
    self.defLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 23, 100)];
    self.defLab.text = @"\n默\n认\n";
    self.defLab.textColor = [UIColor whiteColor];
    self.defLab.backgroundColor = [UIColor orangeColor];
    self.defLab.textAlignment = NSTextAlignmentCenter;
    self.defLab.font = [UIFont systemFontOfSize:16];
    self.defLab.numberOfLines = 0;
    [topBgBtn addSubview:self.defLab];
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *carBrand = [def objectForKey:@"defCarbrandStr"];
    NSString *carseries = [def objectForKey:@"defCarseriesStr"];
    NSString *caryear = [def objectForKey:@"defCaryearStr"];
    NSString *carmodel = [def objectForKey:@"defCarmodelStr"];
    NSString *chepaiLab = [def objectForKey:@"defCarIDStr"];
    NSString *photo = [def objectForKey:@"defCarPhotoStr"];
    
    self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 60)];
    self.photoImg.layer.cornerRadius = 5;
    self.photoImg.layer.masksToBounds = YES;
    self.photoImg.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
    self.photoImg.layer.borderWidth = 1;
    [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [topBgBtn addSubview:self.photoImg];
    
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 20, SCREEN_WIDTH-118, 30)];
    self.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",carBrand,carseries,caryear,carmodel];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = [UIFont systemFontOfSize:18];
    [topBgBtn addSubview:self.nameLab];
    
    self.chepaiLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 60, SCREEN_WIDTH-118, 20)];
    self.chepaiLab.text = chepaiLab;
    self.chepaiLab.textAlignment = NSTextAlignmentLeft;
    self.chepaiLab.font = [UIFont systemFontOfSize:15];
    self.chepaiLab.textColor = [UIColor grayColor];
    [topBgBtn addSubview:self.chepaiLab];
    
    UILabel *moreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 60, 60, 20)];
    moreLab.text = @"更多>>";
    moreLab.textAlignment = NSTextAlignmentLeft;
    moreLab.font = [UIFont systemFontOfSize:15];
    moreLab.textColor = [UIColor grayColor];
    [topBgBtn addSubview:moreLab];
    
    //-------预约项目
    self.sevView = [[UIView alloc] init];
    self.sevView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.sevView];
    UIView *lineSEV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineSEV1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [self.sevView addSubview:lineSEV1];
    
    UIView *lineSEV2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.sevView.frame.size.height-1, SCREEN_WIDTH, 1)];
    lineSEV2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [self.sevView addSubview:lineSEV2];
    
    UILabel *xianmuLab = [[UILabel alloc] initWithFrame:CGRectMake(10,5,SCREEN_WIDTH-10,20)];
    xianmuLab.text = @"可选服务项目:";
    xianmuLab.textColor = [UIColor blackColor];
    xianmuLab.textAlignment = NSTextAlignmentLeft;
    [self.sevView addSubview:xianmuLab];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 35;//用来控制button距离父视图的高
    for (int i = 0; i < serListArr.count; i++) {
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 1000 + i;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor lightGrayColor];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //根据计算文字的大小
        product *aPro = [serListArr objectAtIndex:i];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [aPro.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:aPro.title forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 25 , 25);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 25 > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 25, 25);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        _serViewHight = h;
        [self.sevView addSubview:button];
        [_btnArr addObject:button];
    }
    self.sevView.frame = CGRectMake(0, CGRectGetMaxY(topBgBtn.frame)+10, SCREEN_WIDTH, _serViewHight+35);
    lineSEV2.frame = CGRectMake(0, self.sevView.frame.size.height-1, SCREEN_WIDTH, 1);
    
    //加入照片
    [self initCollectionView];
    
    //联系人//联系电话
    UIView *lianxiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame)+10, SCREEN_WIDTH, 80)];
    lianxiView.backgroundColor = [UIColor whiteColor];
    UIView *lianxiVline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lianxiVline.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [lianxiView addSubview:lianxiVline];
    UIView *lianxiVline1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lianxiVline1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [lianxiView addSubview:lianxiVline1];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = @"预约联系人:";
    nameLab.textColor = RGBACOLOR(83, 83, 83, 1);
    nameLab.textAlignment = NSTextAlignmentRight;
    nameLab.font = [UIFont systemFontOfSize:16];
    [lianxiView addSubview:nameLab];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame)+15, 0, SCREEN_WIDTH-CGRectGetMaxX(nameLab.frame)-15, 40)];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@""]) {
//        <#statements#>
//    }
    nameTF.placeholder = @"联系人";
    [nameTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    nameTF.delegate=self;
    nameTF.tag = 100;
    nameTF.clearButtonMode = UITextFieldViewModeAlways;
    nameTF.backgroundColor=[UIColor clearColor];
    nameTF.borderStyle=UITextBorderStyleNone;
    [lianxiView addSubview:nameTF];
    
    
    UILabel *telLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
    telLab.backgroundColor = [UIColor clearColor];
    telLab.text = @"预约电话:";
    telLab.textColor = RGBACOLOR(83, 83, 83, 1);
    telLab.textAlignment = NSTextAlignmentRight;
    telLab.font = [UIFont systemFontOfSize:16];
    [lianxiView addSubview:telLab];
    
    telTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(telLab.frame)+15, 40, SCREEN_WIDTH-CGRectGetMaxX(telLab.frame)-15, 40)];
    telTF.placeholder = @"联系电话";
    [telTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    telTF.delegate=self;
    telTF .clearButtonMode = UITextFieldViewModeAlways;
    telTF.tag = 101;
    telTF.backgroundColor=[UIColor clearColor];
    telTF.borderStyle=UITextBorderStyleNone;
    [lianxiView addSubview:telTF];
    
    [self.mainScrollView addSubview:lianxiView];
    
    
    //-------预约时间
    UIButton *yuyueBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lianxiView.frame), SCREEN_WIDTH, 40)];
    yuyueBtn2.backgroundColor = [UIColor whiteColor];
    yuyueBtn2.tag = 1000;
    [yuyueBtn2 addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:yuyueBtn2];
    
    UILabel *selBtn2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    selBtn2Lab.backgroundColor = [UIColor clearColor];
    selBtn2Lab.text = @"预约时间:";
    selBtn2Lab.textColor = RGBACOLOR(83, 83, 83, 1);
    selBtn2Lab.textAlignment = NSTextAlignmentRight;
    selBtn2Lab.font = [UIFont systemFontOfSize:16];
    [yuyueBtn2 addSubview:selBtn2Lab];
    
    _yuyueTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, SCREEN_WIDTH-170, 40)];
    _yuyueTime.backgroundColor = [UIColor clearColor];
    _yuyueTime.text = @"选择时间";
    _yuyueTime.textColor = RGBACOLOR(237, 65, 53, 1);
    _yuyueTime.textAlignment = NSTextAlignmentRight;
    _yuyueTime.font = [UIFont systemFontOfSize:14];
    [yuyueBtn2 addSubview:_yuyueTime];
    
    UIImageView *ima2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 13, 10, 14)];
    ima2.image = [UIImage imageNamed:@"jiantou"];
    [yuyueBtn2 addSubview:ima2];
    
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line10.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [yuyueBtn2 addSubview:line10];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    line4.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [yuyueBtn2 addSubview:line4];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yuyueBtn2.frame)+10, SCREEN_WIDTH, 80)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:btnView];
    
    //上门服务
    UIButton *btn1= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(selHomeArea) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn1];
    UILabel *lb1= [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH/4, 40)];
    lb1.text = @"上门取车";
    lb1.font = [UIFont systemFontOfSize:14];
    [btn1 addSubview:lb1];
    _homeAreaLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH-SCREEN_WIDTH/4-30, 40)];
    _homeAreaLab.backgroundColor = [UIColor clearColor];
    _homeAreaLab.text = @"选择地址";
    _homeAreaLab.textColor = [UIColor lightGrayColor];
    _homeAreaLab.textAlignment = NSTextAlignmentRight;
    _homeAreaLab.font = [UIFont systemFontOfSize:14];
    [btn1 addSubview:_homeAreaLab];
    _selImgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 24, 24)];
    [_selImgBtn1 setImage:[UIImage imageNamed:@"weixuanzhong"] forState:0];
    [btn1 addSubview:_selImgBtn1];

    
    UIImageView *imag2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 13, 10, 14)];
    imag2.image = [UIImage imageNamed:@"jiantou"];
    [btn1 addSubview:imag2];
    
    
    //-------到店服务
    UIButton *btn2= [[UIButton alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(goShop) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn2];
    UILabel *lb2= [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH/4, 40)];
    lb2.text = @"到店服务";
    lb2.font = [UIFont systemFontOfSize:14];
    [btn2 addSubview:lb2];
    _selImgBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 24, 24)];
    [_selImgBtn2 setImage:[UIImage imageNamed:@"weixuanzhong"] forState:0];
    [btn2 addSubview:_selImgBtn2];
    
    goShop = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH-SCREEN_WIDTH/4-30, 40)];
    goShop.backgroundColor = [UIColor clearColor];
    goShop.text = @"查看店铺位置";
    goShop.textColor = [UIColor lightGrayColor];
    goShop.textAlignment = NSTextAlignmentRight;
    goShop.font = [UIFont systemFontOfSize:14];
    [btn2 addSubview:goShop];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18, 13, 10, 14)];
    imag1.image = [UIImage imageNamed:@"jiantou"];
    [btn2 addSubview:imag1];
    
    UIView *lineBtn1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineBtn1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btnView addSubview:lineBtn1];
    UIView *lineBtn2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineBtn2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btnView addSubview:lineBtn2];
    UIView *lineBtn3 = [[UIView alloc] initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, 1)];
    lineBtn3.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [btnView addSubview:lineBtn3];
    
    
    //预约备注
    UIView *beizhuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame)+10, SCREEN_WIDTH, 80)];
    beizhuView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:beizhuView];
    UIView *lineB1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineB1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [beizhuView addSubview:lineB1];
    
    UIView *lineB2 = [[UIView alloc] initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, 1)];
    lineB2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [beizhuView addSubview:lineB2];
    
    textview = [[UITextView alloc] initWithFrame:CGRectMake ( 0 , 0 , SCREEN_WIDTH , 80 )];
    textview.backgroundColor = [UIColor clearColor];
    textview.font = [UIFont systemFontOfSize:15];
    textview.text = @"  备注:";
    textview.delegate = self;
    [beizhuView addSubview:textview];
    
    
    
    UIButton *yuyueBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(beizhuView.frame)+20, SCREEN_WIDTH-80, 40)];
    yuyueBtn.backgroundColor = COLOR_NAVIVIEW;
    [yuyueBtn setTitle:@"提交预约" forState:UIControlStateNormal];
    [yuyueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yuyueBtn.layer.cornerRadius = 10;
    yuyueBtn.layer.masksToBounds = YES;
    [yuyueBtn addTarget:self action:@selector(yuyueBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:yuyueBtn];
    
}
- (void)handleClick:(UIButton *)btn{
    
    if (btn.backgroundColor == [UIColor lightGrayColor]) {
        btn.backgroundColor = COLOR_NAVIVIEW;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else{
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}
-(void)chooseTime:(UIButton *)btn
{
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.selectedDate) {
        hsdpvc.date = self.selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
}
#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDate *  senddate=[NSDate date];
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:senddate];
    NSInteger result = [date compare:nextDat];
    if (result==-1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前时间无法提供服务,请至少提前一天预约" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
        _yuyueTime.text = [dateFormater stringFromDate:date];
        _yuyueTime.textColor = [UIColor blackColor];
        self.selectedDate = date;
    }
    
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method
{
    
}
-(void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method
{
    
}

-(void)selHomeArea
{
    AdressViewController *address = [[AdressViewController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
    address.fromStr = @"选择";
    address.retrunBlock=^(NSString *str){
        
        if(str){
            _homeAreaLab.text = str;
            [_selImgBtn1 setImage:[UIImage imageNamed:@"xuanzhong"] forState:0];
            [_selImgBtn2 setImage:[UIImage imageNamed:@"weixuanzhong"] forState:0];
            _typeStr = @"0";
            _selImgBtn1.enabled = NO;
            _selImgBtn2.enabled = NO;
            
        }
    };
}
-(void)goShop
{
    goHomeViewController *Shop = [[goHomeViewController alloc] init];
    [self.navigationController pushViewController:Shop animated:YES];
    Shop.retrunBlock=^(NSString *str){
        
        if(str){
            goShop.text = str;
            [_selImgBtn2 setImage:[UIImage imageNamed:@"xuanzhong"] forState:0];
            [_selImgBtn1 setImage:[UIImage imageNamed:@"weixuanzhong"] forState:0];
            _typeStr = @"1";
            _selImgBtn1.enabled = NO;
            _selImgBtn2.enabled = NO;
            
        }
    };
}


-(void)yuyueBtn
{
    [self UpdateShopInfoForImageRequest:_allPhotoArr];
}
#pragma mark--------代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allPhotoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    photoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    NSInteger index = _allPhotoArr.count-1 - indexPath.row;
  // cell.photoImgView.image = [_allPhotoArr objectAtIndex:index];
    [cell.photoImageBtn setBackgroundImage:[_allPhotoArr objectAtIndex:index] forState:UIControlStateNormal];
    if (indexPath.row == _allPhotoArr.count -1) {
        cell.photoImageBtn.enabled = NO;
        cell.cancelBtn.hidden = YES;
    }else
    {
        cell.cancelBtn.hidden = NO;
        cell.cancelBtn.tag = 100+indexPath.row;
        [cell.photoImageBtn addTarget:self action:@selector(fangda:) forControlEvents:UIControlEventTouchUpInside];
        cell.photoImageBtn.enabled = YES;
        [cell.cancelBtn addTarget:self action:@selector(cancelBTnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}
-(void)fangda:(UIButton *)btn
{
    [SJAvatarBrowser showImage:btn];//调用方法
}

-(void)changeCar
{
    ChooseCarViewController *chooseCar = [[ChooseCarViewController alloc] init];
    [self.navigationController pushViewController:chooseCar animated:YES];
    chooseCar.retrunBlock=^(ListCarModel *aCar){
        [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,aCar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        self.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",aCar.carbrand,aCar.carseries,aCar.caryear,aCar.carmodel];
        self.chepaiLab.text = aCar.licenseID;
    
        
    };
}


-(void)cancelBTnClick:(UIButton *)btn
{
    [_allPhotoArr removeObjectAtIndex:_allPhotoArr.count-1- btn.tag+100];
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark -- item的点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _allPhotoArr.count-1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self didSelectIndex:0];
        }];
//        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [self didSelectIndex:1];
//        }];
        UIAlertAction *cancelAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [self didSelectIndex:1];
        }];
        [alertController addAction:cancelAction1];
//        [alertController addAction:cancelAction2];
        [alertController addAction:cancelAction3];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (indexPath.row < _allPhotoArr.count-1)
    {
        
    }
    
    
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark -- 菜单点击方法
-(void)didSelectIndex:(NSInteger)index{
//    NSUInteger sourceType = 0;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if (index==1) {//取消按钮
        return;
    }

    imagePickerController.delegate = self;
    
    UIView * vi = [[UIView alloc]
                   initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    vi.backgroundColor = [UIColor greenColor];
    
    vi.layer.cornerRadius = 100/2;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_allPhotoArr addObject:image];
    [_collectionView reloadData];
    
}
//图片
-(void)UpdateShopInfoForImageRequest:(NSMutableArray *)imageArr
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"提交预约中请稍后";
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    for (int i = 0; i<_btnArr.count; i++) {
        UIButton *btn = [_btnArr objectAtIndex:i];
        if (btn.backgroundColor == [UIColor lightGrayColor]) {
        
        }else{
            product *aPro = [serListArr objectAtIndex:i];
            [serIDListArr addObject:aPro.p_guid];
            [serNameArr addObject:aPro.title];
        }
    }
    
    for (int i = 0; i<_btnArr1.count; i++) {
        UIButton *btn = [_btnArr1 objectAtIndex:i];
        if (btn.backgroundColor == [UIColor lightGrayColor]) {
            
        }else{
            product *aPro = [serListArr1 objectAtIndex:i];
            [serIDListArr addObject:aPro.p_guid];
            [serNameArr addObject:aPro.title];

        }
    }
    
    for (int i = 0; i<serIDListArr.count; i++) {
        if(i==0){
            _IDStr = [serIDListArr objectAtIndex:0];
            
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",[serIDListArr objectAtIndex:i]];
            _IDStr = [NSString stringWithFormat:@"%@|%@",_IDStr,str];
        }
    }
    
    for (int i = 0; i<serNameArr.count; i++) {
        if(i==0){
            _nameStr = [serNameArr objectAtIndex:0];
            
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",[serNameArr objectAtIndex:i]];
            _nameStr = [NSString stringWithFormat:@"%@|%@",_nameStr,str];
        }
    }
    NSLog(@"name===%@",_nameStr);
    for (int i = 0; i<_allPhotoArr.count-1; i++) {
        if(i==0){
            NSData* imageData = UIImageJPEGRepresentation([_allPhotoArr  objectAtIndex:1],0.5);
            _imageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        }else{
            
            NSData* imageData = UIImageJPEGRepresentation([_allPhotoArr  objectAtIndex:i+1],0.5);
            NSString *temImageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            _imageString = [NSString stringWithFormat:@"%@|%@",_imageString,temImageString];
        }
    }
   // NSLog(@"ima====%@",_imageString);
    
    
    
    if ([_typeStr isEqualToString:@"0"]){
        
        strDic=@{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"mycarid":[[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"],@"images":_imageString,@"ProductId":_IDStr,@"pname":_nameStr,@"Remark":textview.text,@"vname":nameTF.text,@"phone":telTF.text,@"address":_homeAreaLab.text,@"ReservetTime":_yuyueTime.text,@"type":@"0"};
        
        
    }else if([_typeStr isEqualToString:@"1"]){
        
        strDic=@{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"mycarid":[[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"],@"images":_imageString,@"ProductId":_IDStr,@"pname":_nameStr,@"Remark":textview.text,@"vname":nameTF.text,@"phone":telTF.text,@"address":goShop.text,@"ReservetTime":_yuyueTime.text,@"type":@"1"};
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择服务方式" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [manager POST:ADD_NEW_RESERVE parameters:strDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *stateNum =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"验证码:%@",stateNum);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预约成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
        
//        if ([stateNum intValue]==1) {
//            
//            
            HUD.labelText = @"预约成功!";
            [HUD hide:YES afterDelay:1];
//        }else{
//            //这可能会发生重复——imageString等清空
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"err===%@",error);
        HUD.labelText = @"请检查网络";
        [HUD hide:YES afterDelay:1];
    }];

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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多输入100字" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [textview resignFirstResponder];
    [nameTF resignFirstResponder];
    [telTF resignFirstResponder];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //设置动画的名字
    if (_up==YES) {
        [self animateTextView:textView up: NO];
    }
    [self animateTextView: textView up: YES];
    _up=YES;
}

//在UITextField 编辑完成调用方法
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up: NO];
    _up=NO;
}

//视图上移的方法
- (void) animateTextView: (UITextView *) textView up: (BOOL) isup
{
    //设置视图上移的距离，单位像素
    const int movementDistance = 216; // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = (isup ? -movementDistance : movementDistance);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.view.frame = CGRectOffset(self.view.frame, 0, movement);
    }];
    
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
    const int movementDistance = 216; // tweak as needed
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
//    [self animateTextField:textField up:YES];
//    _up = YES;
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
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

