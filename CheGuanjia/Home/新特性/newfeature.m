//
//  newfeature.m
//  ProgrammerDictionary
//
//  Created by swordocean on 15/7/16.
//  Copyright (c) 2015年 swordocean. All rights reserved.
//

#import "newfeature.h"
#import "ZZYLoginViewController.h"

static int const pictureCount = 3;

@interface newfeature ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageC;

@end

@implementation newfeature

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setScrollviewAndPageControl];
    [self setimageView];
}

- (void)setScrollviewAndPageControl{
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = self.view.frame;
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * pictureCount, [UIScreen mainScreen].bounds.size.height);
    self.scrollView = scrollview;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollview];
    UIPageControl *page = [[UIPageControl alloc] init];
    page.userInteractionEnabled = NO;
    CGFloat pageW = 100;
    CGFloat pageH = 44;
    CGFloat pageX = ([UIScreen mainScreen].bounds.size.width - pageW) * 0.5;
    CGFloat pageY = [UIScreen mainScreen].bounds.size.height - pageH - 10;
    page.currentPage = 0;
    page.numberOfPages = pictureCount;
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    page.pageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0f];
    page.frame = CGRectMake(pageX, pageY, pageW, pageH);
    self.pageC = page;
    [self.view addSubview:self.pageC];
}

- (void)setimageView{
    for (int i = 0; i < pictureCount; i++) {
        UIImageView *imgv = [[UIImageView alloc] init];
        CGFloat imgvW = [UIScreen mainScreen].bounds.size.width;
        CGFloat imgvH = [UIScreen mainScreen].bounds.size.height;
        CGFloat imgvX = imgvW * i;
        CGFloat imgvY = 0;
        imgv.frame = CGRectMake(imgvX, imgvY, imgvW, imgvH);
        
        if ([UIScreen mainScreen].bounds.size.width == 320 ) {
            if ([UIScreen mainScreen].bounds.size.height == 640) {
                [imgv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_page_4_0%d",i+1]]];
            }
            else{
                [imgv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_page_5_0%d",i+1]]];
            }
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375){
            [imgv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_page_6s_0%d",i+1]]];
        }
        else{
            [imgv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_page_6p_0%d",i+1]]];
        }
        if (i == pictureCount - 1) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"Experience"] forState:UIControlStateNormal];
            if ([UIScreen mainScreen].bounds.size.height < 700) {
                btn.titleLabel.font = [UIFont  boldSystemFontOfSize:16.0];
            }
            else{
                btn.titleLabel.font = [UIFont  boldSystemFontOfSize:24.0f];
            }
            btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.6 * 0.5, [UIScreen mainScreen].bounds.size.height * 0.87, [UIScreen mainScreen].bounds.size.width * 0.4, 36);
            imgv.userInteractionEnabled = YES;
            [btn addTarget:self action:@selector(showFirstPage) forControlEvents:UIControlEventTouchUpInside];
            [imgv addSubview:btn];
        }
        [self.scrollView addSubview:imgv];
    }
}

- (void)showFirstPage{
    if ([self.whereStr isEqualToString:@"设置"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        ZZYLoginViewController *loginViewController = [[ZZYLoginViewController alloc] init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromLeft;
        [win.layer addAnimation:transition forKey:@"transition"];
        win.rootViewController = loginViewController;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentpage = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width + 0.5;
    self.pageC.currentPage = currentpage;
    
//    if (scrollView.contentOffset.x > [UIScreen mainScreen].bounds.size.width * (2 + 0.1)) {
//        UIWindow *win = [UIApplication sharedApplication].keyWindow;
//        FabTabbarController *rtc = [[FabTabbarController alloc] init];
//        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0.8f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            CGRect frame = self.scv.frame;
//            frame.origin.x = frame.origin.x + [UIScreen mainScreen].bounds.size.width;
//            self.scv.frame = frame;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                win.rootViewController = rtc;
//            });
//        } completion:^(BOOL finished) {
//            [self.scv removeFromSuperview];
//            
//        }];
//
//    }
    
}

@end
