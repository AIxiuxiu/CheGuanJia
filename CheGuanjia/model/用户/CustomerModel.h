//
//  CustomerModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/15.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *driveExp;




-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) customerWithDict:(NSDictionary *)dict;
+(NSArray *) customerWithArray:(NSArray *)array;
@end
