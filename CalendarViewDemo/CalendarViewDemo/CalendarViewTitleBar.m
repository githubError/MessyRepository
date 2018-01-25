//
//  CPF_ChartViewtitleBar.m
//  yujianXin
//
//  Created by JWTHiOS02 on 2018/1/2.
//  Copyright © 2018年 经纬泰和. All rights reserved.
//

#import "CalendarViewTitleBar.h"
#import <Masonry.h>

@interface CalendarViewTitleBar ()

@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation CalendarViewTitleBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)prevBarButtonDidClick:(UIButton *)button {
    self.lastCommand = CalendarViewTitleBarCommandPrevious;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)nextBarButtonDidClick:(UIButton *)button {
    self.lastCommand = CalendarViewTitleBarCommandNext;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setupSubviews {
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    prevButton.transform = CGAffineTransformMakeRotation(-M_PI);
    prevButton.tag = 1;
    [prevButton addTarget:self action:@selector(prevBarButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevButton];
    [prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.height.width.equalTo(@40);
    }];
    self.prevButton = prevButton;
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    nextButton.tag = 2;
    [nextButton addTarget:self action:@selector(nextBarButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.height.width.equalTo(@40);
    }];
    self.nextButton = nextButton;
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"Label";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(prevButton.mas_right);
            make.right.equalTo(nextButton.mas_left);
            make.centerY.equalTo(self);
        }];
        
        label;
    });
}

@end
