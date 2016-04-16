//
//  ProductType.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/8.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductType : NSObject
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *p_guid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *type;


-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) productWithDict:(NSDictionary *)dict;
+(NSArray *) productWithArray:(NSArray *)array;
@end
