//
//  AppDelegate.h
//  CheGuanjia
//
//  Created by GuoZi on 15/12/28.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property  int netStatus;//用于保存网络的当前状态
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

