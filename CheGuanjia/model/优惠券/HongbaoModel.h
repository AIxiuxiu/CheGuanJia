//
//  HongbaoModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HongbaoModel : NSObject
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *enddate;


-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) hongbaoWithDict:(NSDictionary *)dict;
+(NSArray *) hongbaoWithArray:(NSArray *)array;
@end
