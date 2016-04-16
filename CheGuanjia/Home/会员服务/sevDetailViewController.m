//
//  sevDetailViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "sevDetailViewController.h"
#import "PayViewController.h"

#define GET_TYPE Main_Ip"productType.asmx/find_guid"
#define GET_ORDER Main_Ip"pay.asmx/getoid"

@interface sevDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIImageView *phtotImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *introLab;
@property(nonatomic,strong)UIButton *levelBtn;
@end

@implementation sevDetailViewController
{
    NSMutableArray *_btnTitArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"商品详情";
    NSLog(@"id===%@",self.passProduct.GUID);
    
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-38, 25, 30, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"dianhua"] forState:0];
    [self.rightBtn addTarget:self action:@selector(makeCallbtn) forControlEvents:UIControlEventTouchUpInside];
    [self getPriceLevel];

}
-(void)makeCallbtn
{
    NSString *number = @"4007076222";
    
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _btnTitArr = [[NSMutableArray alloc] init];
    _nextProductType = [[ProductType alloc] init];
    _levelBtn.backgroundColor = [UIColor lightGrayColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _btnTitArr = nil;
}
-(void)getPriceLevel
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
        
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:GET_TYPE parameters:@{@"guid":self.passProduct.GUID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            ProductType *aType = [ProductType productWithDict:dic];
            [_btnTitArr addObject:aType];
        }
        [HUD hide:YES];
        [self initScrollView];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
    
}
-(void)initScrollView{
    self.mainScrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    [self.view addSubview:self.mainScrollView];
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT+150+200+180);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.showsVerticalScrollIndicator=NO;
    self.mainScrollView.showsHorizontalScrollIndicator=NO;
    self.mainScrollView.scrollEnabled=YES;
    
    [self initView];
    [self initBtnView];
    
}
-(void)initView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 180)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:topView];
    if (SCREEN_HEIHT<600) {
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 80, 55)];
    }else{
        self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 100, 70)];
    }
    self.phtotImg.layer.cornerRadius = 5;
    self.phtotImg.layer.masksToBounds =YES;
    NSLog(@"");
    [self.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,self.passProduct.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [topView addSubview:self.phtotImg];
    
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 22, 110, 20)];
    self.titleLab.textAlignment=NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.text = self.passProduct.title;
    [topView addSubview:self.titleLab];
    
    self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8+115 , 22,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+110+10) , 25)];
    self.priceLab.textAlignment=NSTextAlignmentRight;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    self.priceLab.textColor = RGBACOLOR(237, 65, 53, 1);
    float price = [self.passProduct.price floatValue];
    if([self.stateStr isEqualToString:@"出行宝"]){
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元/年",price];
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元",price];
    }
    [topView addSubview:self.priceLab];
    
    self.introLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 42,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 40)];
    self.introLab.textAlignment=NSTextAlignmentLeft;
    self.introLab.font = [UIFont systemFontOfSize:13];
    self.introLab.textColor = [UIColor lightGrayColor];
    self.introLab.numberOfLines = 0;
    self.introLab.text = self.passProduct.introduction;
    [topView addSubview:self.introLab];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [topView addSubview:line2];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120 , SCREEN_WIDTH, 1)];
    line1.backgroundColor = [UIColor grayColor];
    [topView addSubview:line1];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 179 , SCREEN_WIDTH, 1)];
    line3.backgroundColor = [UIColor grayColor];
    [topView addSubview:line3];
    
    int kBtnViewW = 70;
    
    CGFloat marginX = (SCREEN_WIDTH - _btnTitArr.count * kBtnViewW) / (_btnTitArr.count + 1);
    
    for (int i = 0; i < _btnTitArr.count; i++) {
        // 列
        int col = i % _btnTitArr.count;
        
        CGFloat x =  marginX + col * (marginX + kBtnViewW);
        
        // 设置Btn
        
        _levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _levelBtn.frame = CGRectMake(x, 135, kBtnViewW, 30);
        _levelBtn.tag = i + 500;
        _levelBtn.backgroundColor = [UIColor lightGrayColor];
        _levelBtn.layer.cornerRadius = 5;
        _levelBtn.layer.masksToBounds = YES;
        ProductType *aType = [_btnTitArr objectAtIndex:i];
        [_levelBtn setTitle:[NSString stringWithFormat:@"%@",aType.type] forState:UIControlStateNormal];
        _levelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_levelBtn addTarget:self action:@selector(chooseLevel:) forControlEvents:UIControlEventTouchUpInside];
        
        _levelBtn.adjustsImageWhenHighlighted = NO;
        
        [topView addSubview:_levelBtn];
        
    }
    
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 188, SCREEN_WIDTH, SCREEN_HEIHT-188-45)];
    web.delegate=self;
    [self.mainScrollView addSubview:web];
    NSURL *url=[NSURL URLWithString:self.passProduct.detail];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    
}
-(void)initBtnView
{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-45   , SCREEN_WIDTH, 45)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [btnView addSubview:line2];

    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, SCREEN_WIDTH-60, 35)];
    buyBtn.backgroundColor = [UIColor orangeColor];
    [buyBtn setTitle:@"购买保障" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 10;
    buyBtn.layer.masksToBounds = YES;
    [buyBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:buyBtn];
}
-(void)payBtnClick
{
    if (!_nextProductType.GUID) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择服务档次" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"订单生成中";
        [HUD show:YES];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10;
        
        NSLog(@"cid===%@  pid==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],_nextProductType.GUID);
        [manager POST:GET_ORDER parameters:@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"pid":_nextProductType.GUID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = [arr objectAtIndex:0];
            NSString *orderID = [dic objectForKey:@"oid"];
            NSString *timeStr = [dic objectForKey:@"time"];
            
            PayViewController *pay = [[PayViewController alloc] init];
            [self.navigationController pushViewController:pay animated:YES];
            pay.stateStr = self.stateStr;
            pay.SpassProduct = self.passProduct;
            pay.orderIDStr = orderID;
            pay.timeStr = timeStr;
            pay.passType = _nextProductType;
            
            [HUD hide:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
    }
}

-(void)chooseLevel:(UIButton *)btn
{
    for (int i = 0; i<_btnTitArr.count ; i++) {
        UIButton *selBtn = [self.view viewWithTag:500+i];
        selBtn.backgroundColor = [UIColor lightGrayColor];
    }
    btn.backgroundColor = RGBACOLOR(237, 65, 53, 1);
    ProductType *aType = [_btnTitArr objectAtIndex:btn.tag - 500];
    
    _nextProductType = aType;
    float price = [aType.price floatValue];
    if([self.stateStr isEqualToString:@"出行宝"]){
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元/年",price];
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"价格:%0.2f元",price];
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
