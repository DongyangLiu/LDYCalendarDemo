//
//  NSString+LDYCategory.m
//  LDYCalendarDemo
//
//  Created by yang on 2017/6/4.
//  Copyright © 2017年 com.tixa.SealChat. All rights reserved.
//

#import "NSString+LDYCategory.h"

@implementation NSString (LDYCategory)
-(CGSize)safeSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
}
@end
