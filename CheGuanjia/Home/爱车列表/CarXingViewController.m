

#import "CarYearViewController.h"
#import "CarXingViewController.h"
#import "MoreCarViewController.h"
#import "CarModel.h"
#import "CarInfoViewController.h"

#define CAR_MODEL Main_Ip"Carmodel.asmx/find_y_guid"

@interface CarXingViewController ()

@end

@implementation CarXingViewController
{
    NSMutableArray *_allCarModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"选择车型";
    _allCarModelArr = [[NSMutableArray alloc] init];
    
    
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH- 90, 25, 80, 30);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"缺少车型" forState:UIControlStateNormal];
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
    self.topLab.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.car.vname,self.secPassCarSer.sclass,self.secPassCarSer.vname,self.passCarYear.vname];
    self.topLab.textColor = [UIColor blackColor];
    [topView addSubview:self.topLab];
    [self getDataSource];
    [self tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"y_guid":self.passCarYear.GUID};
    
    [manager POST:CAR_MODEL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carYearArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        for (int i = 0; i<carYearArr.count; i++) {
            CarModel *carmodel = [[CarModel alloc] initWithDict:[carYearArr objectAtIndex:i]];
            [_allCarModelArr addObject:carmodel];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)AddNewCheXi
{
    MoreCarViewController *moreCar = [[MoreCarViewController alloc] init];
    [self.navigationController pushViewController:moreCar animated:YES];
    moreCar.myTitStr = @"缺少车型";
    NSLog(@"车型");
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
#pragma mark - tableView 数据源方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
/**每一组多少行 ，section是第几组*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allCarModelArr.count;
}

/**单元格*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可重用表示符
    static NSString *ID = @"cell";
    
    //让表格去缓冲区查找可重用cell
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //如果没有找到可重用cell
    if (cell == nil) {
        //实例化cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CarModel *aCarmodel = [_allCarModelArr objectAtIndex:indexPath.row];
    cell.textLabel.text = aCarmodel.vname;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoViewController *carInfo = [[CarInfoViewController alloc] init];
    [self.navigationController pushViewController:carInfo animated:YES];
    carInfo.car = self.car;
    carInfo.secPassCarSer = self.secPassCarSer;
    carInfo.passCarYear = self.passCarYear;
    carInfo.passCarModel = [_allCarModelArr objectAtIndex:indexPath.row];
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
