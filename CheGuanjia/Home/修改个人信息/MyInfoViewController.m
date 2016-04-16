//
//  MyInfoViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UpdateInfoViewController.h"
#import "AdressViewController.h"
#import "CustomerModel.h"
#import "ZHPickView.h"

#define GET_MYINFO Main_Ip"customer.asmx/findByCid"
#define UPDATE_MYINFO Main_Ip"customer.asmx/MyData"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZHPickViewDelegate>

@end

@implementation MyInfoViewController
{
    UITableView *tableview;
    NSArray *arryData;
    NSArray *_titArr;
    CustomerModel *_aCus;
    UIImage *_passImg;
    UIImageView *_detailImg;
    ZHPickView *_pickview;
}

- (void)getDataSource{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:GET_MYINFO parameters:@{@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *cusInfoArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [cusInfoArr firstObject];
        _aCus = [CustomerModel customerWithDict:dic];
        
        [tableview reloadData];
        [HUD hide:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _aCus = [[CustomerModel alloc] init];
    self.titLab.text = @"个人资料";
    [self.leftBtn addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    _titArr = @[@"头像",@"昵称",@"真实姓名",@"联系电话",@"生日",@"驾龄"];
    arryData = [[NSMutableArray alloc]init];
    [self initTableView];
    [self getDataSource];
    
    
}
-(void)initTableView{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIHT-65)style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIHT-50, SCREEN_WIDTH, 50)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [btnView addSubview:line];
    
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, 5, 180, 40)];
    updateBtn.layer.cornerRadius = 8;
    updateBtn.layer.masksToBounds = YES;
    updateBtn.backgroundColor = COLOR_RED;
    [updateBtn setTitle:@"修改资料" forState:0];
    [updateBtn setTitleColor:[UIColor whiteColor] forState:0];
    [updateBtn addTarget:self action:@selector(updateMyInfo) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:updateBtn];

}


-(void)updateMyInfo
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"修改中";
    [HUD show:YES];
    
    UITableViewCell *cell2 = [self.view viewWithTag:2];
    UITableViewCell *cell3 = [self.view viewWithTag:3];
    UITableViewCell *cell5 = [self.view viewWithTag:5];
    UITableViewCell *cell6 = [self.view viewWithTag:6];
    
    if ([cell3.detailTextLabel.text isEqualToString:@""]) {
        cell3.detailTextLabel.text = @" ";
    }
    
    NSString *imageString;
    if (_passImg) {
        NSData* imageData = UIImageJPEGRepresentation(_passImg,0.5);
        imageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        NSData* imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"photoNo"],0.5);
        imageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *dic = @{@"GUID":[[NSUserDefaults standardUserDefaults] objectForKey:@"c_id"],@"photo":imageString,@"vname":cell3.detailTextLabel.text,@"nickname":cell2.detailTextLabel.text,@"birthday":cell5.detailTextLabel.text,@"driveExp":cell6.detailTextLabel.text};
    
    
    [manager POST:UPDATE_MYINFO parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *stateNum = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([stateNum intValue]==1) {
            
            HUD.labelText = @"修改成功";
            [HUD hide:YES afterDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMyInfo" object:self];
            
        }else
        {
            HUD.labelText = @"修改失败";
            [HUD hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        [HUD hide:YES];
    }];
}


#pragma mark--tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=[_titArr objectAtIndex:indexPath.row];
        cell.tag = indexPath.row+1;
        
        if (indexPath.row == 0) {
            _detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 5, 50, 50)];
            [_detailImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/photo/Customer/%@",Main_Ip,_aCus.photo]] placeholderImage:[UIImage imageNamed:@"photoNo"]];
            _detailImg.backgroundColor = [UIColor clearColor];
            _detailImg.layer.cornerRadius = 6;
            _detailImg.layer.masksToBounds = YES;
            [cell.contentView addSubview:_detailImg];
            cell.tag = 1;
        
        }else if (indexPath.row == 1)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_aCus.nickname];
            cell.tag = 2;
            
        }else if (indexPath.row == 2)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_aCus.vname];
            cell.tag = 3;
            
        }else if (indexPath.row == 3)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_aCus.phone];
            cell.tag = 4;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if (indexPath.row == 4)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_aCus.birthday];
            cell.tag = 5;
            
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_aCus.driveExp];
            cell.tag = 6;

        }
        return cell;
    }else
    {
        static NSString *cellID=@"cellID2";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=@"常用地址";
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self didSelectIndex:0];

                
            }];
            UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self didSelectIndex:1];

            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [alertController addAction:archiveAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (indexPath.row == 3)
        {
            
        }
        else if (indexPath.row == 4)
        {

            [self.view endEditing:YES];
            NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
            _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
            
        }
        
        else
        {
            UpdateInfoViewController *update = [[UpdateInfoViewController alloc] init];
            [self.navigationController pushViewController:update animated:YES];
            switch (indexPath.row) {
                case 1:
                {
                    update.titStr =@"修改昵称";
                    
                }
                    break;
                case 2:
                {
                    update.titStr =@"修改真实姓名";
                }
                    break;

                case 5:
                {
                    update.titStr =@"修改驾龄";
                }
                    break;
                    
                default:
                    break;
            }
            
            update.retrunBlock=^(NSString *str){
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = str;
                
            };
        }
    }
    else
    {
        AdressViewController *adress = [[AdressViewController alloc] init];
        [self.navigationController pushViewController:adress animated:YES];
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }else{
        return 8;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return 60;
    }else{
        return 50;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else
    {
        return 1;
    }
}

#pragma mark -- 菜单点击方法
-(void)didSelectIndex:(NSInteger)index{
    NSUInteger sourceType = 0;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if (index==1) {
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            NSLog(@"不支持相机");
        }
        
    }else if(index==0)
    {
        // 跳转到相机或相册页面
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    _passImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _detailImg.image = _passImg;
    
    
}


#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSString *dateStr = [resultString substringToIndex:10];
    UITableViewCell *cell = [self.view viewWithTag:5];
    cell.detailTextLabel.text = dateStr;
    
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
