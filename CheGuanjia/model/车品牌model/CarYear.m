//
//  CarYear.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/22.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "CarYear.h"

@implementation CarYear
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.vname = dict[@"vname"];
        self.GUID = dict[@"GUID"];
        self.s_guid = dict[@"s_guid"];
        
    }
    return self;
}
@end
