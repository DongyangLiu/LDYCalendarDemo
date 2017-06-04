//
//  NSDate+LDYCategory.h
//  LDYCalendarDemo
//
//  Created by yang on 2017/6/4.
//  Copyright © 2017年 com.tixa.SealChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LDYCategory)
//根据类型返回不同格式的时间字符串
- (NSString *)formattedDateType:(NSInteger)type;
+ (NSDate *)dateFromFormattedDay:(NSString *)desc; // @"yyyy-MM-dd" to date

@end
