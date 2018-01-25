//
//  DrawView.m
//  TestYYText
//
//  Created by JWTHiOS02 on 2018/1/17.
//  Copyright © 2018年 JWTHiOS02. All rights reserved.
//

#import "CalendarView.h"

@interface CalendarView ()

{
    NSInteger previousMonthIndex;
    NSInteger nextMonthIndex;
}

/**
 面板中所有的block {index:1,value:CGRectValue}
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *blockArray;


/**
 存储选中的block  {index:1,value:CGRectValue}
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *selectedBlockArray;

@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initConfig];
    }
    return self;
}

- (void)_initConfig {
    NSMutableArray *blockArray = [NSMutableArray array];
    self.blockArray = blockArray;
    NSMutableArray *selectedBlockArray = [NSMutableArray array];
    self.selectedBlockArray = selectedBlockArray;
    
    self.canMutableSelect = NO;
    
    self.selectIndexArray = @[];
    
    self.subTitleFont = [UIFont systemFontOfSize:10];
    
    self.textFont = [UIFont systemFontOfSize:18];
    self.selectedTextFont = [UIFont systemFontOfSize:19];
    
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor whiteColor];
    
    self.blockBackgroundColor = [UIColor whiteColor];
    self.blockSelectedBackgroundColor = [UIColor colorWithRed:252/255.f green:75/255.f blue:73/255.f alpha:1];
    
    
    // 标记前一个月和后一个月
    previousMonthIndex = UINTMAX_MAX;
    nextMonthIndex = UINTMAX_MAX;
}

- (void)drawRect:(CGRect)rect {
    
    [self.blockArray removeAllObjects];
    
    NSUInteger row = [self.delegate numberOfRowsIncalendarView:self];    // 行
    NSUInteger cos = [self.delegate numberOfCosIncalendarView:self];    // 列
    
    CGFloat top = 15.f;
    CGFloat bottom = 15.f;
    CGFloat left = 15.f;
    CGFloat right = 15.f;
    
    CGFloat horizontal = 15.f;      // 水平
    CGFloat vertical = 15.f;
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetsForCalendarView:)]) {
        UIEdgeInsets edgeInset = [self.delegate edgeInsetsForCalendarView:self];
        top = edgeInset.top;
        bottom = edgeInset.bottom;
        left = edgeInset.left;
        right = edgeInset.right;
    }
    
    if ([self.delegate respondsToSelector:@selector(offsetForCalendarView:)]) {
        UIOffset offset = [self.delegate offsetForCalendarView:self];
        horizontal = offset.horizontal;
        vertical = offset.vertical;
    }
    
    CGFloat width = rect.size.width;
    CGFloat blockW = (width - left - right - (cos - 1) * horizontal ) / cos;
    CGFloat blockH = blockW;
    
    // item 高度计算（宽高不相等时）
//    CGFloat height = rect.size.height;
//    CGFloat blockH = (height - top - bottom - (row - 1) * vertical) / row;
    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < cos; j++) {
            CGFloat blockX = j * (blockW + horizontal) + left;
            CGFloat blockY = i * (blockH + horizontal) + top;
            
            CGRect blockRect = CGRectMake(blockX, blockY, blockW, blockH);
            NSValue *blockRectValue = [NSValue valueWithCGRect:blockRect];
            
            NSDictionary *blockDic = [NSDictionary dictionaryWithObjectsAndKeys:@(i * cos + j),@"index",blockRectValue,@"value", nil];
            
            [self.blockArray addObject:blockDic];
        }
    }
    
    // 设置默认选中
    if (self.selectIndexArray != nil && self.selectIndexArray.count < self.blockArray.count) {
        [self.selectedBlockArray removeAllObjects];
        [self.selectIndexArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [obj integerValue];
            if (index >= 0 && index < self.blockArray.count) {
                [self.selectedBlockArray addObject:self.blockArray[index]];
            }
            
            if (!self.canMutableSelect && self.selectedBlockArray.count > 0) {
                *stop = YES;
            }
        }];
        self.selectIndexArray = nil;
    }
    
    for (int i = 0; i < self.blockArray.count; i++) {
        NSDictionary *valueDic = self.blockArray[i];
        if ([self.delegate respondsToSelector:@selector(calendarView:subTitleForItemAtIndex:)]) {
            [self drawText:[self.delegate calendarView:self titleForItemAtIndex:i] andSubTitle:[self.delegate calendarView:self subTitleForItemAtIndex:i] inValueDic:valueDic];
        } else {
            
            [self drawText:[self.delegate calendarView:self titleForItemAtIndex:i] andSubTitle:nil inValueDic:valueDic];
        }
    }
}

-(void)drawText:(NSString *)text andSubTitle:(NSString *)subTitle inValueDic:(NSDictionary *)valueDic {
    
    NSValue *blockValue = valueDic[@"value"];
    CGRect rect = [blockValue CGRectValue];
    
    // 标题 公历
    NSString *_title = text;
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    
    // 副标题 农历
    NSString *_subTitle = subTitle;
    NSMutableDictionary *subTitleDict = [NSMutableDictionary dictionary];
    
    if ([self _checkIsContainWithValueDic:valueDic]) {
        // 选中
        //设置标题颜色 大小
        textDict[NSForegroundColorAttributeName] = self.selectedTextColor;
        textDict[NSFontAttributeName] = self.selectedTextFont;
        
        //设置副标题颜色 大小
        subTitleDict[NSForegroundColorAttributeName] = self.selectedTextColor;
        subTitleDict[NSFontAttributeName] = self.subTitleFont;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(context, rect);
        [self.blockSelectedBackgroundColor set];
        CGContextFillPath(context);
        
        // 检验当前月
        if ([self _checkIsCurrentMonthWithText:text inValueDic:valueDic]) {
            textDict[NSForegroundColorAttributeName] = self.selectedTextColor;
            
            subTitleDict[NSForegroundColorAttributeName] = self.selectedTextColor;
        } else {
            textDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
            
            subTitleDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        }
        
        
    } else {
        // 未选中
        
        //设置标题文字颜色 大小
        textDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        textDict[NSFontAttributeName] = self.textFont;
        
        //设置副标题文字颜色 大小
        subTitleDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        subTitleDict[NSFontAttributeName] = self.subTitleFont;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(context, rect);
        [self.blockBackgroundColor set];
        CGContextFillPath(context);
        
        // 检验当前月
        if ([self _checkIsCurrentMonthWithText:text inValueDic:valueDic]) {
            textDict[NSForegroundColorAttributeName] = self.textColor;
            
            subTitleDict[NSForegroundColorAttributeName] = self.textColor;
        } else {
            textDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
            
            subTitleDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        }
    }
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    
    textDict[NSParagraphStyleAttributeName] = ps;
    subTitleDict[NSParagraphStyleAttributeName] = ps;
    
    CGSize textSize = [_title sizeWithAttributes:textDict];
    
    CGSize subTextSize = [_subTitle sizeWithAttributes:subTitleDict];
    
    CGRect textRect = CGRectMake(rect.origin.x + (rect.size.width - textSize.width)/2.f, rect.origin.y + (rect.size.height - textSize.height - subTextSize.height )/2.f, textSize.width, textSize.height);
    
    [_title drawInRect:textRect withAttributes:textDict];
    
    CGRect subTextRect = CGRectMake(rect.origin.x + (rect.size.width - subTextSize.width)/2.f, rect.origin.y + (rect.size.height + subTextSize.height/2.f)/2.f, subTextSize.width, subTextSize.height);
    
    [_subTitle drawInRect:subTextRect withAttributes:subTitleDict];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.blockArray enumerateObjectsUsingBlock:^(NSDictionary *valueDic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger index = [valueDic[@"index"] integerValue];
        NSValue *blockValue = valueDic[@"value"];
        
        CGRect blockRect = blockValue.CGRectValue;
        if (CGRectContainsPoint(blockRect, touchPoint)) {
            
            // 非当前月不可点击，调用代理
            if (idx <= previousMonthIndex) {
                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectedPreviousMonthAtIndex:)]) {
                    [self.delegate calendarView:self didSelectedPreviousMonthAtIndex:idx];
                }
                return ;
            }
            
            if (idx >= nextMonthIndex) {
                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectedNextMonthAtIndex:)]) {
                    [self.delegate calendarView:self didSelectedNextMonthAtIndex:idx];
                }
                return ;
            }
            
            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectedCurrentMonthAtIndex:)]) {
                [self.delegate calendarView:self didSelectedCurrentMonthAtIndex:idx];
            }
            
            
            if (self.canMutableSelect) {
                // 多选
                [self _selectValueDic:valueDic];
                
            } else {
                // 单选
                [self.selectedBlockArray removeAllObjects];
                [self _selectValueDic:valueDic];
            }
            
            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectedItemAtIndex:)]) {
                [self.delegate calendarView:self didSelectedItemAtIndex:index];
            }
            
            if ([self.delegate respondsToSelector:@selector(calendarView:selectedItemsWithArray:)]) {
                [self.delegate calendarView:self selectedItemsWithArray:self.selectedBlockArray];
            }
            
            // 重绘
            [self reloadData];
            
            *stop = YES;
        }
    }];
}


/**
 检查 valueDic 是否存在于 selectedBlockArray ，若存在则移除，不存在则加入

 @param valueDic 待检验的valueDic，结构为：{index:1,value:CGRectValue}
 */
- (void)_selectValueDic:(NSDictionary *)valueDic {
    
    NSDictionary *selectedDic = [self _checkIsContainWithValueDic:valueDic];
    if (selectedDic) {
        // 已选中
        [self.selectedBlockArray removeObject:selectedDic];
    } else {
        // 未选中
        [self.selectedBlockArray addObject:valueDic];
    }
}



/**
 检验 selectedBlockArray 中是否包含 valueDic，若包含则返回该 valueDic， 否则返回 nil

 @param valueDic 待检验的valueDic
 @return 返回值 valueDic或nil
 */
- (NSDictionary *)_checkIsContainWithValueDic:(NSDictionary *)valueDic {
    NSUInteger index = [valueDic[@"index"] integerValue];
    NSDictionary *selectedDic = nil;
    for (int i = 0; i < self.selectedBlockArray.count; i++) {
        NSDictionary *blockDic = self.selectedBlockArray[i];
        if ([blockDic[@"index"] integerValue] == index) {
            selectedDic = blockDic;
            break;
        }
    }
    return selectedDic;
}


/**
 根据日历文字，检查是否为当前月

 @param text 当前日期，文字
 @param valueDic 当前日期，记录索引
 @return 检验结果
 */
- (BOOL)_checkIsCurrentMonthWithText:(NSString *)text inValueDic:(NSDictionary *)valueDic {
    NSUInteger currentIndex = [valueDic[@"index"] integerValue];
    if ([text isEqualToString:@"1"]) {
        if (nextMonthIndex == UINTMAX_MAX && previousMonthIndex != UINTMAX_MAX) {
            nextMonthIndex = currentIndex;
        }
        if (previousMonthIndex == UINTMAX_MAX && nextMonthIndex == UINTMAX_MAX) {
            previousMonthIndex = currentIndex == 0 ? 0 : currentIndex - 1;
        }
    }
    if (previousMonthIndex != UINTMAX_MAX && nextMonthIndex == UINTMAX_MAX) {
        return YES;
    }
    return NO;
}

- (void)reloadData {
    
    // 标记前一个月和后一个月
    previousMonthIndex = UINTMAX_MAX;
    nextMonthIndex = UINTMAX_MAX;
    
    [self setNeedsDisplay];
}


@end
