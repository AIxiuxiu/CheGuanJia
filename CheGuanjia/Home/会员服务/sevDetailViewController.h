//
//  sevDetailViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "product.h"
#import "ProductType.h"

@interface sevDetailViewController : BaseViewController
@property(nonatomic,strong)product *passProduct;
@property(nonatomic,strong)ProductType *nextProductType;
@property(nonatomic,strong)NSString *stateStr;
@end
