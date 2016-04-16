//
//  AddressModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/25.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *c_guid;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *dis;
-(instancetype) initWithDict:(NSDictionary *)dict;
@end
