//
//  HongbaoModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "HongbaoModel.h"

@implementation HongbaoModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.GUID = dict[@"id"];
        self.status = dict[@"status"];
        self.amount = dict[@"amount"];
        self.enddate = dict[@"enddate"];
        
    }
    return self;
}

+(instancetype)hongbaoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)hongbaoWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self hongbaoWithDict:dict]];
    }
    return arrayM;
}
@end
