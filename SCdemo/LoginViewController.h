//
//  LoginViewController.h
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginTextField.h"
#import "RegisterViewController.h"
#import "ViewController.h"

@interface LoginViewController : UIViewController

@property (nonatomic, strong) LoginTextField *userNameField;
@property (nonatomic, strong) LoginTextField *passwordField;

@end
