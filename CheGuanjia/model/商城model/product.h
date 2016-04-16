//
//  product.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface product : NSObject

@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *showMoney;
@property (nonatomic, copy) NSString *GUID1;
@property (nonatomic, copy) NSString *p_guid;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) productWithDict:(NSDictionary *)dict;
+(NSArray *) productWithArray:(NSArray *)array;
@end
