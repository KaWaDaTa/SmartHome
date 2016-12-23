//
//  PasswordView.h
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordView : UIView

@property (nonatomic, strong, readonly) UIColor *displayColor;
+ (instancetype)showWithColor:(UIColor *)color;
+ (void)dismiss;
@end
