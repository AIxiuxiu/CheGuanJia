//
//  signinViewController.m
//  OuJia
//
//  Created by GuoZi on 15/11/20.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "signinViewController.h"

@interface signinViewController ()
{
    UIImageView *_bgImg;
}

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;

@end

@implementation signinViewController
{
    UIImageView *qianImg;
    UIView *helpView;
    BOOL _ishelp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titLab.text = @"签到";
    _ishelp = NO;
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 27, 26, 26)];
    helpBtn.layer.masksToBounds = YES;
    helpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    helpBtn.layer.borderWidth = 2;
    helpBtn.layer.cornerRadius = 13;
    [helpBtn setTitle:@"?" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(goToHelper) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpBtn];
    
    //---------日历
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    if (iPhone6Plus) {
        _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIHT-340, SCREEN_WIDTH, 340)];
    }
    else if (iPhone6) {
        _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIHT-300, SCREEN_WIDTH, 300)];
    }else if(iPhone5)
    {
        _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIHT-270, SCREEN_WIDTH, 270)];
    }else
    {
        _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIHT-270, SCREEN_WIDTH, 270)];
    }
    _customCalendarView.backgroundColor = [UIColor clearColor];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.monthAndDayTextColor        = [UIColor grayColor];//下个月
    _customCalendarView.dayBgColorWithData          =  [UIColor clearColor];//已经过去的
    _customCalendarView.dayBgColorWithoutData       = [UIColor whiteColor];
    _customCalendarView.dayBgColorSelected          = RGBACOLOR(251, 214, 47, 1);//选择的
    _customCalendarView.dayTxtColorWithoutData      =  [UIColor clearColor];//
    _customCalendarView.dayTxtColorWithData         = [UIColor blackColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor blackColor];
    _customCalendarView.borderColor                 = [UIColor clearColor];
    _customCalendarView.borderWidth                 = 1;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    
    //----------top签到
    if (iPhone6Plus) {
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 280-NAVHEIGHT)];
    }else if(iPhone6){
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 240-NAVHEIGHT)];
    }else if (iPhone5){
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 210-NAVHEIGHT)];
    }else if(iPhone4){
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, 210-NAVHEIGHT)];
    }
    _bgImg.image = [UIImage imageNamed:@"chebeijingtu"];
    [self.view addSubview:_bgImg];
    qianImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    qianImg.image = [UIImage imageNamed:@"qiandaoanniu"];
    [_bgImg addSubview:qianImg];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, qianImg.frame.size.height/2-50+NAVHEIGHT, 100, 100);
    signInBtn.backgroundColor = [UIColor clearColor];
    signInBtn.layer.cornerRadius = 50;
    signInBtn.layer.masksToBounds = YES;
    [signInBtn  addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    UILabel* lianxuLab = [[UILabel alloc] init];
    lianxuLab.frame = CGRectMake(SCREEN_WIDTH/2-40 , qianImg.frame.size.height/2+10+NAVHEIGHT , 80, 20);
    lianxuLab.textColor = RGBACOLOR(166, 140, 46, 1);
    lianxuLab.textAlignment = NSTextAlignmentCenter;
    lianxuLab.font = [UIFont systemFontOfSize:11];
    lianxuLab.text = @"连续签到10天";
    [self.view addSubview:lianxuLab];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgImg.frame), SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineView];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgImg.frame)+10, SCREEN_WIDTH, 50)];
    [self.view addSubview:tipView];

    UILabel* noteLabel = [[UILabel alloc] init];
    noteLabel.frame = CGRectMake(0 , 0 , SCREEN_WIDTH, 60);
    noteLabel.textColor = [UIColor redColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.font = [UIFont systemFontOfSize:20];
    
    NSString *noteString = [NSString stringWithFormat:@"活跃天数  %@  天",@"100"];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:noteString];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"活跃天数"].location, [[noteStr string] rangeOfString:@"活跃天数"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    
    NSRange tianRange = NSMakeRange([[noteStr string] rangeOfString:@" 天"].location, [[noteStr string] rangeOfString:@" 天"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:tianRange];
    [noteLabel setAttributedText:noteStr];
    [tipView addSubview:noteLabel];
    
    UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 18, 45, 20)];
    tipImg.image = [UIImage imageNamed:@"yiqiandao"];
    [tipView addSubview:tipImg];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgImg.frame)+59, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_LINE;
    [self.view addSubview:line];
    
    
//    UIImageView *roleImag = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(progressView.frame)+110, SCREEN_WIDTH-40, SCREEN_HEIHT-(CGRectGetMaxY(progressView.frame)+110+20))];
//    roleImag.image = [UIImage imageNamed:@"qiandaojifen"];
//    [self.view addSubview:roleImag];
    
}
-(void)signInBtnClick:(UIButton *)btn
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签到成功,明天记得签到获得更多积分哦~" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)goToHelper
{
    if (_ishelp==NO) {
        
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             helpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIHT-64)];
             helpView.backgroundColor = [UIColor blackColor];
             helpView.alpha = 0.8;
             [self.view addSubview:helpView];
             UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHelp)];
             [helpView addGestureRecognizer:ges];
         }
                         completion:^(BOOL finished){
                             UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, SCREEN_WIDTH-80, 300)];
                             imagV.backgroundColor = [UIColor redColor];
                             [helpView addSubview:imagV];
                         }];
        _ishelp =YES;
    }
}
-(void)hideHelp{
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         [helpView removeFromSuperview];
     }completion:^(BOOL finished){
         
     }];
    _ishelp = NO;
}

#pragma mark - Gesture recognizer

-(void)swipeleft:(id)sender
{
    [_customCalendarView showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_customCalendarView showPreviousMonth];
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    
    NSLog(@"dayChangedToDate %@(GMT)",selectedDate);
    
    
//    UIImageView *qiandaoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
//    [qiandaoImg setImage:[UIImage imageNamed:@"qiandao"]];
//    [_customCalendarView addSubview:qiandaoImg];
}

#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"M/d/yyyy h:m a"];
    
//    NSString *stringTime = @"12/5/2011 3:4 am";
    
//    NSDate *dateTime = [formatter dateFromString:stringTime];
    
//    NSLog(@"%@", dateTime);
    if ([date compare:[NSDate date]] == NSOrderedAscending)
    {
       // NSLog(@"date==%@",date);
    }
        return YES;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:date];
    return (yearComponent.year == _currentYear || yearComponent.year == _currentYear+1|| yearComponent.year == _currentYear-1);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
