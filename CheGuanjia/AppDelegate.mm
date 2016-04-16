//
//  AppDelegate.m
//  CheGuanjia
//
//  Created by GuoZi on 15/12/28.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ZZYLoginViewController.h"
#import "HomeListViewController.h"
#import "InfoListViewController.h"
#import "HomeMainViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "newfeature.h"

#import "UMSocial.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "APService.h"
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    BMKMapManager* mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:@"r1ikZBgB7QfbEhfTgjG8lKmD"  generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"BMKMapManager 失败！！");
    }
    
    [self registerRemoteNotification];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                       UIUserNotificationTypeSound |
//                                                       UIUserNotificationTypeAlert)
//                                           categories:nil];
//    } else {
//        //categories 必须为nil
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                       UIRemoteNotificationTypeSound |
//                                                       UIRemoteNotificationTypeAlert)
//                                           categories:nil];
//    }
    
    [APService setupWithOption:launchOptions];

    [APService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];//桌面应用程序

    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netStatus = status;
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                [UIManager showIndicatorWithTitle:nil message:@"未知网络" duration:1];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                [UIManager showIndicatorWithTitle:nil message:@"请检查网络的连通性" duration:2.0];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                [UIManager showIndicatorWithTitle:nil message:@"手机自带网络" duration:1];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                break;
            }
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.manager=[AFHTTPRequestOperationManager manager];
    [self.manager.requestSerializer setTimeoutInterval:20];
    self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //注册监听，观察登陆值的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:@"loginStateChange" object:nil];
    
    //分享
    [UMSocialData setAppKey:@"56de2f6167e58eee2700277a"];
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *saveKey = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    if (![version isEqualToString:saveKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        newfeature *nfc = [[newfeature alloc] init];
        self.window.rootViewController = nfc;
        [self.window makeKeyAndVisible];
    }
    else{
        //判断是否第一次登录
        [self loginStateChange:nil];
        
    }
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [APService setBadge:application.applicationIconBadgeNumber];
    [application cancelAllLocalNotifications];
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    //    NSLog(@"%@",notification.alertBody);
    NSString *str = [notification.alertBody substringFromIndex:3];
    if ([[notification.alertBody substringToIndex:3] isEqualToString:@"000"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    // 更新显示的徽章个数
    application.applicationIconBadgeNumber += 1;
    
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    
    [APService registerDeviceToken:deviceToken];
    
}
#pragma mark 进入首页面的方法
-(void)loginStateChange:(NSNotification *)notification
{
    //判断是否是第一次登陆，如果是进入登录界面，
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *c_id=[defaults valueForKey:@"c_id"];
    
    if(c_id == nil||[c_id isEqualToString:@""]){
        [defaults setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        ZZYLoginViewController *login=[[ZZYLoginViewController alloc]init];
        self.window.rootViewController = login;
    }else{
    
        [SliderViewController sharedSliderController].mainVCClassName = @"HomeMainViewController";
        
        [SliderViewController sharedSliderController].LeftVC=[[HomeListViewController alloc] init];
        [SliderViewController sharedSliderController].RightVC=[[InfoListViewController alloc] init];
        
        [SliderViewController sharedSliderController].LeftSContentScale=1.0;
        [SliderViewController sharedSliderController].RightSContentScale=1.0;
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
                
            }
            break;
        default:
            break;
            
            
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
