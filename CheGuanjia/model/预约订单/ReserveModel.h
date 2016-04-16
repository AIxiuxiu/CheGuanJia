//
//  ReserveModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/14.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReserveModel : NSObject
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *ReservetTime;
@property (nonatomic, copy) NSString *ProductId;
@property (nonatomic, copy) NSString *myName;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *mycarid;
@property (nonatomic, copy) NSString *validate;
@property (nonatomic, copy) NSString *accepteTime;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *finishtime;
@property (nonatomic, copy) NSString *c_guid;
@property (nonatomic, copy) NSString *adress;
@property (nonatomic, copy) NSString *Shopid;
-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) reserveWithDict:(NSDictionary *)dict;
+(NSArray *) reserveWithArray:(NSArray *)array;
@end
