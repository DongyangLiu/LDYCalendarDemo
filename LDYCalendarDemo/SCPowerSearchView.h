//
//  SCPowerSearchView.h
//  SealChat
//
//  Created by yang on 2017/5/19.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCPowerSearchView;
@protocol SCPowerSearchViewDelegate <NSObject>

- (void)cancelPowerSearchView;

- (void)powerSearchView:(SCPowerSearchView *)powerSearchView selectedInfo:(NSDictionary *)infoDict;

@end
@interface SCPowerSearchView : UIView
@property (nonatomic, weak) id <SCPowerSearchViewDelegate> delegate;

+ (instancetype)createPowerSearchView;
@end
