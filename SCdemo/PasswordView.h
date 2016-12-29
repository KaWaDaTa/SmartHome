//
//  PasswordView.h
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordView;

@protocol PasswordViewDelegate <NSObject>

- (void)passwordView:(PasswordView *)passwordView dismissByCancelled:(BOOL)isCancelled;

@end

@interface PasswordView : UIView

@property (nonatomic, strong, readonly) UIColor *displayColor;
@property (nonatomic, copy, readonly) NSMutableString *currentValue;
@property (nonatomic, weak) id<PasswordViewDelegate> delegate;
+ (instancetype)showWithColor:(UIColor *)color;
+ (void)dismiss;
@end
