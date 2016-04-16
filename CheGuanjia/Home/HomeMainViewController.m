//
//  HomeMainViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 15/12/31.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import "HomeMainViewController.h"
#import "MyCarListViewController.h"
#import "MemberViewController.h"
#import "weizhangViewController.h"
#import "signinViewController.h"
#import "InfoListViewController.h"
#import "MakeYuYueViewController.h"
#import "webViewController.h"

#define GET_TOPIMG Main_Ip"Banner.asmx/find_all"
#define GET_DEFCAR Main_Ip"mycar.asmx/showDefaultCar"
#define GET_XIANXING Main_Ip"City.asmx/xianHao"
#define GET_MYPRODUCT Main_Ip"MyProduct.asmx/findOrderByCar"



//btn设置（方形）
#define kBtnViewW (SCREEN_WIDTH-150)/2
#define kBtnViewW2  SCREEN_WIDTH/2
//btn每行的列数
#define kColCount 2

//起始y坐标
#define kStartY   0

@interface HomeMainViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation HomeMainViewController
{
    UIButton *_threeBtn;
    UIButton *_twoBtn;
    NSArray *_xianArr;
    UIView *_weaBgView;
    UILabel *_weaLab;
    UIView *_bgView;
    
    NSDictionary *_weatherDic;
    UIImageView *_weaImg;
    UILabel *_weaHighLowLab;
    NSMutableArray *_topImgArr;
    
    UIImageView *_carImg;
    UILabel *_titleLab;
    
    UILabel *_xianNumLab;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册监听，观察登陆值的变化
    
    NSLog(@"cid===%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDefCar) name:@"changeDefCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity) name:@"changeCity" object:nil];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _xianArr = [[NSArray alloc] init];
    _topImgArr = [[NSMutableArray alloc] init];
    
    
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVHEIGHT)];
    navBar.backgroundColor=COLOR_BGCOLOR_BLUE;
    navBar.alpha=0.8;
    [self.view addSubview:navBar];
    
    UIView *navLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.6)];
    navLineView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:navLineView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 64);
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:leftBtn];
    UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 30, 28, 20)];
    leftImgV.image = [UIImage imageNamed:@"gerenzhongxin"];
    [leftBtn addSubview:leftImgV];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 64);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:rightBtn];
    UIImageView *rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-35, 30, 20, 20)];
    rightImgV.image = [UIImage imageNamed:@"xiaoxi"];
    [rightBtn addSubview:rightImgV];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    titLab.text = @"方向盘车管家";
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont systemFontOfSize:18];
    titLab.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:titLab];
    
    _weaBgView= [[UIView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH-SCREEN_WIDTH/3+19, 43)];
    _weaBgView.backgroundColor = [UIColor whiteColor];
    
    _weaLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 25)];
    _weaLab.text = @"天气";
    _weaLab.textColor = [UIColor orangeColor];
    _weaLab.layer.borderWidth = 1;
    _weaLab.textAlignment = NSTextAlignmentCenter;
    _weaLab.layer.borderColor = [UIColor orangeColor].CGColor;
    [_weaBgView addSubview:_weaLab];
    
    _weaImg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 25, 25)];
    _weaImg.image = [UIImage imageNamed:@"photoNo"];
    [_weaBgView addSubview:_weaImg];
    
    _weaHighLowLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH-100, 25)];
    _weaHighLowLab.text = @"0℃~0℃  晴  适宜洗车";
    _weaHighLowLab.textColor = COLOR_BLACK;
    _weaHighLowLab.font = [UIFont systemFontOfSize:14];
    _weaHighLowLab.textAlignment = NSTextAlignmentLeft;
    [_weaBgView addSubview:_weaHighLowLab];
    
    
    
    
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    [self initTopView];
    [self getTopImgData];
    
    [self initSixBlock];
    
    [self getWeather];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.topImgView openTimer];//开启定时器
    });
}

-(void)getTopImgData
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_TOPIMG parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *imgListArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i = 0; i<imgListArr.count; i++) {
            NSString *topImgUrlStr =[NSString stringWithFormat:@"%@/photo/banner/%@",Main_Ip,[[imgListArr objectAtIndex:i] objectForKey:@"photo"]];
            [_topImgArr addObject:topImgUrlStr];
        }
        [self.topImgView setArray:_topImgArr];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)initTopView
{
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, BANNER_HEIGHT+80, SCREEN_WIDTH, 45)];
    tipView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:tipView];
    
    
    UIImageView *xianImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, SCREEN_WIDTH/5, 17)];
    xianImg.image = [UIImage imageNamed:@"chuxing"];
    [tipView addSubview:xianImg];
    
    UIView *lineS= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5+15, 8, 1, 29)];
    lineS.backgroundColor = COLOR_LINE;
    [tipView addSubview:lineS];
    
    _bgView= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5+20, 1, SCREEN_WIDTH-SCREEN_WIDTH/5-20, 43)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [tipView addSubview:_bgView];
    
    UILabel *xianLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 25)];
    xianLab.text = @"限行";
    xianLab.textColor = [UIColor orangeColor];
    xianLab.layer.borderWidth = 1;
    xianLab.textAlignment = NSTextAlignmentCenter;
    xianLab.layer.borderColor = [UIColor orangeColor].CGColor;
    [_bgView addSubview:xianLab];
    
    [self getXianxing];
    
    UIView *line1= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = COLOR_LINE;
    [tipView addSubview:line1];
    UIView *line2= [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
    line2.backgroundColor = COLOR_LINE;
    [tipView addSubview:line2];
    
    /* 广告栏 */
    self.topImgView = [[AdvertisingColumn alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT+80)];
    self.topImgView.backgroundColor = [UIColor blackColor];

    [self.mainScrollView addSubview:self.topImgView];
}

- (void)startTimer{
    
    [_bgView addSubview:_weaBgView];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(getTipBanner) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

-(void)getTipBanner
{
    if (_weaBgView.frame.origin.y == -44)
    {
        [UIView animateWithDuration:1
                         animations:^{
                             _weaBgView.frame = CGRectMake(0, 1, SCREEN_WIDTH-SCREEN_WIDTH/3+19, 43);
                             
                         }
                         completion:^(BOOL finished){
                         }];
        [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _weaBgView.frame = CGRectMake(0, -44, SCREEN_WIDTH-SCREEN_WIDTH/3+19, 43);
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        
    }
}

-(void)initSixBlock
{
    UIView *carView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImgView.frame)+46, SCREEN_WIDTH, 50)];
    carView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:carView];
    
    UIView *lineCl2= [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    lineCl2.backgroundColor = COLOR_LINE;
    [carView addSubview:lineCl2];
    
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3*2, 50)];
    bgBtn.backgroundColor = [UIColor clearColor];
    [carView addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(goCarList) forControlEvents:UIControlEventTouchUpInside];
    
    _carImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 45, 30)];
    _carImg.backgroundColor = [UIColor clearColor];
    [bgBtn addSubview:_carImg];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH/3*2-80, 50)];
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.numberOfLines = 0;
    _titleLab.textColor = [UIColor lightGrayColor];
    [bgBtn addSubview:_titleLab];
    
    UIView *lineS = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 8, 1, 34)];
    lineS.backgroundColor = COLOR_LINE;
    [carView addSubview:lineS];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+20, 10, SCREEN_WIDTH/3-40, 30)];
    searchBtn.backgroundColor = COLOR_NAVIVIEW;
    searchBtn.layer.cornerRadius =5;
    [searchBtn setTitle:@"违章查询" forState:0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:0];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn addTarget:self action:@selector(chaxunTwoBtn:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.adjustsImageWhenHighlighted = NO;
    [carView addSubview:searchBtn];
    
    [self getDefCar];
    
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImgView.frame)+110, SCREEN_WIDTH, kBtnViewW+10)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:btnView];
    UIView *linel1= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    linel1.backgroundColor = COLOR_LINE;
    [btnView addSubview:linel1];
    UIView *linel2= [[UIView alloc] initWithFrame:CGRectMake(0, kBtnViewW+10, SCREEN_WIDTH, 1)];
    linel2.backgroundColor = COLOR_LINE;
    [btnView addSubview:linel2];
    
    NSArray *titleArr = @[@"服务商城",@"预约服务"];
    CGFloat marginX = (SCREEN_WIDTH - kColCount * kBtnViewW) / (kColCount + 1);

    for (int i = 0; i < 2; i++) {
        
        CGFloat x = marginX + i * (marginX + kBtnViewW);
        CGFloat y = 0 ;
        // 设置Btn
        
        _threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _threeBtn.frame = CGRectMake(x, y, kBtnViewW, kBtnViewW);
        _threeBtn.tag = i + 100;
        _threeBtn.backgroundColor = [UIColor clearColor];
        
        [_threeBtn addTarget:self action:@selector(threebtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _threeBtn.adjustsImageWhenHighlighted = NO;
        
        [btnView addSubview:_threeBtn];
        
        //btn里加入圆形图片
        NSArray *bgImageArr =@[@"huiyuanfuwu2",@"wodeyuyue2"];
        UIImageView *littleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kBtnViewW/6, 10, kBtnViewW/3*2, kBtnViewW/3*2)];
        littleImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",bgImageArr[i]]];
        [_threeBtn addSubview:littleImgView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        if (SCREEN_HEIHT<600) {
            nameLabel.frame = CGRectMake(0, CGRectGetMaxY(littleImgView.frame), kBtnViewW, 20);
            nameLabel.font = [UIFont systemFontOfSize:15];
        }else{
            nameLabel.frame = CGRectMake(0, CGRectGetMaxY(littleImgView.frame)+5, kBtnViewW, 20);
            nameLabel.font = [UIFont systemFontOfSize:15];
        }
        nameLabel.text=[titleArr objectAtIndex:i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        [_threeBtn addSubview:nameLabel];
    }

    UIButton *callBtn= [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.topImgView.frame)+110+kBtnViewW+45, SCREEN_WIDTH-60, 40)];
    callBtn.backgroundColor = COLOR_RED;
    callBtn.layer.cornerRadius = 8;
    callBtn.layer.masksToBounds =YES;
    [callBtn setTitle:@"呼叫车管家" forState:0];
    [callBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.mainScrollView addSubview:callBtn];
    [callBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)getDefCar
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *defCarGUID = [def valueForKey:@"defCarGUIDStr"];
    NSLog(@"defGUID===%@",defCarGUID);

    if (!defCarGUID) {
        _carImg.image = [UIImage imageNamed:@"che2"];
        _titleLab.text = @"添加爱车车型";
    }else{
        
        NSString *photoUrl = [def valueForKey:@"defCarPhotoStr"];
        NSString *carBrand = [def valueForKey:@"defCarbrandStr"];
        NSString *carser = [def valueForKey:@"defCarseriesStr"];
        NSString *carYear = [def valueForKey:@"defCaryearStr"];
        NSString *carPai = [def valueForKey:@"defCarIDStr"];
        [_carImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,photoUrl]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        _titleLab.text = [NSString stringWithFormat:@"%@ %@ %@\n%@",carBrand,carser,carYear,carPai];
        _titleLab.textColor = [UIColor grayColor];
        
    }
}
-(void)makeCall
{
    NSString *number = @"4007076222";
    
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

-(void)leftItemClick{
    [[SliderViewController sharedSliderController] leftItemClick];
}
-(void)rightItemClick{
    [[SliderViewController sharedSliderController].navigationController pushViewController:[[InfoListViewController alloc] init] animated:YES];
}

-(void)goCarList
{
    [[SliderViewController sharedSliderController].navigationController pushViewController:[[MyCarListViewController alloc] init] animated:YES];
}

-(void)threebtnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
        {
            [[SliderViewController sharedSliderController].navigationController pushViewController:[[MemberViewController alloc] init] animated:YES];
        }
            break;
        case 101:
        {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"];
            if (!str)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置默认车型" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                
                [self getSerArrDataSource];
            
            }
        }
            break;
        case 102:
        {
            NSString *number = @"4007076222";
            
            NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
            break;
            
        default:
            break;
    }
}
-(void)getSerArrDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *Dic=@{@"mycarid":[[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"],@"type":@"2"};
    
    [manager POST:GET_MYPRODUCT parameters:Dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (arr.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先为该车购买服务" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            alert.tag=9999;
            [alert show];
        }else{
            
            [[SliderViewController sharedSliderController].navigationController pushViewController:[[MakeYuYueViewController alloc] init] animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}
-(void)chaxunTwoBtn:(UIButton *)btn
{
    webViewController *web = [[webViewController alloc] init];
//    web.string = [NSString stringWithFormat:@"%@/HBJG.html",Main_Ip];
    web.string = @"http://192.168.0.6/HBJG.html";
    web.titleText = @"违章查询";
    [[SliderViewController sharedSliderController].navigationController pushViewController:web animated:YES];
}

-(void)getXianxing
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *cityStr;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"City"]) {
        cityStr = @"天津";
    }else{
        cityStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    }
    
    [manager POST:GET_XIANXING parameters:@{@"area":cityStr}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *cityArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *haoStr = [[cityArr firstObject] objectForKey:@"dis"];
        _xianArr = [haoStr componentsSeparatedByString:@"|"];

        if (_xianArr.count == 0) {

            if (!_xianNumLab) {
                
                _xianNumLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 150, 29)];
                _xianNumLab.text = @"今日不限行";
                _xianNumLab.font = [UIFont systemFontOfSize:17];
                _xianNumLab.textColor = COLOR_RED;
                _xianNumLab.textAlignment = NSTextAlignmentCenter;
                _xianNumLab.layer.borderColor = COLOR_RED.CGColor;
                
                
                [_bgView addSubview:_xianNumLab];
            }else{
                _xianNumLab.text = @"今日不限行";
            }

        }else{
            if (!_xianNumLab) {
                
                NSString *xianhaoStr = [_xianArr firstObject];
                for (int i = 1 ; i<_xianArr.count; i++) {
                    xianhaoStr = [NSString stringWithFormat:@"%@  |  %@",xianhaoStr,[_xianArr objectAtIndex:i]];
                }
                
                _xianNumLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 150, 29)];
                _xianNumLab.text = xianhaoStr;
                _xianNumLab.font = [UIFont systemFontOfSize:17];
                _xianNumLab.textColor = COLOR_RED;
                _xianNumLab.textAlignment = NSTextAlignmentCenter;
                _xianNumLab.layer.borderColor = COLOR_RED.CGColor;
                
                
                [_bgView addSubview:_xianNumLab];
            }else{
                NSString *xianhaoStr = [_xianArr firstObject];
                for (int i = 1 ; i<_xianArr.count; i++) {
                    xianhaoStr = [NSString stringWithFormat:@"%@  |  %@",xianhaoStr,[_xianArr objectAtIndex:i]];
                }
                _xianNumLab.text = xianhaoStr;
            }
        }
        
        [self startTimer];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)getWeather
{
    [UIManager showIndicator:@"查询中,请稍后。。。"];
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    
    [manager.requestSerializer setValue:@"044e341c8d79a3ee8e4762e8d953f7c1" forHTTPHeaderField:@"apikey"];
    
    NSString *cityStr;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"City"]) {
        cityStr = @"天津";
    }else{
        cityStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    }
    
    [manager GET:@"http://apis.baidu.com/heweather/weather/free" parameters:@{@"city":cityStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _weatherDic = [[responseObject objectForKey:@"HeWeather data service 3.0"] firstObject];
        
        if ([_weatherDic[@"status"] isEqualToString:@"ok"]) {
            
            //最高最低气温
            NSArray *sevenDayArr = _weatherDic[@"daily_forecast"];
            NSDictionary *todayDic = [sevenDayArr objectAtIndex:0];
            NSString *highStr = [todayDic[@"tmp"] objectForKey:@"max"];
            NSString *lowStr = [todayDic[@"tmp"] objectForKey:@"min"];
            
            //天气
            NSString *weaStr = [NSString stringWithFormat:@"%@",[[_weatherDic[@"now"] objectForKey:@"cond"] objectForKey:@"txt"]];
            
            //洗车建议
            NSString *xicheStr = [NSString stringWithFormat:@"%@洗车",[[_weatherDic[@"suggestion"] objectForKey:@"cw"] objectForKey:@"brf"]];
            
            _weaHighLowLab.text = [NSString stringWithFormat:@"%@℃~%@℃  %@  %@",lowStr,highStr,weaStr,xicheStr];
            
            
            
            //天气大图标id
            NSString *weatherIconID = [NSString stringWithFormat:@"%@",[[_weatherDic[@"now"] objectForKey:@"cond"] objectForKey:@"code"]];
            NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",weatherIconID]];
            [_weaImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"photoNo"]];
            
            
        }else{
            UIAlertView *aler=[[UIAlertView alloc]initWithTitle:nil message:@"该城市无法查询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [aler show];
            
            
        }
        
        [UIManager hiddenWithSuccess:0 title:@"查询成功!"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [aler show];
    }];
    
}

-(void)changeCity
{
    [_weaBgView removeFromSuperview];
    [self stopTimer];
    [self getWeather];
    [self getXianxing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
