//
//  CarTypeViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarTypeViewController.h"
#import "CarYearViewController.h"
#import "MoreCarViewController.h"
#import "CarSeries.h"

#define CAR_SERIES Main_Ip"CarSeries.asmx/find_b_guid"

@interface CarTypeViewController ()
@property (nonatomic, strong) NSMutableDictionary *nameDictionary;


@end

@implementation CarTypeViewController
{
    NSMutableArray *_allSerArr;
    NSMutableArray *_allSerNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"选择车系";
    
    _allSerArr = [[NSMutableArray alloc] init];
    _allSerNameArr = [[NSMutableArray alloc] init];
    self.nameDictionary = [[NSMutableDictionary alloc]init];

    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH- 90, 25, 80, 30);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"缺少车系" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(AddNewCheXi) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
    topView.backgroundColor = RGBACOLOR(217, 217, 217, 217);
    [self.view addSubview:topView];
    
    self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,self.car.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    [topView addSubview:self.photoImg];
    
    self.topLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-90, 50)];
    self.topLab.textAlignment = NSTextAlignmentLeft;
    self.topLab.backgroundColor = [UIColor clearColor];
    self.topLab.font = [UIFont systemFontOfSize:14];
    self.topLab.numberOfLines = 0;
    self.topLab.text = [NSString stringWithFormat:@"%@",self.car.vname];
    self.topLab.textColor = [UIColor blackColor];
    [topView addSubview:self.topLab];
    [self getDataSource];
    [self tableView];
}

-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"b_guid":self.car.GUID};

    [manager POST:CAR_SERIES parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carSerArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i = 0; i<carSerArr.count; i++) {
            NSDictionary *dic = [carSerArr objectAtIndex:i];
            CarSeries *aCarserise = [[CarSeries alloc] initWithDict:dic];
            
            [_allSerNameArr addObject:aCarserise.sclass];
            [_allSerArr addObject:aCarserise];
        }
        [self addDataWithSouces:_allSerArr :self.nameDictionary];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)addDataWithSouces:(NSArray *)array :(NSMutableDictionary *)dictionary
{
    if ([dictionary.allKeys count]!=0) {
        [dictionary removeAllObjects];
    }
    
    for (NSString * string in _allSerNameArr) {
        NSMutableArray * temp = [[NSMutableArray alloc]  init];
        BOOL realExist = NO;
        for (CarSeries *aSerise in array) {
            if ([aSerise.sclass isEqualToString:string])
            {
                [temp addObject:aSerise];
                realExist = YES;
            }
        }
        if (realExist) {
            [dictionary setObject:temp forKey:string];
        }
    }
    [_tableView reloadData];

}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIHT-64-50) style:UITableViewStylePlain];
        //设置数据源
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        //加载上去
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(void)AddNewCheXi
{
    MoreCarViewController *moreCar = [[MoreCarViewController alloc] init];
    [self.navigationController pushViewController:moreCar animated:YES];
    moreCar.myTitStr = @"缺少车系";
    NSLog(@"车系");
}
#pragma mark - tableView 数据源方法

/**分组总数*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameDictionary.allKeys.count;
}

/**每一组多少行 ，section是第几组*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[_allSerNameArr objectAtIndex:section]];
    return [array count];
}

/**单元格*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[_allSerNameArr objectAtIndex:indexPath.section]];
    CarSeries * aCarser = [array objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"searchCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //设置数据
    // cell.imageView.image = [UIImage imageNamed:aCar.photo];
    cell.textLabel.text = aCarser.vname;
    
    return cell;
}


/**每一组的标题*/
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_allSerNameArr objectAtIndex:section];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[_allSerNameArr objectAtIndex:indexPath.section]];
    CarSeries * aCarser = [array objectAtIndex:indexPath.row];
    CarYearViewController *carYear = [[CarYearViewController alloc] init];
    [self.navigationController pushViewController:carYear animated:YES];
    carYear.passCarSer = aCarser;
    carYear.car = self.car;
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
