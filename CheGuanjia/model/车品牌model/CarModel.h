//
//  CarModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/22.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject
@property (nonatomic, copy) NSString *vname;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *y_guid;

-(instancetype) initWithDict:(NSDictionary *)dict;
@end
