//
//  UIButton+FUNButtonBlock.h
//  Store
//
//  Created by 云音 on 15/8/24.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (FUNButtonBlock)

typedef void (^ActionBlock)(UIButton *bt);

- (void)addMethodBlock:(ActionBlock) actionBlock withEvent:(UIControlEvents)controlEvents;

@end

