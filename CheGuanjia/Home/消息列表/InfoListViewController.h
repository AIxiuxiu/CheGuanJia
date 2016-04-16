//
//  InfoListViewController.h
//  CheGuanjia
//
//  Created by GuoZi on 15/12/31.
//  Copyright © 2015年 ChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InfoListViewController : BaseViewController
@property(nonatomic,strong)UITableView *tableView;
//    大数组
@property(nonatomic,strong)NSMutableArray *allMsgArray;
@end
