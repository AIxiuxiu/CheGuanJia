//
//  PayViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BaseViewController.h"
#import "product.h"
#import "ProductType.h"
#import "OrderModel.h"

@interface PayViewController : BaseViewController
@property(nonatomic,strong) product *SpassProduct;
@property(nonatomic,strong) NSString *channel;
@property(nonatomic,strong) NSString *orderIDStr;
@property(nonatomic,strong) NSString *timeStr;
@property(nonatomic,strong) ProductType *passType;
@property(nonatomic,strong) NSString *stateStr;
@property(nonatomic,strong) NSString *passStateStr;
@property(nonatomic,strong) OrderModel *secPassOrder;
@end
