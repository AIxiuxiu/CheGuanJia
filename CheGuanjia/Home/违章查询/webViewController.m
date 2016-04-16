//
//  webViewController.m
//  PuTaoShuPro
//
//  Created by sunwei on 15/6/12.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activity;
}
@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titLab.text=self.titleText;

    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIHT-NAVHEIGHT)];
    web.delegate=self;
    [self.view addSubview:web];
//    web.scalesPageToFit=YES;//自动缩放
//    [web loadHTMLString:self.string baseURL:nil];
    NSURL *url=[NSURL URLWithString:self.string];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
   
    activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_WIDTH, 30, 30)];
    [activity setCenter:self.view.center];
    [web addSubview:activity];
    activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    activity.hidden=YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    activity.hidden=NO;
    [activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];

    [activity stopAnimating];
    activity.hidden=YES;
}
-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    [activity stopAnimating];
    activity.hidden=YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
