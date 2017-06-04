//
//  SCCalendarManager.h
//  SealChat
//
//  Created by yang on 2017/5/18.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCalendarManager : NSObject
+ (instancetype)defaultManager;

- (NSCalendar *)currentCalendar;

//获取月所有周的起止时间数组；
- (NSArray *)weeksOfMonthWithMonth:(NSInteger)month byYear:(NSInteger)year;
//获取年信息
- (NSArray *)yearsInfoArray:(NSInteger)num;
//获取月信息
- (NSArray *)monthInfoArray;
+ (NSInteger)currentYear;
+ (NSInteger)currentMonth;
+ (NSInteger)currentWeekOfMonth;

- (NSDictionary *)daysOfWeekWithDate:(NSDate *)date;

//获取NSDateComponents
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;
//每月的天数
- (NSInteger)daysForMonth:(NSInteger)month byYear:(NSInteger)year;
//格式化时间字符串 如：@“2017/05/18”
+ (NSString *)stringForDateFormateWithDay:(NSInteger)day month:(NSInteger)month byYear:(NSInteger)year;
@end
