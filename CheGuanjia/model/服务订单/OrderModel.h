//
//  OrderModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/11.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *ordertime;
@property (nonatomic, copy) NSString *Pid;
@property (nonatomic, copy) NSString *beizhu;
@property (nonatomic, copy) NSString *buyPrice;
@property (nonatomic, copy) NSString *buyName;
@property (nonatomic, copy) NSString *buyIntro;
@property (nonatomic, copy) NSString *buyPhoto;


-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) orderWithDict:(NSDictionary *)dict;
+(NSArray *) orderWithArray:(NSArray *)array;
@end
