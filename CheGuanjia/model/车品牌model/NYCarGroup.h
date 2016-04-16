//
//  NYCarGroup.h
//  06-汽车品牌带右侧索引
//
//  Created by apple on 15-3-29.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYCarGroup : NSObject
/** 首字母 */
@property (nonatomic, copy) NSString *title;
/** 车的数组，存放的是HMCar的模型数据 */
@property (nonatomic, strong) NSArray *cars;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) carGroupWithDict:(NSDictionary *)dict;
+(NSArray *) carGroups;
@end
