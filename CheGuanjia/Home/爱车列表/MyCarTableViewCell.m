//
//  MyCarTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyCarTableViewCell.h"

@implementation MyCarTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line2];
        
        self.defLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 23, 100)];
        self.defLab.text = @"默\n认\n车\n型";
        self.defLab.textColor = [UIColor whiteColor];
        self.defLab.backgroundColor = [UIColor orangeColor];
        self.defLab.textAlignment = NSTextAlignmentCenter;
        self.defLab.font = [UIFont systemFontOfSize:16];
        self.defLab.numberOfLines = 0;
        [self addSubview:self.defLab];
        
        self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 60)];
        self.photoImg.layer.cornerRadius = 5;
        self.photoImg.layer.masksToBounds = YES;
        self.photoImg.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
        self.photoImg.layer.borderWidth = 1;
        [self addSubview:self.photoImg];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 20, SCREEN_WIDTH-118, 30)];
        self.nameLab.text = @"奥迪 A4 2005款";
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.nameLab];
        
        self.chepaiLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 60, SCREEN_WIDTH-118, 20)];
        self.chepaiLab.text = @"黑A58217";
        self.chepaiLab.textAlignment = NSTextAlignmentLeft;
        self.chepaiLab.font = [UIFont systemFontOfSize:15];
        self.chepaiLab.textColor = [UIColor grayColor];
        [self addSubview:self.chepaiLab];
        
        
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
