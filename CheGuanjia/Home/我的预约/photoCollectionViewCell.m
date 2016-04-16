//
//  photoCollectionViewCell.m
//  PhotoSave
//
//  Created by GuoZi on 15/12/23.
//  Copyright © 2015年 GuoZi. All rights reserved.
//

#import "photoCollectionViewCell.h"

@implementation photoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width=frame.size.width;
        CGFloat height=frame.size.height;
//        self.photoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//        self.backgroundColor = [UIColor clearColor];
//        self.photoImgView.contentMode=UIViewContentModeScaleAspectFit;
//        [self addSubview:self.photoImgView];
        
        //上传的图片
        self.photoImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.photoImageBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.photoImageBtn];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-18, 0, 18, 18)];
        [self.cancelBtn setImage:[UIImage imageNamed:@"del_btn"] forState:0];
        [self.cancelBtn setImage:[UIImage imageNamed:@"del_btn_down"] forState:UIControlStateHighlighted];
        self.cancelBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.cancelBtn];
        
    }
    return self;
}


@end
