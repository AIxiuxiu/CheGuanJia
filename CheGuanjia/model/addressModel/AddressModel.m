//
//  AddressModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/25.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.address = dict[@"address"];
        self.GUID = dict[@"GUID"];
        self.c_guid = dict[@"c_guid"];
        self.cityID = dict[@"id"];
        self.dis = dict[@"dis"];
        self.area = dict[@"area"];
    }
    return self;
}
@end
