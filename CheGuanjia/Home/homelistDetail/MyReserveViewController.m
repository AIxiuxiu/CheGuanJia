//
//  MyReserveViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/16.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyReserveViewController.h"
#import "ChooseCarViewController.h"
#import "MyReserveTableViewCell.h"
#import "MyProductModel.h"

#define GET_MYRESERVE Main_Ip"MyProduct.asmx/findProByCar"


@interface MyReserveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MyReserveViewController
{
    NSString *_stateStr;
    NSMutableArray *_dataArr;
    NSString *_carGUID;
    UIImageView *nodataImg;

}
-(void)getDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
        
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    NSString *typeStr;
    if ([_stateStr isEqualToString:@"出行宝"]) {
        typeStr = @"0";
    }else{
        typeStr = @"1";
    }
    
    [manager POST:GET_MYRESERVE parameters:@{@"type":typeStr,@"mycarid":[[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i=0; i<carArr.count; i++) {
            NSDictionary *dic = [carArr objectAtIndex:i];
            MyProductModel *aProduct = [MyProductModel MyProductWithDict:dic];
            [_dataArr addObject:aProduct];
        }
        
        if (!_dataArr.count==0)
        {
            nodataImg.hidden = YES;
        }else{
            nodataImg.hidden = NO;
        }

        [self.tableView reloadData];
        [HUD hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        HUD.labelText =@"加载失败，请检查网络";
        //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
        [HUD hide:YES afterDelay:1.5];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text =@"我的服务";
    _stateStr = @"出行宝";
    _dataArr = [[NSMutableArray alloc] init];
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *topBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 100)];
    topBgBtn.backgroundColor = [UIColor whiteColor];
    topBgBtn.userInteractionEnabled =YES;
    [self.view addSubview:topBgBtn];
    [topBgBtn addTarget:self action:@selector(changeCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
    line2.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topBgBtn addSubview:line2];
    
    
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
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"出行宝/年",@"养车宝/次",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.frame = CGRectMake(30,CGRectGetMaxY(topBgBtn.frame)+10,SCREEN_WIDTH-60,30);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = COLOR_NAVIVIEW;
    [self.view addSubview:segmentedControl];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentedControl.frame)+10, SCREEN_WIDTH, SCREEN_HEIHT-CGRectGetMaxY(segmentedControl.frame)-10) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-49.5, (SCREEN_HEIHT-CGRectGetMaxY(segmentedControl.frame)-10)/2+CGRectGetMaxY(segmentedControl.frame)+10-62.5, 99, 125)];
    nodataImg.image = [UIImage imageNamed:@"dataNo"];
    [self.view addSubview:nodataImg];
    
    [self getDataSource];
}
-(void)changeCar
{
    ChooseCarViewController *chooseCar = [[ChooseCarViewController alloc] init];
    [self.navigationController pushViewController:chooseCar animated:YES];
    chooseCar.retrunBlock=^(ListCarModel *aCar){
//        [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/%@",Main_Ip,aCar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
//        self.nameLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",aCar.carbrand,aCar.carseries,aCar.caryear,aCar.carmodel];
//        self.chepaiLab.text = aCar.licenseID;
        _carGUID = [NSString stringWithFormat:@"%@",aCar.GUID];
        [_dataArr removeAllObjects];
        [self getDataSource];
    };
}

-(void)segmentValueChanged:(UISegmentedControl *)segment{
    NSInteger selected=segment.selectedSegmentIndex;
    switch (selected) {
        case 0:
        {
            _stateStr = @"出行宝";
            [_dataArr removeAllObjects];
            [self getDataSource];
            break;
        }
        case 1:
        {
            _stateStr = @"养车宝";
            [_dataArr removeAllObjects];
            [self getDataSource];
            break;
        }
        default:
            break;
    }
}

#pragma 设置tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *huodeCell=@"huodeCell";
    static NSString *duihuanCell=@"duihuanCell";
    
    if ([_stateStr isEqualToString:@"出行宝"]) {
        
        MyReserveTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:huodeCell];
        if(!cell){
            cell=[[MyReserveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:huodeCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MyProductModel *aPro = [_dataArr objectAtIndex:indexPath.row];
        cell.titleLab.text = aPro.title;
        cell.introLab.text = aPro.introduction;
        [cell.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,aPro.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.buyTimeLab.text = [NSString stringWithFormat:@"购买时间:%@",aPro.begintime];
        cell.priceLab.hidden = YES;
        cell.typeLab.text = [NSString stringWithFormat:@"服务类型:%@",aPro.type];
        return cell;
    }
    
    else if ([_stateStr isEqualToString:@"养车宝"])
    {
        MyReserveTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:duihuanCell];
        if(!cell){
            cell=[[MyReserveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:duihuanCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MyProductModel *aPro = [_dataArr objectAtIndex:indexPath.row];
        cell.titleLab.text = aPro.title;
        cell.introLab.text = aPro.introduction;
        [cell.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,aPro.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.buyTimeLab.text = [NSString stringWithFormat:@"购买时间:%@",aPro.begintime];
        cell.typeLab.text = [NSString stringWithFormat:@"服务类型:%@",aPro.type];
        NSLog(@"次数%@",aPro.count);
        cell.priceLab.text = [NSString stringWithFormat:@"剩余:%@次",aPro.count];
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)Goback
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
