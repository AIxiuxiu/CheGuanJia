//
//  OrderModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.oid = dict[@"oid"];
        self.status = dict[@"status"];
        self.amount = dict[@"amount"];
        self.paytime = dict[@"paytime"];
        self.ordertime = dict[@"ordertime"];
        self.Pid = dict[@"Pid"];
        self.beizhu = dict[@"beizhu"];
        self.buyName = dict[@"title"];
        self.buyPrice = dict[@"price"];
        self.buyIntro = dict[@"introduction"];
        self.buyPhoto = dict[@"photo"];
        
    }
    return self;
}

+(instancetype)orderWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)orderWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self orderWithDict:dict]];
    }
    return arrayM;
}
@end