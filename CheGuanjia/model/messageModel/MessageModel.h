//
//  MessageModel.h
//  CheGuanjia
//
//  Created by GuoZi on 16/1/23.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *c_guid;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *date;

-(instancetype) initWithDict:(NSDictionary *)dict;
@end
