//
//  wexiuTableViewCell.h
//  CheGuanjia
//
//  Created by GuoZi on 16/3/16.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wexiuTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headImgV;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *timeLabel;


@property (nonatomic,strong)UILabel *yanzhengLab;
@property (nonatomic,strong)UILabel *chepaiLabel;
@property (nonatomic,strong)UILabel *servLabel;
@property (nonatomic,strong)UILabel *infoLabel;
@property (nonatomic,strong)UILabel *stateLabel;

@property (nonatomic,strong)UIButton *btn1;
@property (nonatomic,strong)UIButton *btn2;
@end
