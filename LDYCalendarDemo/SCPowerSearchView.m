//
//  SCPowerSearchView.m
//  SealChat
//
//  Created by yang on 2017/5/19.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import "SCPowerSearchView.h"
#import "SCCalendarManager.h"
#import "UIColor+LDYCategory.h"
#import "NSDate+LDYCategory.h"
#import "NSString+LDYCategory.h"

#define COLOR_1 [UIColor colorWithHexRGB:@"222222"]
#define COLOR_2 [UIColor colorWithHexRGB:@"999999"]
#define COLOR_3 [UIColor colorWithHexRGB:@"09c6d2"]

#define FONT_1 [UIFont boldSystemFontOfSize:16.0f]
#define FONT_2 [UIFont systemFontOfSize:15.0f]
#define FONT_3 [UIFont systemFontOfSize:12.0f]


@interface SCPowerSearchView ()
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, strong) UIView    *contentView;
@property (nonatomic, strong) UILabel   *searchInfoLabel;
@property (nonatomic, copy) NSArray *yearInfoArray;
@property (nonatomic, copy) NSArray *monthInfoArray;
@property (nonatomic, copy) NSArray *weekInfoArray;
@property (nonatomic, strong) UIView *subView_2;
@property (nonatomic, strong) UIView *subView_3;
@end
@implementation SCPowerSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [[[UIApplication sharedApplication] delegate] window].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _yearInfoArray = [NSArray array];
        _monthInfoArray = [NSArray array];
        _weekInfoArray = [NSArray array];
        self.userInteractionEnabled = YES;
        
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blankTap:)];
        [view addGestureRecognizer:tap];
        
    }
    return self;
}
+ (instancetype)createPowerSearchView
{
    SCPowerSearchView *ret = [[SCPowerSearchView alloc]init];
    return ret;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(10.0, (CGRectGetHeight(self.frame) - 500) / 2.0, CGRectGetWidth(self.frame) - 20.0, 500.0f)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.masksToBounds = YES;
    }
    [self addSubview:_contentView];
    
    CGFloat cW = CGRectGetWidth(_contentView.frame);
    CGFloat leftSpace = 20.0f;
    
    CGFloat cY = 20.0f;
    NSString *title = @"查询历史榜单";
    CGSize size = [title safeSizeWithFont:FONT_1];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((cW - size.width) / 2.0, cY, size.width, size.height)];
    titleLabel.font = FONT_1;
    titleLabel.textColor = COLOR_1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [_contentView addSubview:titleLabel];
    
    cY = CGRectGetMaxY(titleLabel.frame) + 12.0f;
    
    if (!_searchInfoLabel) {
        _searchInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace, cY, cW - 2 * leftSpace, 12.0f)];
        _searchInfoLabel.font = FONT_3;
        _searchInfoLabel.textColor = COLOR_2;
        _searchInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    [_contentView addSubview:_searchInfoLabel];
    
    cY = CGRectGetMaxY(_searchInfoLabel.frame) + 30.0f;
    
    NSString *subTitle = @"年份";
    size = [subTitle safeSizeWithFont:FONT_2];
    UILabel *subTitleLabel_1 = [self createSubTitleLabel:CGRectMake(20.0, cY, size.width, size.height) title:subTitle];
    [_contentView addSubview:subTitleLabel_1];
    
    cY = CGRectGetMaxY(subTitleLabel_1.frame) + 15.0f;
    
    _yearInfoArray = [[SCCalendarManager defaultManager] yearsInfoArray:2];
    
    UIView *subView_1 = [self createSubView:CGRectMake(20.0, cY, cW - 40.0f, 0) info:_yearInfoArray type:1];
    [_contentView addSubview:subView_1];
    
    cY = CGRectGetMaxY(subView_1.frame) + 32.0f;
    
    subTitle = @"月份";
    size = [subTitle safeSizeWithFont:FONT_2];
    UILabel *subTitleLabel_2 = [self createSubTitleLabel:CGRectMake(20.0, cY, size.width, size.height) title:subTitle];
    [_contentView addSubview:subTitleLabel_2];
    
    cY = CGRectGetMaxY(subTitleLabel_2.frame) + 15.0f;
    _monthInfoArray = [[SCCalendarManager defaultManager] monthInfoArray];
    
    _subView_2 = [self createSubView:CGRectMake(20.0, cY, cW - 40.0f, 0) info:_monthInfoArray type:2];
    [_contentView addSubview:_subView_2];
    
    cY = CGRectGetMaxY(_subView_2.frame) + 32.0f;
    
    subTitle = @"周";
    size = [subTitle safeSizeWithFont:FONT_2];
    UILabel *subTitleLabel_3 = [self createSubTitleLabel:CGRectMake(20.0, cY, size.width, size.height) title:subTitle];
    [_contentView addSubview:subTitleLabel_3];
    
    cY = CGRectGetMaxY(subTitleLabel_3.frame) + 15.0f;
    
    
    NSMutableArray *infoArray = [self refreshWeekInfoArray];
    
    _subView_3 = [self createSubView:CGRectMake(20.0, cY, cW - 40.0f, 0) info:infoArray type:3];
    [_contentView addSubview:_subView_3];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(cW - 85.0f, CGRectGetHeight(_contentView.frame) - 55.0, 65.0, 25.0)];
    sureButton.backgroundColor = COLOR_3;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = FONT_2;
    [sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = CGRectGetHeight(sureButton.frame) / 2.0;
    sureButton.layer.masksToBounds = YES;
    [_contentView addSubview:sureButton];
    
}
- (NSMutableArray *)refreshWeekInfoArray
{
    _weekInfoArray = [[SCCalendarManager defaultManager] weeksOfMonthWithMonth:_month byYear:_year];
    
    NSMutableArray *infoArray = [NSMutableArray array];
    [infoArray addObject:@"月度"];
    for (NSInteger i = 0; i < _weekInfoArray.count; i++) {
        [infoArray addObject:[NSString stringWithFormat:@"第%ld周",i + 1]];
    }
    return infoArray;
}
- (UILabel *)createSubTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:frame];
    titleLabel.font = FONT_2;
    titleLabel.textColor = COLOR_1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = title;
    return titleLabel;
}
- (UIView *)createSubView:(CGRect)frame info:(NSArray *)infoArray type:(NSInteger)type
{
    if (infoArray.count <= 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.userInteractionEnabled = YES;
    
    [self createButtonsView:view info:infoArray type:type];

    return view;
}
- (void)createButtonsView:(UIView *)view info:(NSArray *)infoArray type:(NSInteger)type
{
    NSInteger column = 4;
    if (type == 2) {
        column = 5;
    }
    
    CGFloat c_space = 12.0f;//列间距
    CGFloat v_space = 15.0f;//行间距
    
    CGFloat bWidth = (view.frame.size.width + c_space) / column - c_space;
    CGFloat bHeight = 25.0f;
    
    CGFloat bX = 0.0f;
    CGFloat bY = 0.0f;
    
    NSInteger maxNum = -1;
    if (type == 2) {
        maxNum = [SCCalendarManager currentMonth];
    }
    for (NSInteger i = 0; i < infoArray.count; i++) {
        bX = i % column * (bWidth + c_space);
        bY = i / column * (bHeight + v_space);
        
        NSString *title = nil;
        
        title = infoArray[i];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(bX, bY, bWidth, bHeight)];
        button.titleLabel.font = FONT_3;
        [button setTitleColor:COLOR_2 forState:UIControlStateNormal];
        [button setTitleColor:COLOR_3 forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = bHeight / 2.0;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [COLOR_2 CGColor];
        button.tag = type * 1000 + i;
        [view addSubview:button];
        
        if (type == 1 && i == 0) {
            _year = [title integerValue];
            button.selected = YES;
            button.layer.borderColor = [COLOR_3 CGColor];
            [self refreshInfoLabel];
        }
    }
    CGRect frame = view.frame;
    frame.size.height = ((infoArray.count - 1) / column + 1)* (bHeight + v_space) - v_space;;
    view.frame = frame;
}
- (void)refreshSubView_2
{
    [_subView_2.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createButtonsView:_subView_2 info:_monthInfoArray type:2];
}
- (void)refreshSubView_3
{
    [_subView_3.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *infoArray = [self refreshWeekInfoArray];

    [self createButtonsView:_subView_3 info:infoArray type:3];
}
- (void)buttonClicked:(UIButton *)button
{
    NSInteger type = button.tag / 1000;
    NSInteger i = button.tag % 1000;
    if (type == 1) {
        _year = [_yearInfoArray[i] integerValue];
        [self refreshSubView_3];
        [self refreshSubView_2];
        _month = 0;
        _week = 0;
    }
    if (type == 2) {
        _month = i;
        _week = 0;
        [self refreshSubView_3];
    }
    if (type == 3) {
        _week = i;
    }
    
    NSArray *btnArray = button.superview.subviews;
    for (UIButton *btn in btnArray) {
        if (button == btn) {
            btn.layer.borderColor = [COLOR_3 CGColor];
            btn.selected = YES;
        }else{
            btn.layer.borderColor = [COLOR_2 CGColor];
            btn.selected = NO;
        }
    }
    [self refreshInfoLabel];
}
- (void)refreshInfoLabel
{
    if (_week > 0) {
        NSDate *firstDate = _weekInfoArray[_week - 1][@"start"];
        NSDate *endDate = _weekInfoArray[_week - 1][@"end"];
        _searchInfoLabel.text = [NSString stringWithFormat:@"%@-%@",[firstDate formattedDateType:1],[endDate formattedDateType:1]];
    }else if(_month > 0){
       NSInteger days = [[SCCalendarManager defaultManager]daysForMonth:_month byYear:_year];
        NSString *str = [NSString stringWithFormat:@"%@-%@",[SCCalendarManager stringForDateFormateWithDay:01 month:_month byYear:_year],[SCCalendarManager stringForDateFormateWithDay:days month:_month byYear:_year]];
        _searchInfoLabel.text = str;
    }else{
        NSInteger days = [[SCCalendarManager defaultManager]daysForMonth:12 byYear:_year];
        NSString *str = [NSString stringWithFormat:@"%@-%@",[SCCalendarManager stringForDateFormateWithDay:1 month:1 byYear:_year],[SCCalendarManager stringForDateFormateWithDay:days month:12 byYear:_year]];
        _searchInfoLabel.text = str;
    }
}
- (void)blankTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(cancelPowerSearchView)]) {
        [_delegate cancelPowerSearchView];
    }
}
- (void)sureButtonClicked:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(powerSearchView:selectedInfo:)]) {
        
        NSInteger weekValue = -1;
        NSInteger weekValue_m = -1;
        if (_week > 0) {
            NSDate *firstDate = _weekInfoArray[_week - 1][@"start"];
            NSDateComponents *comp = [[SCCalendarManager defaultManager] dateComponentsWithDate:firstDate];
            weekValue = comp.weekOfYear;
            weekValue_m = comp.weekOfMonth;
        }
        NSDictionary *dict = @{@"year" : @(_year),
                               @"month" : @(_month),
                               @"week_y" : @(weekValue + 1),
                               @"week_m" : @(weekValue_m + 1)};
        [_delegate powerSearchView:self selectedInfo:dict];
    }
}
@end
