//
//  LoginViewController+RongCloud.h
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (RongCloud)
- (void)RCIMregisterWithUserName:(NSString *)userName password:(NSString *)password;
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;
@end
