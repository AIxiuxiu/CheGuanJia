//
//  MakeYuYueViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/13.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
@interface MakeYuYueViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property(nonatomic,strong) UIImage *firstImg;

@end

