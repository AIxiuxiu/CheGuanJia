//
//  MyProductModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/26.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProductModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *begintime;




-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) MyProductWithDict:(NSDictionary *)dict;
+(NSArray *) MyProductWithArray:(NSArray *)array;
@end
