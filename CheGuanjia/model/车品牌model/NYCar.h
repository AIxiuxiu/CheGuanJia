//
//  NYCar.h
//  06-汽车品牌带右侧索引
//
//  Created by apple on 15-3-29.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYCar : NSObject

@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *pinYin;
@property (nonatomic, copy) NSString *firstPin;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) carWithDict:(NSDictionary *)dict;
// 传入一个包含字典的数组，返回一个HMCar模型的数组
+(NSArray *) carsWithArray:(NSArray *)array;
@end
