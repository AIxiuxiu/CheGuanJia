//
//  CarModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/22.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.vname = dict[@"vname"];
        self.GUID = dict[@"GUID"];
        self.y_guid = dict[@"y_guid"];
        
    }
    return self;
}
@end
