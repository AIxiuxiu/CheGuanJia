
#import "YuyueDetailViewController.h"
#import "ShopYuYueViewController.h"
#import "YuYueTableViewCell1.h"
#import "YuYueTableViewCell2.h"
#import "YuYueTableViewCell3.h"
#import "SureServiceViewController.h"
#import "RefusesViewController.h"

@interface ShopYuYueViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ShopYuYueViewController
{
    UITableView *_tableView;
    UIView *_scrolline;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"预约列表";
    self.rightBtn.hidden = YES;
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    
    _stateStr = @"未受理";
    //    _scrolline = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+5,55,SCREEN_WIDTH/3*2/3-10,3)];
    _scrolline = [[UIView alloc] init];
    _scrolline.frame = CGRectMake(SCREEN_WIDTH/3, 55, SCREEN_WIDTH/3*2/3, 3);
    _scrolline.backgroundColor = [UIColor redColor];
    _scrolline.layer.cornerRadius =3;
    
    
    [self initTopView];
    [self initTableView];
}
-(void)Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [topView addSubview:line1];
    
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 60)];
    allBtn.backgroundColor = [UIColor clearColor];
    [allBtn setTitle:@"预约订单>>" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allBtn.tag = 99;
//    [allBtn addTarget:self action:@selector(quanbuBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:allBtn];
    
    [topView addSubview:_scrolline];
    
    UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 15, 1,30)];
    Yline.backgroundColor = [UIColor grayColor];
    [allBtn addSubview:Yline];
    
    float btnWidth = SCREEN_WIDTH/3*2/3;
    for (int i = 0; i<3; i++) {
        
        UIButton *unDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allBtn.frame)+btnWidth*i, 0, btnWidth, 60)];
        unDoneBtn.backgroundColor = [UIColor clearColor];
        [unDoneBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        unDoneBtn.tag = 100+i;
        if(i==0){
            [unDoneBtn setTitle:@"未受理" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];

        }else if(i==1){
            [unDoneBtn setTitle:@"已接单" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }else{
            [unDoneBtn setTitle:@"已拒单" forState:UIControlStateNormal];
            [unDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


        }
        [topView addSubview:unDoneBtn];
        
        UIView *Yline = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-1, 15, 1, 30)];
        Yline.backgroundColor = [UIColor grayColor];
        [unDoneBtn addSubview:Yline];
    }
}

-(void)chooseBtnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            _stateStr = @"未受理";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3, 55, SCREEN_WIDTH/3*2/3, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:102];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 //                                 [_jiDataArr removeAllObjects];
                                 //                                 [self getDataSource];
                                 
                             }
                             completion:^(BOOL finished){
                                 [_tableView reloadData];
                             }];
            
            
            break;
        }
            
        case 101:
        {
            _stateStr = @"已接单";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3+SCREEN_WIDTH/3*2/3, 55, SCREEN_WIDTH/3*2/3, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:101];
                                 [btn2 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:102];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                 //                                 [_dataArr removeAllObjects];
                                 //                                 [self getDataSource];
                             }
                             completion:^(BOOL finished){
                                 
                                 [_tableView reloadData];
                                 
                             }];
        }
            
            break;
        case 102:
        {
            _stateStr = @"已拒单";
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _scrolline.frame = CGRectMake(SCREEN_WIDTH/3+SCREEN_WIDTH/3*4/3, 55, SCREEN_WIDTH/3*2/3, 3);
                                 UIButton *btn1 =(UIButton *)[self.view viewWithTag:100];
                                 [btn1 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn2 =(UIButton *)[self.view viewWithTag:102];
                                 [btn2 setTitleColor:COLOR_RED forState:0];
                                 
                                 UIButton *btn3 =(UIButton *)[self.view viewWithTag:101];
                                 [btn3 setTitleColor:[UIColor blackColor] forState:0];
                                 
                                 UIButton *btn4 =(UIButton *)[self.view viewWithTag:99];
                                 [btn4 setTitleColor:[UIColor blackColor] forState:0];
                                 //                                 [_dataArr removeAllObjects];
                                 //                                 [self getDataSource];
                             }
                             completion:^(BOOL finished){
                                 
                                 [_tableView reloadData];
                                 
                             }];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+60, SCREEN_WIDTH, SCREEN_HEIHT-60-NAVHEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置数据源
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    //加载上去
    [self.view addSubview:_tableView];
}

//返回表里应该有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_stateStr isEqualToString:@"未受理"]) {
        return 275;
    }else if ([_stateStr isEqualToString:@"已接单"]){
        return 285;
    }else{
        return 315;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return line2;
}
//设置单元格方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([_stateStr isEqualToString:@"未受理"]) {
        YuYueTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn1 addTarget:self action:@selector(makeSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(refusesBtn) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if ([_stateStr isEqualToString:@"已接单"]){
        YuYueTableViewCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        YuYueTableViewCell3 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (!cell) {
            cell=[[YuYueTableViewCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YuyueDetailViewController *yuyueDetail = [[YuyueDetailViewController alloc] init];
    [self.navigationController pushViewController:yuyueDetail animated:YES];
}

-(void)makeSureBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认接受该订单?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 10;
    [alert show];
}

-(void)refusesBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认拒接该订单?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 11;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            SureServiceViewController *sure =[[SureServiceViewController alloc] init];
            [self.navigationController pushViewController:sure animated:YES];
            
            
        }
    }else if (alertView.tag == 11)
    {
        if (buttonIndex == 1) {
            RefusesViewController *refuses =[[RefusesViewController alloc] init];
            [self.navigationController pushViewController:refuses animated:YES];
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

