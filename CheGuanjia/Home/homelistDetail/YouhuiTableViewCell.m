//
//  YouhuiTableViewCell.m
//  CheGuanjia
//
//  Created by GuoZi on 16/1/18.
//  Copyright © 2016年 ChuMing. All rights reserved.
//

#import "YouhuiTableViewCell.h"

@implementation YouhuiTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, 64)];
        self.bgImgV.image = [UIImage imageNamed:@"beijing"];
        [self addSubview:self.bgImgV];
        
        self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 54, 54)];
        self.photoImg.image = [UIImage imageNamed:@"youhuiquan"];
        [self.bgImgV addSubview:self.photoImg];
        
        self.defLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 22, 80, 20)];
        self.defLab.text = @"优惠券";
        self.defLab.textColor = [UIColor blackColor];
        self.defLab.backgroundColor = [UIColor clearColor];
        self.defLab.textAlignment = NSTextAlignmentLeft;
        self.defLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.defLab];
        
        self.TimeLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, 180, 15)];
        self.TimeLab.text = @"有效期:";
        self.TimeLab.textColor = [UIColor blackColor];
        self.TimeLab.backgroundColor = [UIColor clearColor];
        self.TimeLab.textAlignment = NSTextAlignmentLeft;
        self.TimeLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.TimeLab];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bgImgV.frame.size.width-85, self.bgImgV.frame.size.height/2-10, 80, 30)];
        self.priceLab.text = @"￥500";
        self.priceLab.textColor = [UIColor whiteColor];
        self.priceLab.textAlignment = NSTextAlignmentRight;
        self.priceLab.font = [UIFont systemFontOfSize:18];
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
