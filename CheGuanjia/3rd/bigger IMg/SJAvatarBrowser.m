//
//  SJAvatarBrowser.m
//  OuJia
//
//  Created by GuoZi on 15/11/26.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "SJAvatarBrowser.h"
static CGRect oldframe;
@implementation SJAvatarBrowser
+(void)showImage:(UIButton *)avatarImageView{
    
    UIImage *image=avatarImageView.currentBackgroundImage;
        
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
      //  imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame=CGRectMake(0,(SCREEN_HEIHT-imageView.bounds.size.height*SCREEN_WIDTH/imageView.bounds.size.width)/2, SCREEN_WIDTH, imageView.bounds.size.height*SCREEN_WIDTH/imageView.bounds.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
@end
