//
//  MyProductModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/26.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyProductModel.h"

@implementation MyProductModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        
        self.type = dict[@"type"];
        self.title = dict[@"title"];
        self.introduction = dict[@"introduction"];
        self.detail = dict[@"detail"];
        self.count = dict[@"count"];
        self.photo = dict[@"photo"];
        self.begintime = dict[@"begintime"];

    }
    return self;
}

+(instancetype)MyProductWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)MyProductWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self MyProductWithDict:dict]];
    }
    return arrayM;
}
@end
