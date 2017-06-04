//
//  ViewController.m
//  LDYCalendarDemo
//
//  Created by yang on 2017/6/4.
//  Copyright © 2017年 com.tixa.SealChat. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+LDYCategory.h"
#import "SCPowerSearchView.h"

@interface ViewController ()<SCPowerSearchViewDelegate>
@property (nonatomic, strong) SCPowerSearchView *powerSearchView;
@property (nonatomic, strong) UILabel           *showLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createStartButton];
    [self createShowLabel];
    [self createPowerSearchView];
}
- (void)createStartButton
{
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 50.0f) / 2.0, CGRectGetHeight(self.view.frame) / 2.0 - 100.0f, 50.0f, 30.0f)];
    startButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [startButton setTitle:@"start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startButton.layer.cornerRadius = 3.0f;
    startButton.layer.borderColor = [[UIColor grayColor] CGColor];
    startButton.layer.borderWidth = 1.0f;
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}
- (void)start:(UIButton *)button
{
    [self createPowerSearchView];
}
- (void)createShowLabel
{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) / 2.0, CGRectGetWidth(self.view.frame), 100.0)];
        _showLabel.textColor = [UIColor blueColor];
        _showLabel.font = [UIFont systemFontOfSize:15.0f];
        _showLabel.numberOfLines = 0;
        _showLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_showLabel];
    }
}
- (void)createPowerSearchView
{
    if (!_powerSearchView) {
        _powerSearchView = [SCPowerSearchView createPowerSearchView];
        _powerSearchView.delegate = self;
    }
    [self.view addSubview:_powerSearchView];
}
- (void)removePowerSearchView
{
    if (_powerSearchView) {
        [_powerSearchView removeFromSuperview];
        _powerSearchView = nil;
    }
}
- (void)powerSearchView:(SCPowerSearchView *)powerSearchView selectedInfo:(NSDictionary *)infoDict
{
    NSNumber *year = infoDict[@"year"];
    NSNumber *month = infoDict[@"month"];
    NSNumber *week_y = infoDict[@"week_y"];
    NSNumber *week_m = infoDict[@"week_m"];
    
    NSMutableString *resultStr = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@年\n",year]];
    if ([month integerValue] > 0) {
        [resultStr appendString:[NSString stringWithFormat:@"%@月\n",month]];
    }
    if ([week_y integerValue] > 0) {
        [resultStr appendString:[NSString stringWithFormat:@"当年的第%@周\n",week_y]];
    }
    if ([week_m integerValue] > 0) {
        [resultStr appendString:[NSString stringWithFormat:@"当月的第%@周\n",week_m]];
    }
    _showLabel.text = resultStr;
    
    [self cancelPowerSearchView];
}
- (void)cancelPowerSearchView
{
    [self removePowerSearchView];
}
@end
