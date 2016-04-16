//
//  NYCar.m
//  06-汽车品牌带右侧索引
//
//  Created by apple on 15-3-29.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import "NYCar.h"

@implementation NYCar

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.vname = dict[@"vname"];
        self.photo = dict[@"photo"];
        self.GUID = dict[@"GUID"];
    }
    return self;
}

+(instancetype)carWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)carsWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self carWithDict:dict]];
    }
    return arrayM;
}
@end
