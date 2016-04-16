//
//  UIButton+FUNButtonBlock.m
//  Store
//
//  Created by 云音 on 15/8/24.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import "UIButton+FUNButtonBlock.h"


@implementation UIButton (FUNButtonBlock)

static char overviewKey = 'a';

- (void)addMethodBlock:(ActionBlock) actionBlock withEvent:(UIControlEvents)controlEvents
{
    objc_setAssociatedObject(self, &overviewKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(clickButton) forControlEvents:controlEvents];
}

- (void)clickButton
{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(self);
    }
}
@end
