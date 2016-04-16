//

#import "CarBrandViewController.h"
#import "NYCarGroup.h"
#import "NYCar.h"
#import "CarTypeViewController.h"
#import "MoreCarViewController.h"
#import "ChineseString.h"
#import "pinyin.h"

#define ALPHA_ARRAY [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]
#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]


#define CAR_BRAND Main_Ip"CarBrand.asmx/find_all"

@interface CarBrandViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *carGroups;
@property (nonatomic, strong) NSMutableDictionary *nameDictionary;
@end

@implementation CarBrandViewController
{
    NSMutableArray *_allCarArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allCarArr = [[NSMutableArray alloc] init];
    self.nameDictionary = [[NSMutableDictionary alloc]init];

    
    self.titLab.text = @"选择品牌";
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH- 90, 25, 80, 30);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"缺少品牌" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(AddNewPinPai) forControlEvents:UIControlEventTouchUpInside];
    [self getDataSource];
    [self tableView];
}
-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:CAR_BRAND parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        for (int i = 0; i<carArr.count; i++) {
            
            NYCar *car = [[NYCar alloc]initWithDict:[carArr objectAtIndex:i]];
            ChineseString *chineseString=[[ChineseString alloc]init];
            chineseString.string=[NSString stringWithString:car.vname];
            
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
            NSMutableString *strchar= [NSMutableString stringWithString:chineseString.pinYin];
            car.pinYin = pinYinResult;
            NSString *sr= [strchar substringToIndex:1];
            car.firstPin = sr;
            [_allCarArr addObject:car];
        }
        [self addDataWithSouces:_allCarArr :self.nameDictionary];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)addDataWithSouces:(NSArray *)array :(NSMutableDictionary *)dictionary
{
    if ([dictionary.allKeys count]!=0) {
        [dictionary removeAllObjects];
    }
    for (NSString * string in ALPHA_ARRAY) {
        NSMutableArray * temp = [[NSMutableArray alloc]  init];
        BOOL realExist = NO;
        for (NYCar *aCar in array) {
            if ([aCar.pinYin hasPrefix:string]) {
                [temp addObject:aCar];
                realExist = YES;
            }
        }
        if (realExist) {
            [dictionary setObject:temp forKey:string];
        }
    }
    [_tableView reloadData];
}

-(void)AddNewPinPai
{
    MoreCarViewController *moreCar = [[MoreCarViewController alloc] init];
    [self.navigationController pushViewController:moreCar animated:YES];
    moreCar.myTitStr = @"缺少品牌";
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIHT-64) style:UITableViewStylePlain];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        //设置数据源
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //加载上去
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//懒加载
-(NSArray *)carGroups
{
    if (_carGroups == nil) {
        _carGroups = [NYCarGroup carGroups];
    }
    return _carGroups;
}


#pragma mark - tableView 数据源方法

/**分组总数*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray * keys = DEFAULTKEYS;
    return keys.count;
}

/**每一组多少行 ，section是第几组*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * keys =DEFAULTKEYS;
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[keys objectAtIndex:section]];
    return [array count];
}

/**单元格*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * keys = DEFAULTKEYS;
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[keys objectAtIndex:indexPath.section]];
    NYCar * aCar = [array objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"searchCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //设置数据
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/CarBrand/%@",Main_Ip,aCar.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
    cell.textLabel.text = aCar.vname;
    
    return cell;
}


/**每一组的标题*/
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * keys = DEFAULTKEYS;
    return [keys objectAtIndex:section];
}

/** 右侧索引列表*/
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray * keys = DEFAULTKEYS;
    return keys;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [ALPHA rangeOfString:title].location;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * keys = DEFAULTKEYS;
    NSMutableDictionary * dictionary = self.nameDictionary;
    NSArray * array = [dictionary objectForKey:[keys objectAtIndex:indexPath.section]];
    NYCar * aCar = [array objectAtIndex:indexPath.row];
    CarTypeViewController *carType = [[CarTypeViewController alloc] init];
    [self.navigationController pushViewController:carType animated:YES];
    carType.car = aCar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

