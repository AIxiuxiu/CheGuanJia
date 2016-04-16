//
//  MyCarTableViewCell2.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/9.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyCarTableViewCell2.h"

@implementation MyCarTableViewCell2

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.defView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 60)];
        self.defView.backgroundColor = [UIColor orangeColor];
        self.defView.hidden = YES;
        [self addSubview:self.defView];
        
        
        self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 80, 60)];
        self.photoImg.layer.cornerRadius = 5;
        self.photoImg.layer.masksToBounds = YES;
        self.photoImg.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
        self.photoImg.layer.borderWidth = 1;
        [self addSubview:self.photoImg];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(103, 20, SCREEN_WIDTH-118, 30)];
        self.nameLab.text = @"奥迪 A4 2005款";
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.nameLab];
        
        self.chepaiLab = [[UILabel alloc] initWithFrame:CGRectMake(103, 60, SCREEN_WIDTH-118, 20)];
        self.chepaiLab.text = @"黑A58217";
        self.chepaiLab.textAlignment = NSTextAlignmentLeft;
        self.chepaiLab.font = [UIFont systemFontOfSize:15];
        self.chepaiLab.textColor = [UIColor grayColor];
        [self addSubview:self.chepaiLab];
        
        
        self.defBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, 70, 55, 20)];
        self.defBtn.backgroundColor = [UIColor orangeColor];
        [self.defBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        [self.defBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.defBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.defBtn.layer.cornerRadius = 4;
        self.defBtn.layer.masksToBounds = YES;
        [self addSubview:self.defBtn];
        
        
        self.delBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 70, 55, 20)];
        self.delBtn.backgroundColor = COLOR_RED;
        [self.delBtn setTitle:@"删除车型" forState:UIControlStateNormal];
        [self.delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.delBtn.titleLabel.font = [UIFont systemFontOfSize:12];

        self.delBtn.layer.cornerRadius = 4;
        self.delBtn.layer.masksToBounds = YES;
        [self addSubview:self.delBtn];
        
        
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
