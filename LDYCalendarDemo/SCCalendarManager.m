//
//  SCCalendarManager.m
//  SealChat
//
//  Created by yang on 2017/5/18.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import "SCCalendarManager.h"
#import "NSDate+LDYCategory.h"

@interface SCCalendarManager ()
@property (nonatomic, strong) NSCalendar *calendar;
@end
@implementation SCCalendarManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self currentCalendar];
    }
    return self;
}
+ (instancetype)defaultManager
{
    @synchronized(self) {
        static SCCalendarManager *defaultInstance = nil;
        static dispatch_once_t dbToken;
        dispatch_once(&dbToken, ^{
            defaultInstance = [[self alloc] init];
        });
        
        return defaultInstance;
    }
}
- (NSCalendar *)currentCalendar
{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.minimumDaysInFirstWeek = 7;
        _calendar.firstWeekday = 2;
    }
    return _calendar;
}
//每月的天数
- (NSInteger)daysForMonth:(NSInteger)month byYear:(NSInteger)year
{
    if (month >=1 && month <= 12) {
        NSString *dateFormatStr = [SCCalendarManager stringForDateFormateWithDay:1 month:month byYear:year];
        NSDate *date = [NSDate dateFromFormattedDay:dateFormatStr];
        NSRange range = [[[SCCalendarManager defaultManager] currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        return range.length;
    }else{
        NSLog(@"month : %ld",month);
    }
    return 0;
}
//格式化时间字符串 如：@“2017/05/18”
+ (NSString *)stringForDateFormateWithDay:(NSInteger)day month:(NSInteger)month byYear:(NSInteger)year
{
    return [NSString stringWithFormat:@"%ld.%02ld.%02ld",year,month,day];
}
//获取NSDateComponents
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date
{
    int unit = NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [_calendar components:unit fromDate:date];
    
//    long week = ([date timeIntervalSince1970] * 1000 - 1483286400000) / 7 / 24 / 60 / 60 / 1000 + 1;//服务器周计算方法
    return nowCmps;
}
//每月有多少周
- (NSInteger)weekCountOfMonth:(NSInteger)month byYear:(NSInteger)year
{
    NSInteger days = [self daysForMonth:month byYear:year];
    
    NSString *lastDayStr = [SCCalendarManager stringForDateFormateWithDay:days month:month byYear:year];
    NSDateComponents *lastComp = [self dateComponentsWithDate:[NSDate dateFromFormattedDay:lastDayStr]];
    return lastComp.weekOfMonth + 1;
}
//当前时间所在周的起止时间
- (NSDictionary *)daysOfWeekWithDate:(NSDate *)date
{
    if (date == nil) {
        return nil;
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    BOOL ok = [_calendar rangeOfUnit:NSCalendarUnitWeekday startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDictionary *dict = @{@"start" : beginDate,
                           @"end" : endDate};
    return dict;
}
//获取月所有周的起止时间数组
- (NSArray *)weeksOfMonthWithMonth:(NSInteger)month byYear:(NSInteger)year
{
    if (year <= 0 || month <= 0) {
        return nil;
    }
    NSInteger weekCount = [self weekCountOfMonth:month byYear:year];
    
    NSString *firstDayStr = [SCCalendarManager stringForDateFormateWithDay:1 month:month byYear:year];
    NSDate *firstDate = [NSDate dateFromFormattedDay:firstDayStr];
    NSDateComponents *firstComp = [self dateComponentsWithDate:firstDate];
    
    if (firstDate == nil) {
        return nil;
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    BOOL ok = [_calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:firstDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < weekCount; i++) {
        NSInteger weekOfMonth = firstComp.weekOfMonth + i;
        NSInteger weekOfYear = firstComp.weekOfYear + i;
        NSDate *newBeginDate = [beginDate dateByAddingTimeInterval:interval * i];
        NSDate *newEndDate = [endDate dateByAddingTimeInterval:interval * i];
        NSDictionary *dict = @{@"start" : newBeginDate,
                               @"end" : newEndDate,
                               @"weekOfMonth" : @(weekOfMonth),
                               @"weekOfYear" : @(weekOfYear)};
        [array addObject:dict];
    }
    NSLog(@"%@",array);
    return array;
}
//获取年信息
- (NSArray *)yearsInfoArray:(NSInteger)num
{
    if (num <= 0) {
        return nil;
    }
    NSMutableArray *infoArray = [NSMutableArray array];
    NSDateComponents *comp =  [self dateComponentsWithDate:[NSDate date]];
    for (NSInteger i = 0; i < num; i++) {
        [infoArray addObject:[NSString stringWithFormat:@"%ld",(comp.year - i)]];
    }
    return infoArray;
}
//获取月信息
- (NSArray *)monthInfoArray
{
    NSArray *monthArray = _calendar.shortMonthSymbols;
    NSMutableArray *infoArray = [NSMutableArray array];
    [infoArray addObject:@"年度"];
    [infoArray addObjectsFromArray:monthArray];
    return infoArray;
}
+ (NSInteger)currentMonth
{
    NSDateComponents *comp = [[SCCalendarManager defaultManager] dateComponentsWithDate:[NSDate date]];
    return comp.month;
}
+ (NSInteger)currentYear
{
    NSDateComponents *comp = [[SCCalendarManager defaultManager] dateComponentsWithDate:[NSDate date]];
    return comp.year;
}
+ (NSInteger)currentWeekOfMonth
{
    NSDateComponents *comp = [[SCCalendarManager defaultManager] dateComponentsWithDate:[NSDate date]];
    return comp.weekOfMonth;
}
@end
