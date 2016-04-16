//
//  ListCarModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/22.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ListCarModel.h"

@implementation ListCarModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.photo = dict[@"photo"];
        self.GUID = dict[@"GUID"];
        self.c_guid = dict[@"c_guid"];
        self.carbrand = dict[@"carbrand"];
        self.carseries = dict[@"carseries"];
        self.caryear = dict[@"caryear"];
        self.carmodel = dict[@"carmodel"];
        self.licenseID = dict[@"licenseID"];
        self.frameID = dict[@"frameID"];
        self.mileage = dict[@"mileage"];
        self.buytime = dict[@"buytime"];
        self.maintenanceMileage = dict[@"maintenanceMileage"];
        self.maintenanceTime = dict[@"maintenanceTime"];
        
        
    }
    return self;
}
+(instancetype)myCarWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)myCarWithArray:(NSArray *)array
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self myCarWithDict:dict]];
    }
    return arrayM;
}
@end