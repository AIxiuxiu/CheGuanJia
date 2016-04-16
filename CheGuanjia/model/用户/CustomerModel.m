//
//  CustomerModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/15.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        
        self.nickname = dict[@"nickname"];
        self.vname = dict[@"vname"];
        self.phone = dict[@"phone"];
        self.birthday = dict[@"birthday"];
        self.driveExp = dict[@"driveExp"];
        self.photo = dict[@"photo"];
        
    }
    return self;
}

+(instancetype)customerWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)customerWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self customerWithDict:dict]];
    }
    return arrayM;
}
@end
