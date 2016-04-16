//
//  CarSeries.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarSeries : NSObject

@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *sclass;
@property (nonatomic, copy) NSString *b_guid;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) seriesWithDict:(NSDictionary *)dict;
// 传入一个包含字典的数组，返回一个HMCar模型的数组
+(NSArray *) seriesWithArray:(NSArray *)array;
@end
