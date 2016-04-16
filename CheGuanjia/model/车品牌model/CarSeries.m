//
//  CarSeries.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarSeries.h"

@implementation CarSeries

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.vname = dict[@"vname"];
        self.GUID = dict[@"GUID"];
        self.sclass = dict[@"sclass"];
        self.b_guid = dict[@"b_guid"];

    }
    return self;
}

+(instancetype)seriesWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)seriesWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self seriesWithDict:dict]];
    }
    return arrayM;
}

@end
