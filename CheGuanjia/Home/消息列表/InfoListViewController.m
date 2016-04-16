//
//  InfoListViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 15/12/31.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import "InfoListViewController.h"
#import "InfoDetailViewController.h"
#import "MessageModel.h"

#define GET_MSGLIST Main_Ip"MyMsg.asmx/find_c_guid"
#define DEL_MSGLIST Main_Ip"MyMsg.asmx/delete"

@interface InfoListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>

@end

@implementation InfoListViewController
{
    //    存储多选所在的行的model
    NSMutableArray *_selectArr;
    //    存储多选所在的行的行数
    NSMutableArray *_selectIndexArr;
    //    存储多选索引值的数组
    NSMutableIndexSet *_indexset;
    //    搜索框数组
    NSMutableArray *_searcharray;
    
    int _x;
    BOOL _can;
    BOOL _issearch;
    UIButton *_del;
    UIButton *_editBtn;
    UIView *_editView;
    NSString *_IDstr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titLab.text = @"我的消息";
    _selectArr = [[NSMutableArray alloc] init];
    _selectIndexArr = [[NSMutableArray alloc] init];
    _indexset= [[NSMutableIndexSet alloc] init];
    _searcharray = [[NSMutableArray alloc] init];
    _allMsgArray = [[NSMutableArray alloc] init];

    
    _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 23, 40, 30)];
    [_editBtn setTitle:(@"编辑") forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(bianji) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIHT-64) style:UITableViewStylePlain];
    _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置数据源
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    //加载上去
    [self.view addSubview:_tableView];
    
    //    搜索框
    UISearchBar *serchbar=[[UISearchBar alloc]init];
    serchbar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    serchbar.delegate=self;
    serchbar.placeholder =@"输入搜索内容";
    //    取消按钮
    serchbar.showsCancelButton=YES;
    _tableView.tableHeaderView=serchbar;
    
    
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-40, SCREEN_WIDTH, 40)];
    _editView.hidden = YES;
    _editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_editView];
    [self.view bringSubviewToFront:_editView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [_editView addSubview:line];
    //    左上角删除按钮
    _del=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 5, 40, 30)];
    [_del setTitle:(@"删除") forState:UIControlStateNormal];
    [_del setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [_del addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:_del];
    
    [self getDataSource];
    [self refreshAndRelod];
}
-(void)getDataSource
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"c_guid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]};
    [manager POST:GET_MSGLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *msgListArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        for (int i = 0; i<msgListArr.count; i++) {
            MessageModel *aMessage = [[MessageModel alloc] initWithDict:[msgListArr objectAtIndex:i]];
            [_allMsgArray addObject:aMessage];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark--上拉刷新，下拉加载
-(void)refreshAndRelod{
    __weak InfoListViewController *weakSelf = self;
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        //延时隐藏refreshView;
        double delayInSeconds = 2.0;
        //创建延期的时间 2S
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //延期执行
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
//            count=1;
            [weakSelf.allMsgArray removeAllObjects];
            [weakSelf getDataSource];
            
            
            //            事情做完了别忘了结束刷新动画~~~
            [weakSelf.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        });
        
    }];
    
//    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
//        
//        //延时隐藏refreshView;
//        double delayInSeconds = 2.0;
//        //创建延期的时间 2S
//        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        //延期执行
//        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
//            
//            [weakSelf getDataSource];
//            //事情做完了别忘了结束刷新动画~~~
//            [weakSelf.tableView footerEndRefreshing];
//        });
//        
//    }];
}
//多选时选中的行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView.editing == YES) {
        [_selectArr  addObject:[_allMsgArray objectAtIndex:indexPath.row]];
        [_selectIndexArr addObject:[NSNumber numberWithInt:(int)indexPath.row]];
    }else{
        InfoDetailViewController *detail = [[InfoDetailViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
//多选时取消选中的行
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView.editing == YES) {
        [_selectArr  removeObject:[_allMsgArray objectAtIndex:indexPath.row]];
        [_selectIndexArr  removeObject:[NSNumber numberWithInt:(int)indexPath.row]];
    }else{
        NSLog(@"pass");
    }
}
//返回表里应该有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    //    如果是不是搜索状态返回大数组的行数
    if (_issearch==NO) {
        return _allMsgArray.count;
    }
    //    如果是搜索状态返回搜索框数组的行数
    else{
        return _searcharray.count;
    }
}
//设置单元格方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    如果不是搜索状态，调取大数组里的数据
    if (_issearch==NO) {
        MessageModel *model = _allMsgArray[indexPath.row];
        cell.textLabel.text=model.title;
    }
    //    如果是搜索状态，调取搜索框数组里的数据
    if (_issearch==YES) {
        MessageModel *model = _searcharray[indexPath.row];
        cell.textLabel.text=model.title;
    }
    return cell;
}
//添加删除方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    删除
    if(editingStyle==1){
        [_allMsgArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//        _tableView.editing=NO;
//        _x=0;
    }
    [_tableView reloadData];
}
-(void)del
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除这些消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"删除中";
        [HUD show:YES];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        for (int i = 0; i<_selectArr.count; i++) {
            if(i==0){
                MessageModel *model = [_selectArr objectAtIndex:i];
                _IDstr = [NSString stringWithFormat:@"%@",model.GUID];
            }else{
                MessageModel *model = [_selectArr objectAtIndex:i];
                _IDstr = [NSString stringWithFormat:@"%@|%@",_IDstr,model.GUID];
            }
        }
        
     //   NSLog(@"alll~~~~~~~%@",_IDstr);
        
        NSDictionary *dic = @{@"guid":_IDstr};
        [manager POST:DEL_MSGLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSNumber *stateNum =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([stateNum intValue]==1) {
            
                _IDstr = nil;
                //    一定要清空这几个数组里的内容
                [_indexset removeAllIndexes];
                [_selectArr removeAllObjects];
                [_allMsgArray removeAllObjects];
                
                HUD.labelText = @"已删除";
                [HUD hide:YES afterDelay:1];
                [self getDataSource];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            HUD.labelText =@"加载失败，请检查网络";
            //网络请求失败，隐藏上述的“正在加载”的MBProgressHUD；
            [HUD hide:YES afterDelay:1.5];
        }];
        
    }
    
}
//-(void)dele
//{
//    //    判断删除按钮是不是亮的，如果是就能进行删除操作
//    if (_del.hidden==NO)
//    {
//        for (int i=0;i<_selectIndexArr.count;i++)
//        {
//            int x=[_selectIndexArr[i] intValue];
//            //     这里要用索引值数组来存放对象的索引值，会自动排序
//            [_indexset addIndex:x];
//        }
//        [_allMsgArray removeObjectsAtIndexes: _indexset];
//    }
//    [_tableView reloadData];
//    _tableView.editing = YES;
//
//    //    一定要清空这两个数组里的内容
//    [_indexset removeAllIndexes];
//    [_selectArr removeAllObjects];
//}
//弹出框
-(void)bianji
{
    if (_tableView.editing == NO) {
        _editView.hidden = NO;
        _tableView.editing=YES;
        [_editBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _tableView.editing=NO;
        _editView.hidden =YES;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}

//判断是添加还是删除还是多选
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//点击搜索框后执行的方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    修改搜索状态
    _issearch=YES;
    //    修改搜索列表大小，防止被挡到
    _tableView.frame=CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-216-NAVHEIGHT);
    [_tableView reloadData];
    
}
//搜索框后面的按钮点击后执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    //    让键盘下落
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    searchBar.placeholder=@"输入搜索内容";
    _issearch=NO;
    _tableView.frame=CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT);
    [_tableView reloadData];
}
//搜索框里每输入一个字符都执行一次该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //   先清空搜索框数组里的所有内容
    [_searcharray removeAllObjects];
    //    从大数组里寻找有相同字段的对象，并添加到搜索框数组里
    for (MessageModel *model in _allMsgArray) {
        if([[model.title uppercaseString] rangeOfString:[searchText uppercaseString]].length>0){
            [_searcharray addObject:model];
        }
    }
    //    刷新表
    [_tableView reloadData];
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
