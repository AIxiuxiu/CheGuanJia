//
//  ReserveModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/14.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ReserveModel.h"

@implementation ReserveModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.GUID = dict[@"GUID"];
        self.Remark = dict[@"Remark"];
        self.vname = dict[@"vname"];
        self.pname = dict[@"pname"];
        self.phone = dict[@"phone"];
        self.ReservetTime = dict[@"ReservetTime"];
        self.ProductId = dict[@"ProductId"];
        self.myName = dict[@"vname1"];
        self.photo = dict[@"photo"];
        self.mycarid = dict[@"mycarid"];
        self.validate = dict[@"validate"];
        self.accepteTime = dict[@"accepteTime"];
        self.state = dict[@"state"];
        self.finishtime = dict[@"finishtime"];
        self.c_guid = dict[@"c_guid"];
        self.adress = dict[@"address"];
        self.Shopid = dict[@"Shopid"];
    }
    return self;
}

+(instancetype)reserveWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)reserveWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self reserveWithDict:dict]];
    }
    return arrayM;
}
@end
