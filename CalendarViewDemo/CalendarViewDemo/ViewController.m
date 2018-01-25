//
//  ViewController.m
//  CalendarViewDemo
//
//  Created by JWTHiOS02 on 2018/1/25.
//  Copyright © 2018年 JWTHiOS02. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "CalendarView.h"
#import "CalendarViewTitleBar.h"
#import "LunarCore.h"

@interface ViewController () <CalendarViewDelegate>

@property (nonatomic, strong) CalendarViewTitleBar *titleBar;
@property (nonatomic, strong) CalendarView *calendarView;

@property (nonatomic, strong) NSArray *monthDataArray;

// 今天
@property (nonatomic, strong) NSDictionary *nowDateDic;

// 记录当前移动到的日期
@property (nonatomic, assign) int currentYear;
@property (nonatomic, assign) int currentMonth;
@property (nonatomic, assign) int currentDay;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTitleBar];
    
    [self setupCalendarView];
    
    [self configCurrentData];
    
    self.monthDataArray = [self fetchMonthDataArrayWithYear:self.currentYear andMonth:self.currentMonth];
    self.titleBar.titleLabel.text = [NSString stringWithFormat:@"%d年%02d月",self.currentYear, self.currentMonth];
    self.calendarView.selectIndexArray = @[@([self currentDayIndexWithMonthDataArray:self.monthDataArray])];
    [self.calendarView reloadData];
    
    NSLog(@"%@",self.monthDataArray);
}

- (void)configCurrentData {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy"];
    NSString *currentYear = [formater stringFromDate:currentDate];
    
    [formater setDateFormat:@"MM"];
    NSString *currentMonth = [formater stringFromDate:currentDate];
    
    [formater setDateFormat:@"dd"];
    NSString *currentDay = [formater stringFromDate:currentDate];
    
    self.nowDateDic = [NSDictionary dictionaryWithObjectsAndKeys:currentYear,@"year", currentMonth,@"month", currentDay,@"day", nil];
    
    self.currentYear = [currentYear intValue];
    self.currentMonth = [currentMonth intValue];
    self.currentDay = [currentDay intValue];
}

- (NSArray *)fetchMonthDataArrayWithYear:(int)year andMonth:(int)month {
    NSDictionary *monthDataDic = calendar(year,month);
    NSArray *monthDataArray = monthDataDic[@"monthData"];
    return monthDataArray;
}

- (NSUInteger)currentDayIndexWithMonthDataArray:(NSArray *)monthDataArray {
    __block NSUInteger currentDayIndex = UINTMAX_MAX;
    [monthDataArray enumerateObjectsUsingBlock:^(NSDictionary *dayDataDic, NSUInteger index, BOOL * _Nonnull stop) {
        if ([dayDataDic[@"year"] intValue] == [self.nowDateDic[@"year"] intValue] && [dayDataDic[@"month"] intValue] == [self.nowDateDic[@"month"] intValue] && [dayDataDic[@"day"] intValue] == [self.nowDateDic[@"day"] intValue]) {
            currentDayIndex = index;
            *stop = YES;
        }
    }];
    return currentDayIndex;
}

- (void)showNextCalendar{
    if (self.currentMonth != 12) {
        self.currentMonth++;
    } else {
        self.currentMonth = 1;
        self.currentYear++;
    }
    self.monthDataArray = [self fetchMonthDataArrayWithYear:self.currentYear andMonth:self.currentMonth];
    self.titleBar.titleLabel.text = [NSString stringWithFormat:@"%d年%02d月",self.currentYear, self.currentMonth];
}

- (void)showPreviousCalendar {
    if (self.currentMonth != 1) {
        self.currentMonth--;
    } else {
        self.currentMonth = 12;
        self.currentYear--;
    }
    self.monthDataArray = [self fetchMonthDataArrayWithYear:self.currentYear andMonth:self.currentMonth];
    self.titleBar.titleLabel.text = [NSString stringWithFormat:@"%d年%02d月",self.currentYear, self.currentMonth];
}

- (void)titleBarDidClick:(CalendarViewTitleBar *)bar {
    switch (bar.lastCommand) {
        case CalendarViewTitleBarCommandNext:
        {
            [self showNextCalendar];
            self.calendarView.selectIndexArray = @[@([self currentDayIndexWithMonthDataArray:self.monthDataArray])];
            [self.calendarView reloadData];
        }
            break;
        case CalendarViewTitleBarCommandPrevious:
        {
            [self showPreviousCalendar];
            self.calendarView.selectIndexArray = @[@([self currentDayIndexWithMonthDataArray:self.monthDataArray])];
            [self.calendarView reloadData];
        }
            break;
            
        default:
            break;
    }
}

- (void)setupTitleBar {
    CalendarViewTitleBar *titleBar = [[CalendarViewTitleBar alloc] init];
    titleBar.titleLabel.text = @"测试标题";
    [self.view addSubview:titleBar];
    [titleBar addTarget:self action:@selector(titleBarDidClick:) forControlEvents:UIControlEventValueChanged];
    [titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(@(-30));
        make.height.equalTo(@40);
        make.top.equalTo(self.view).offset(100);
    }];
    self.titleBar = titleBar;
}


- (void)setupCalendarView {
    CalendarView *calendarView = [[CalendarView alloc] init];
    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.delegate = self;
    calendarView.canMutableSelect = NO;
    [self.view addSubview:calendarView];
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.view.bounds.size.width));
        make.height.equalTo(@(self.view.bounds.size.width / 7 * 6));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleBar.mas_bottom).offset(0);
    }];
    self.calendarView = calendarView;
}

#pragma mark DrawViewDelegate

- (NSUInteger)numberOfRowsIncalendarView:(CalendarView *)calendarView {
    return 6;
}

- (NSUInteger)numberOfCosIncalendarView:(CalendarView *)calendarView {
    return 7;
}

- (UIEdgeInsets)edgeInsetsForCalendarView:(CalendarView *)calendarView {
    return UIEdgeInsetsMake(20, 30, 20, 30);
}

- (UIOffset)offsetForCalendarView:(CalendarView *)calendarView {
    return UIOffsetMake(5, 5);
}

- (NSString *)calendarView:(CalendarView *)calendarView titleForItemAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%@",self.monthDataArray[index][@"day"]];
}

- (NSString *)calendarView:(CalendarView *)calendarView subTitleForItemAtIndex:(NSUInteger)index {
    NSString *subTitle = [self.monthDataArray[index][@"lunarDayName"]  isEqualToString:@"初一"] ? self.monthDataArray[index][@"lunarMonthName"] : self.monthDataArray[index][@"lunarDayName"];
    return subTitle;
}

- (void)calendarView:(CalendarView *)calendarView selectedItemsWithArray:(NSArray<NSDictionary *> *)selectedArray {
    //    NSLog(@"---> %@",selectedArray);
}

- (void)calendarView:(CalendarView *)calendarView didSelectedItemAtIndex:(NSUInteger)index {
    NSLog(@"+++-> %zd",index);
}

- (void)calendarView:(CalendarView *)calendarView didSelectedPreviousMonthAtIndex:(NSUInteger)index {
    NSLog(@"选中前一个月 %zd",index);
}

- (void)calendarView:(CalendarView *)calendarView didSelectedCurrentMonthAtIndex:(NSUInteger)index {
    NSLog(@"选中当前月 %zd",index);
}

- (void)calendarView:(CalendarView *)calendarView didSelectedNextMonthAtIndex:(NSUInteger)index {
    NSLog(@"选中后一个月 %zd",index);
}

@end
