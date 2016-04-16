//
//  ChuxingTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/6.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "ChuxingTableViewCell.h"

@implementation ChuxingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        if (SCREEN_HEIHT<600) {
            self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 80, 55)];
        }else{
            self.phtotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 100, 70)];
        }
        self.phtotImg.layer.cornerRadius = 5;
        self.phtotImg.layer.masksToBounds =YES;
        self.phtotImg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.phtotImg];
        
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8 , 22, 110, 20)];
        self.titleLab.textAlignment=NSTextAlignmentLeft;
        self.titleLab.font = [UIFont systemFontOfSize:18];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.text = @"爱车宝车管家";
        [self addSubview:self.titleLab];
        
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8+115 , 22,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+110+10) , 25)];
        self.priceLab.textAlignment=NSTextAlignmentRight;
        self.priceLab.font = [UIFont systemFontOfSize:15];
        self.priceLab.textColor = RGBACOLOR(237, 65, 53, 1);
        self.priceLab.text = @"365元/年";
        [self addSubview:self.priceLab];
        
        self.introLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8, 45,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 40)];
        self.introLab.textAlignment=NSTextAlignmentLeft;
        self.introLab.font = [UIFont systemFontOfSize:13];
        self.introLab.textColor = [UIColor lightGrayColor];
        self.introLab.numberOfLines = 0;
        self.introLab.text = @"一对一专属私人车管家";
        [self addSubview:self.introLab];
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
