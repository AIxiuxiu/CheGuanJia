//
//  product.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "product.h"

@implementation product

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.GUID = dict[@"GUID"];
        self.title = dict[@"title"];
        self.introduction = dict[@"introduction"];
        self.detail = dict[@"detail"];
        self.photo = dict[@"photo"];
        self.price = dict[@"price"];
        self.type = dict[@"type"];
        self.count = dict[@"count"];
        self.showMoney = dict[@"showmoney"];
        self.GUID1 = dict[@"GUID1"];
        self.p_guid = dict[@"p_guid"];
    }
    return self;
}

+(instancetype)productWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)productWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self productWithDict:dict]];
    }
    return arrayM;
}
@end
