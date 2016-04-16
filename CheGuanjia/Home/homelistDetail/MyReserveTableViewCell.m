//
//  MyReserveTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/3/16.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "MyReserveTableViewCell.h"

@implementation MyReserveTableViewCell
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
        
        
        self.typeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8+115 , 22,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+110+10) , 20)];
        self.typeLab.textAlignment=NSTextAlignmentRight;
        self.typeLab.font = [UIFont systemFontOfSize:15];
        self.typeLab.textColor = [UIColor blackColor];
        self.typeLab.text = @"服务类型:";
        [self addSubview:self.typeLab];
        
        self.introLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8, 45,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 40)];
        self.introLab.textAlignment=NSTextAlignmentLeft;
        self.introLab.font = [UIFont systemFontOfSize:13];
        self.introLab.textColor = [UIColor lightGrayColor];
        self.introLab.numberOfLines = 0;
        self.introLab.text = @"一对一专属私人车管家";
        [self addSubview:self.introLab];
        
        self.buyTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phtotImg.frame)+8, 90,SCREEN_WIDTH-(CGRectGetMaxX(self.phtotImg.frame)+8+15) , 20)];
        self.buyTimeLab.textAlignment=NSTextAlignmentLeft;
        self.buyTimeLab.font = [UIFont systemFontOfSize:13];
        self.buyTimeLab.textColor = COLOR_RED;
        self.buyTimeLab.text = @"购买时间:";
        [self addSubview:self.buyTimeLab];
        
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100 , 90,100 , 20)];
        self.priceLab.textAlignment=NSTextAlignmentRight;
        self.priceLab.font = [UIFont systemFontOfSize:13];
        self.priceLab.textColor = RGBACOLOR(237, 65, 53, 1);
        self.priceLab.text = @"剩余:0次";
        [self addSubview:self.priceLab];
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
