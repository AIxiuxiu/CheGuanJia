//
//  SureServiceViewController.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "SureServiceViewController.h"
#import "photoCollectionViewCell.h"
#import "WeixiuListViewController.h"
#import "SJAvatarBrowser.h"

#define LOAD_SERPHOTO Main_Ip"Reserve.asmx/upOrderStatus"


@interface SureServiceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation SureServiceViewController
{
    NSMutableArray *_allPhotoArr;
    NSString* _imageString;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titLab.text = @"上传维修前照片";
    _allPhotoArr = [[NSMutableArray alloc] init];
    
    UIImage *noImg = [UIImage imageNamed:@"plus_camera"];
    [_allPhotoArr addObject:noImg];
    
    [self initView];
}

-(void)initView
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+30, SCREEN_WIDTH, 30)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"   上传样本照片(最多可上传10张图片)";
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(SCREEN_WIDTH/5-20, SCREEN_WIDTH/5-20);
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 10, 0, 10);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab.frame)+10,SCREEN_WIDTH,(SCREEN_WIDTH/5-20+12)*2) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [_collectionView registerClass:[photoCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView reloadData];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [self.view addSubview:line];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, CGRectGetMaxY(_collectionView.frame)+30, 160, 30)];
    sureBtn.backgroundColor = COLOR_RED;
    [sureBtn setTitle:@"开始维修" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    sureBtn.layer.cornerRadius = 8;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(beginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}



-(void)beginBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接单后您将不能取消预约,请确认是否接单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认接单",nil];
    alert.tag = 99;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex == 1)
        {
            [self UpdateShopInfoForImageRequest:_allPhotoArr];
        }
    }else if (alertView.tag == 88){
        if (buttonIndex == 0)
        {
            WeixiuListViewController *weixiu = [[WeixiuListViewController alloc] init];
            weixiu.fromWhereStr = @"完成";
            [self.navigationController pushViewController:weixiu animated:YES];
        }
    }
}

#pragma mark--------代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allPhotoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    photoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    NSInteger index = _allPhotoArr.count-1 - indexPath.row;
    // cell.photoImgView.image = [_allPhotoArr objectAtIndex:index];
    [cell.photoImageBtn setBackgroundImage:[_allPhotoArr objectAtIndex:index] forState:UIControlStateNormal];
    if (indexPath.row == _allPhotoArr.count -1) {
        cell.photoImageBtn.enabled = NO;
        cell.cancelBtn.hidden = YES;
    }else
    {
        cell.cancelBtn.hidden = NO;
        cell.cancelBtn.tag = 100+indexPath.row;
        [cell.photoImageBtn addTarget:self action:@selector(fangda:) forControlEvents:UIControlEventTouchUpInside];
        cell.photoImageBtn.enabled = YES;
        [cell.cancelBtn addTarget:self action:@selector(cancelBTnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}
-(void)fangda:(UIButton *)btn
{
    [SJAvatarBrowser showImage:btn];//调用方法
}
-(void)cancelBTnClick:(UIButton *)btn
{
    [_allPhotoArr removeObjectAtIndex:_allPhotoArr.count-1- btn.tag+100];
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark -- item的点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _allPhotoArr.count-1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self didSelectIndex:0];
        }];

        UIAlertAction *cancelAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [self didSelectIndex:1];
        }];
        [alertController addAction:cancelAction1];
        [alertController addAction:cancelAction3];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (indexPath.row < _allPhotoArr.count-1)
    {
        
    }
    
    
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark -- 菜单点击方法
-(void)didSelectIndex:(NSInteger)index{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if (index==1) {//取消按钮
        return;
    }
    
    imagePickerController.delegate = self;
    
    UIView * vi = [[UIView alloc]
                   initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    vi.backgroundColor = [UIColor greenColor];
    
    vi.layer.cornerRadius = 100/2;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_allPhotoArr addObject:image];
    [_collectionView reloadData];
    
}
//图片
-(void)UpdateShopInfoForImageRequest:(NSMutableArray *)imageArr
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"上传图片中请稍后";
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    for (int i = 0; i<_allPhotoArr.count-1; i++) {
        if(i==0){
            NSData* imageData = UIImageJPEGRepresentation([_allPhotoArr  objectAtIndex:1],0.5);
            _imageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
        }else{
            
            NSData* imageData = UIImageJPEGRepresentation([_allPhotoArr  objectAtIndex:i+1],0.5);
            NSString *temImageString = [imageData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            _imageString = [NSString stringWithFormat:@"%@|%@",_imageString,temImageString];
        }
    }
    
    if(!_imageString)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请拍照留存凭证" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        alert.tag = 77;
        [alert show];
        [HUD hide:YES];
    }else{
        [manager POST:LOAD_SERPHOTO parameters:@{@"guid":self.passReserve.GUID,@"shopid":[[NSUserDefaults standardUserDefaults] objectForKey:@"o_guid"],@"img":_imageString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSNumber *stateNum =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([stateNum intValue]==1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已接单成功" delegate:self cancelButtonTitle:@"前往维修列表" otherButtonTitles:nil,nil];
                alert.tag = 88;
                [alert show];
                [HUD hide:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"err===%@",error);
        }];
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
