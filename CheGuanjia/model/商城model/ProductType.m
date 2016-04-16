//
//  ProductType.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/8.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ProductType.h"

@implementation ProductType
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.GUID = dict[@"GUID"];
        self.p_guid = dict[@"p_guid"];
        self.price = dict[@"price"];
        self.type = dict[@"type"];
        
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
