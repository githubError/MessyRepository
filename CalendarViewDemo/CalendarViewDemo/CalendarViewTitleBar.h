//
//  CPF_ChartViewtitleBar.h
//  yujianXin
//
//  Created by JWTHiOS02 on 2018/1/2.
//  Copyright © 2018年 经纬泰和. All rights reserved.
//  心率、血压统计图 顶部 title Bar

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarViewTitleBarCommand) {
    CalendarViewTitleBarCommandNoCommand = 0,
    CalendarViewTitleBarCommandPrevious,
    CalendarViewTitleBarCommandNext
};

@interface CalendarViewTitleBar : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CalendarViewTitleBarCommand lastCommand;

@end
