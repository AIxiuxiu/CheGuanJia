//
//  ShopModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/19.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        
        self.GUID = dict[@"GUID"];
        self.vname = dict[@"vname"];
        self.phone = dict[@"phone"];
        self.city = dict[@"city"];
        self.director = dict[@"director"];
        self.photo = dict[@"photo"];
        self.contents = dict[@"contents"];
        self.tel = dict[@"tel"];
        self.email = dict[@"email"];
        self.date = dict[@"date"];
        self.address = dict[@"address"];
        self.lng = dict[@"lng"];
        self.lat = dict[@"lat"];
        
    }
    return self;
}

+(instancetype)shopWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)shopWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self shopWithDict:dict]];
    }
    return arrayM;
}
@end
