//
//  BillTableViewCell.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/1.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *orderNumLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *stateLab;
@property(nonatomic,strong) UILabel *detailLab;
@property(nonatomic,strong) UILabel *priceLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UIImageView *photoImg;
@end
