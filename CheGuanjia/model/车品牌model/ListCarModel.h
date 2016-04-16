//
//  ListCarModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/22.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListCarModel : NSObject
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *c_guid;
@property (nonatomic, copy) NSString *carbrand;
@property (nonatomic, copy) NSString *carseries;
@property (nonatomic, copy) NSString *caryear;
@property (nonatomic, copy) NSString *carmodel;
@property (nonatomic, copy) NSString *licenseID;
@property (nonatomic, copy) NSString *frameID;
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *buytime;
@property (nonatomic, copy) NSString *maintenanceMileage;
@property (nonatomic, copy) NSString *maintenanceTime;
-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) myCarWithDict:(NSDictionary *)dict;
+(NSArray *) myCarWithArray:(NSArray *)array;
@end
