//
//  NYCarGroup.m
//  06-汽车品牌带右侧索引
//
//  Created by apple on 15-3-29.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import "NYCarGroup.h"
#import "NYCar.h"

#define CAR_BRAND Main_Ip"CarBrand.asmx/find_all"
@implementation NYCarGroup
//-(void)getDataSource
//{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    
//    [manager POST:CAR_BRAND parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *carArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//            
//            
//    
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}


-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //        [self setValuesForKeysWithDictionary:dict];
        // dict[@"cars"]存放的是字典的数组
        // 希望将字典的数组转换成HMCar模型的数组
        //        [self setValue:dict[@"cars"] forKey:@"cars"];
        [self setValue:dict[@"title"] forKeyPath:@"title"];
        self.cars = [NYCar carsWithArray:dict[@"cars"]];
        
    }
    return self;
}

+(instancetype)carGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)carGroups
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cars_total.plist" ofType:nil]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self carGroupWithDict:dict]];
    }
    return arrayM;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {title: %@, cars: %@}", self.class, self, self.title, self.cars];
}

@end
