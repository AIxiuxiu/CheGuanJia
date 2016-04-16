//
//  MessageModel.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/23.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.GUID = dict[@"GUID"];
        self.c_guid = dict[@"c_guid"];
        self.detail = dict[@"detail"];
        self.date = dict[@"date"];
        
    }
    return self;
}
@end
