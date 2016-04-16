//
//  YuYueTableViewCell2.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "YuYueTableViewCell2.h"

@implementation YuYueTableViewCell2

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        self.headImgV.backgroundColor = [UIColor blackColor];
        self.headImgV.layer.cornerRadius = 10;
        self.headImgV.layer.masksToBounds = YES;
        [self addSubview:self.headImgV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 20)];
        self.nameLabel.text = @"18233131996";
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, SCREEN_WIDTH-150, 20)];
        self.timeLabel.text = @"2016-2-8 09:10";
        self.timeLabel.textColor = COLOR_RED;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.timeLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
        lineView1.backgroundColor = COLOR_LINE;
        [self addSubview:lineView1];
        
        self.yanzhengLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-10, 20)];
        self.yanzhengLab.text = @"订单验证码:";
        self.yanzhengLab.textAlignment = NSTextAlignmentLeft;
        self.yanzhengLab.font = [UIFont systemFontOfSize:18];
        self.yanzhengLab.textColor = COLOR_RED;
        [self addSubview:self.yanzhengLab];
        
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 1)];
        lineView2.backgroundColor = COLOR_LINE;
        [self addSubview:lineView2];
        
        self.servLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-10, 20)];
        self.servLabel.textAlignment = NSTextAlignmentLeft;
        self.servLabel.text = @"服务项目：";
        self.servLabel.font = [UIFont systemFontOfSize:14];
        self.servLabel.textColor = [UIColor grayColor];
        [self addSubview:self.servLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, SCREEN_WIDTH-10, 30)];
        self.infoLabel.textAlignment = NSTextAlignmentLeft;
        self.infoLabel.text = @"备注：";
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        self.infoLabel.textColor = [UIColor grayColor];
        [self addSubview:self.infoLabel];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 1)];
        lineView3.backgroundColor = COLOR_LINE;
        [self addSubview:lineView3];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 185, SCREEN_WIDTH-10, 30)];
        self.stateLabel.textAlignment = NSTextAlignmentLeft;
        self.stateLabel.font = [UIFont systemFontOfSize:17];
        self.stateLabel.text = @"客户已确认订单";
        self.stateLabel.textColor = COLOR_RED;
        [self addSubview:self.stateLabel];
        
        
        UIView *lineBottom1 = [[UIView alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 5)];
        lineBottom1.backgroundColor = COLOR_LINE;
        [self addSubview:lineBottom1];
        
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
