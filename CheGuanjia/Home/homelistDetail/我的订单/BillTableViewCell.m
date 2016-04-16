//
//  BillTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/1.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "BillTableViewCell.h"

@implementation BillTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.orderNumLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-15, 25)];
        self.orderNumLab.text = @"订单号:";
        self.orderNumLab.textAlignment = NSTextAlignmentLeft;
        self.orderNumLab.font = [UIFont systemFontOfSize:14];
        self.orderNumLab.textColor = [UIColor blackColor];
        [self addSubview:self.orderNumLab];

        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.orderNumLab.frame)+5, SCREEN_WIDTH, 1)];
        line1.backgroundColor = COLOR_LINE;
        [self addSubview:line1];
        
        self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line1.frame)+20, 80, 60)];
        self.photoImg.layer.cornerRadius = 5;
        self.photoImg.layer.masksToBounds =YES;
        [self addSubview:self.photoImg];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(line1.frame)+5, SCREEN_WIDTH-115, 25)];
        self.nameLab.text = @"方向盘车管家";
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = [UIFont systemFontOfSize:17];
        self.nameLab.textColor = [UIColor blackColor];
        [self addSubview:self.nameLab];
        
        self.stateLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 5, 80, 20)];
        self.stateLab.text = @"支付成功";
        self.stateLab.textAlignment = NSTextAlignmentRight;
        self.stateLab.font = [UIFont systemFontOfSize:14];
        self.stateLab.textColor = [UIColor greenColor];
        [self addSubview:self.stateLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(115,CGRectGetMaxY(self.nameLab.frame)+5, 200, 30)];
        self.detailLab.text = @"最好的车管家服务";
        self.detailLab.textAlignment = NSTextAlignmentLeft;
        self.detailLab.font = [UIFont systemFontOfSize:14];
        self.detailLab.numberOfLines = 0;
        self.detailLab.textColor = [UIColor grayColor];
        [self addSubview:self.detailLab];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(self.detailLab.frame)+5, SCREEN_WIDTH-151, 40)];
        self.priceLab.text = @"¥0.00元/年";
        self.priceLab.textAlignment = NSTextAlignmentLeft;
        self.priceLab.font = [UIFont systemFontOfSize:18];
        self.priceLab.textColor = COLOR_RED;
        [self addSubview:self.priceLab];
    
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLab.frame)+5, SCREEN_WIDTH, 1)];
        line3.backgroundColor = COLOR_LINE;
        [self addSubview:line3];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.priceLab.frame)+5, SCREEN_WIDTH-50, 40)];
        self.timeLab.text = @"订单生成时间: 2015-11-20 周五 15:09:11";
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textColor = [UIColor grayColor];
        [self addSubview:self.timeLab];
        
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLab.frame)+5, SCREEN_WIDTH, 5)];
        line2.backgroundColor = COLOR_LINE;
        [self addSubview:line2];
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
