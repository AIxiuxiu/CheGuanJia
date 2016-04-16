//
//  ShopModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/19.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *director;

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *contents;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;


-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) shopWithDict:(NSDictionary *)dict;
+(NSArray *) shopWithArray:(NSArray *)array;
@end
