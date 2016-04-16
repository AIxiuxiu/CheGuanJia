//
//  MemberViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/5.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MemberViewController.h"
#import "ChuxingTableViewCell.h"
#import "sevDetailViewController.h"
#import "product.h"

#define GET_PRODUCT Main_Ip"product.asmx/find_all"


@interface MemberViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIButton *twoBtn;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MemberViewController
{
    NSString *_stateStr;
    UIView *_lineView;
    NSMutableArray *_dataArr;
    NSMutableArray *_jiDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"会员商城";
    self.rightBtn.hidden = YES;
    _dataArr = [[NSMutableArray alloc] init];
    _jiDataArr = [[NSMutableArray alloc] init];
    _stateStr = @"出行宝";
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(30, 45, SCREEN_WIDTH/2-60, 5)];
    _lineView.backgroundColor = [UIColor orangeColor];
    _lineView.layer.cornerRadius = 2.5;
    
    if ([self.fromWhereStr isEqualToString:@"侧边"]) {
        [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self getDataSource];
    [self initTopView];
    [self initTableView];
    [self refreshAndRelod];
}
-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getDataSource
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    
    if ([_stateStr isEqualToString:@"出行宝"]) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10;
        [manager POST:GET_PRODUCT parameters:@{@"type":@"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            for (int i=0; i<carArr.count; i++) {
                NSDictionary *dic = [carArr objectAtIndex:i];
                product *aProduct = [product productWithDict:dic];
                [_dataArr addObject:aProduct];
            }
            [self.tableView reloadData];
            [HUD hide:YES];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
    }else{
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10;

        [manager POST:GET_PRODUCT parameters:@{@"type":@"0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            for (int i=0; i<carArr.count; i++) {
                NSDictionary *dic = [carArr objectAtIndex:i];
                product *aProduct = [product productWithDict:dic];
                [_jiDataArr addObject:aProduct];
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
}

-(void)initTopView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 50)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    [view addSubview:_lineView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    
    NSArray *TwoBtnTitArr = @[@"出行宝/年",@"养车宝/次"];
    for (int i = 0; i < 2; i++) {
        int col = i % 2;
        
        CGFloat x =  col * SCREEN_WIDTH/2;
        CGFloat y = 0;
        
        self.twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.twoBtn.frame = CGRectMake(x, y, SCREEN_WIDTH/2, 50);
        self.twoBtn.tag = i + 100;
        
        self.twoBtn.backgroundColor = [UIColor clearColor];
        
        [self.twoBtn addTarget:self action:@selector(TwobtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.twoBtn.adjustsImageWhenHighlighted = NO;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.twoBtn.bounds.size.width, 15)];
        
        nameLabel.text=[TwoBtnTitArr objectAtIndex:i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:18];
        if (i==0) {
            nameLabel.textColor = [UIColor orangeColor];
        }else{
            nameLabel.textColor = [UIColor blackColor];
        }
        nameLabel.tag = i+200;
        
        [self.twoBtn addSubview:nameLabel];
        
        
        [view addSubview:self.twoBtn];
    }
}
-(void)TwobtnAction:(UIButton *)btn
{
    // [self.tableView reloadData];
    
    switch (btn.tag) {
        case 100:
        {
            _stateStr = @"出行宝";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _lineView.frame = CGRectMake(30, 45, SCREEN_WIDTH/2-60, 5);
                                 UILabel *lab1 =(UILabel *)[self.view viewWithTag:200];
                                 lab1.textColor = [UIColor orangeColor];
                                 UILabel *lab2 =(UILabel *)[self.view viewWithTag:201];
                                 lab2.textColor = [UIColor blackColor];
                                 [_jiDataArr removeAllObjects];
                                 [self getDataSource];

                             }
                             completion:^(BOOL finished){
                                 [self.tableView reloadData];
                             }];
            
            
            break;
        }
            
        case 101:
        {
            _stateStr = @"养车宝";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _lineView.frame = CGRectMake(30+SCREEN_WIDTH/2, 45, SCREEN_WIDTH/2-60, 5);
                                 UILabel *lab1 =(UILabel *)[self.view viewWithTag:201];
                                 lab1.textColor = [UIColor orangeColor];
                                 UILabel *lab2 =(UILabel *)[self.view viewWithTag:200];
                                 lab2.textColor = [UIColor blackColor];
                                 [_dataArr removeAllObjects];
                                 [self getDataSource];
                             }
                             completion:^(BOOL finished){
                                 
                                 [self.tableView reloadData];
                                 
                             }];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)initTableView{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 65+50+5+0.5, SCREEN_WIDTH, SCREEN_HEIHT-65-50) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
}
#pragma mark--上拉刷新，下拉加载
-(void)refreshAndRelod{
    __weak MemberViewController *weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        //延时隐藏refreshView;
        double delayInSeconds = 2.0;
        //创建延期的时间 2S
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //延期执行
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
//            count=1;
//            [weakSelf.arryData removeAllObjects];
//            [weakSelf reload:nil];
            
            
            //            事情做完了别忘了结束刷新动画~~~
            [weakSelf.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        });
        
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        //延时隐藏refreshView;
        double delayInSeconds = 2.0;
        //创建延期的时间 2S
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //延期执行
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
            //            count +=19;
            
//            [weakSelf reload:nil];
            //事情做完了别忘了结束刷新动画~~~
            [weakSelf.tableView footerEndRefreshing];
        });
        
    }];
    
}
#pragma 设置tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_stateStr isEqualToString:@"出行宝"]) {
        return _dataArr.count;
    }else{
        return _jiDataArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *huodeCell=@"huodeCell";
    static NSString *duihuanCell=@"duihuanCell";
    
    if ([_stateStr isEqualToString:@"出行宝"]) {
        
        ChuxingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:huodeCell];
        if(!cell){
            cell=[[ChuxingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:huodeCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        product *pro = [_dataArr objectAtIndex:indexPath.row];
        cell.titleLab.text = pro.title;
        cell.introLab.text = pro.introduction;
        [cell.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,pro.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        //float price = [pro.showMoney floatValue];
        cell.priceLab.text = [NSString stringWithFormat:@"%@元/年",pro.showMoney];
        return cell;
    }
    
    else if ([_stateStr isEqualToString:@"养车宝"])
    {
        ChuxingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:duihuanCell];
        if(!cell){
            cell=[[ChuxingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:duihuanCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        product *pro = [_jiDataArr objectAtIndex:indexPath.row];
        cell.titleLab.text = pro.title;
        cell.introLab.text = pro.introduction;
       // float price = [pro.price floatValue];
        [cell.phtotImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Product/%@",Main_Ip,pro.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
        cell.priceLab.text = [NSString stringWithFormat:@"%@元/%@次",pro.showMoney,pro.count];
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"defCarGUIDStr"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置默认车型" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        if ([_stateStr isEqualToString:@"出行宝"]) {
            sevDetailViewController *sev = [[sevDetailViewController alloc] init];
            sev.passProduct = [_dataArr objectAtIndex:indexPath.row];
            sev.stateStr = @"出行宝";
            [self.navigationController pushViewController:sev animated:YES];
            
        }
        
        else if ([_stateStr isEqualToString:@"养车宝"])
        {
            sevDetailViewController *sev = [[sevDetailViewController alloc] init];
            sev.passProduct = [_jiDataArr objectAtIndex:indexPath.row];
            sev.stateStr = @"养车宝";
            [self.navigationController pushViewController:sev animated:YES];
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
