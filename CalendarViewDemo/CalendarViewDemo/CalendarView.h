//
//  DrawView.h
//  TestYYText
//
//  Created by JWTHiOS02 on 2018/1/17.
//  Copyright © 2018年 JWTHiOS02. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarView;
@protocol CalendarViewDelegate <NSObject>

// 行数
- (NSUInteger)numberOfRowsIncalendarView:(CalendarView *)calendarView;

// 列数
- (NSUInteger)numberOfCosIncalendarView:(CalendarView *)calendarView;

// 元素文字
- (NSString *)calendarView:(CalendarView *)calendarView titleForItemAtIndex:(NSUInteger)index;

@optional

// 元素文字
- (NSString *)calendarView:(CalendarView *)calendarView subTitleForItemAtIndex:(NSUInteger)index;

// 点击位置
- (void)calendarView:(CalendarView *)calendarView didSelectedItemAtIndex:(NSUInteger)index;

// 所有选中的集合
- (void)calendarView:(CalendarView *)calendarView selectedItemsWithArray:(NSArray <NSDictionary *>*)selectedArray;

// 选中前一个月
- (void)calendarView:(CalendarView *)calendarView didSelectedPreviousMonthAtIndex:(NSUInteger)index;

// 选中后一个月
- (void)calendarView:(CalendarView *)calendarView didSelectedCurrentMonthAtIndex:(NSUInteger)index;

// 选中后一个月
- (void)calendarView:(CalendarView *)calendarView didSelectedNextMonthAtIndex:(NSUInteger)index;

// 内边距
- (UIEdgeInsets)edgeInsetsForCalendarView:(CalendarView *)calendarView;

// item 间隔
- (UIOffset)offsetForCalendarView:(CalendarView *)calendarView;

@end

@interface CalendarView : UIView

@property (nonatomic, weak) id <CalendarViewDelegate> delegate;

/**
 是否允许多选，默认单选
 */
@property (nonatomic, assign) BOOL canMutableSelect;

/**
 默认选中
 */
@property (nonatomic, strong) NSArray *selectIndexArray;

@property (nonatomic, strong) UIFont *subTitleFont;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIFont *selectedTextFont;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, strong) UIColor *blockBackgroundColor;
@property (nonatomic, strong) UIColor *blockSelectedBackgroundColor;

- (void)reloadData;

@end
