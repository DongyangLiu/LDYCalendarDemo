//
//  NSDate+LDYCategory.m
//  LDYCalendarDemo
//
//  Created by yang on 2017/6/4.
//  Copyright © 2017年 com.tixa.SealChat. All rights reserved.
//

#import "NSDate+LDYCategory.h"

@implementation NSDate (LDYCategory)
- (NSString *)formattedDateType:(NSInteger)type
{
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    switch (type) {
        case 1:
            [myDateFormatter setDateFormat:@"yyyy.MM.dd"];
            break;
            
        default:
            break;
    }
    NSString *dateString = [myDateFormatter stringFromDate:self];
    return dateString;
}
// @"yyyy-MM-dd" to date
+ (NSDate *)dateFromFormattedDay:(NSString *)desc{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:desc];
    return date;
}
@end
