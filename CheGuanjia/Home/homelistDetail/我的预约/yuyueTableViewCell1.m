//
//  YuyueTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/15.
//  Copyright © 2016年 ChuMing. All rights reserved.
//
#import "yuyueTableViewCell1.h"

@implementation yuyueTableViewCell1
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.yanzhengmaLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-15, 30)];
        self.yanzhengmaLab.text = @"预约单验证码:";
        self.yanzhengmaLab.numberOfLines = 0;
        self.yanzhengmaLab.textAlignment = NSTextAlignmentLeft;
        self.yanzhengmaLab.font = [UIFont systemFontOfSize:16];
        self.yanzhengmaLab.textColor = COLOR_BLACK;
        [self addSubview:self.yanzhengmaLab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.yanzhengmaLab.frame)+5, 200, 15)];
        lab1.text = @"预约项目:";
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.font = [UIFont systemFontOfSize:14];
        lab1.textColor = [UIColor grayColor];
        [self addSubview:lab1];
        
        self.allSerLab = [[UILabel alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(lab1.frame)+5, SCREEN_WIDTH-50, 35)];
        self.allSerLab.text = @"";
        self.allSerLab.numberOfLines = 0;
        self.allSerLab.textAlignment = NSTextAlignmentLeft;
        self.allSerLab.font = [UIFont systemFontOfSize:14];
        self.allSerLab.textColor = [UIColor grayColor];
        [self addSubview:self.allSerLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.allSerLab.frame)+5, SCREEN_WIDTH-15, 15)];
        self.timeLab.text = @"预约时间:";
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textColor = [UIColor grayColor];
        [self addSubview:self.timeLab];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.timeLab.frame)+10, SCREEN_WIDTH-15, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line1];
        
        UIImageView *photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame)+8, 20, 20)];
        photoImg.image = [UIImage imageNamed:@"wait"];
        [self addSubview:photoImg];
        
        self.areaLab = [[UILabel alloc] initWithFrame:CGRectMake(48, CGRectGetMaxY(line1.frame)+10, SCREEN_WIDTH-48, 20)];
        self.areaLab.text = @"等待受理中";
        self.areaLab.textAlignment = NSTextAlignmentLeft;
        self.areaLab.font = [UIFont systemFontOfSize:16];
        self.areaLab.textColor = COLOR_RED;
        [self addSubview:self.areaLab];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, CGRectGetMaxY(line1.frame)+5, 60, 30)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.cancelBtn.layer.cornerRadius = 5;
        self.cancelBtn.backgroundColor = COLOR_RED;
        [self addSubview:self.cancelBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 8)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
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

