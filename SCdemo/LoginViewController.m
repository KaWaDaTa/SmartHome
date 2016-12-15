//
//  LoginViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewController+RongCloud.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupUI];
}

- (void)setupUI
{
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    [registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(10);
        make.width.equalTo(100);
        make.height.equalTo(40);
    }];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.textColor = [UIColor whiteColor];
    label0.font = [UIFont systemFontOfSize:35];
    label0.text = NSLocalizedString(@"Hello!", nil);
    [self.view addSubview:label0];
    [label0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(100);
        make.left.equalTo(10);
        make.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = NSLocalizedString(@"Welcome to Redbee", nil);
    [self.view addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label0.bottom);
        make.left.equalTo(10);
        make.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    self.userNameField = ({
        LoginTextField *textField = [[LoginTextField alloc] init];
        textField.layer.cornerRadius = 22;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"please input username", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#00c8e3"]}];
        textField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(230);
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.height.equalTo(45);
        }];
        
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"账号"];
        leftView.bounds = CGRectMake(0, 0, 40, 40);
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        leftView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [rightView setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        
        textField;
    });
    
    self.passwordField = ({
        LoginTextField *textField = [[LoginTextField alloc] init];
        textField.secureTextEntry = YES;
        textField.layer.cornerRadius = 22;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"please input password", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#00c8e3"]}];
        textField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(300);
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.height.equalTo(45);
        }];
        
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"密码"];
        leftView.bounds = CGRectMake(0, 0, 40, 40);
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        leftView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(eye:) forControlEvents:UIControlEventTouchUpInside];
        [rightView setBackgroundImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
        [rightView setBackgroundImage:[UIImage imageNamed:@"眼睛睁开"] forState:UIControlStateSelected];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        
        textField;
    });
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 22;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.bottom).offset(50);
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(45);
    }];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn addTarget:self action:@selector(forgetPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:NSLocalizedString(@"forget password", nil) forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.bottom).offset(10);
        make.left.equalTo(30);
        make.width.equalTo(150);
        make.height.equalTo(30);
    }];
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        UIButton *fingerprintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fingerprintBtn addTarget:self action:@selector(touchIDauthenticate) forControlEvents:UIControlEventTouchUpInside];
        [fingerprintBtn setBackgroundImage:[UIImage imageNamed:@"指纹"] forState:UIControlStateNormal];
        [self.view addSubview:fingerprintBtn];
        [fingerprintBtn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(35);
            make.centerX.equalTo(self.view);
            make.width.height.equalTo(100);
        }];
        
        UILabel *fingerprintLabel = [[UILabel alloc] init];
        fingerprintLabel.textAlignment = NSTextAlignmentCenter;
        fingerprintLabel.text = NSLocalizedString(@"fingerprint", nil);
        fingerprintLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:fingerprintLabel];
        [fingerprintLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(fingerprintBtn.top);
            make.centerX.equalTo(self.view);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
    }
    
}

#pragma buttonActions
- (void)registerBtnClick:(UIButton *)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clear
{
    self.userNameField.text = @"";
}

- (void)eye:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

- (void)loginClick:(UIButton *)sender
{
//    ViewController *vc = [[ViewController alloc] init];
//    vc.tabBarItem.title = @"Home";
//    
//    ChatListViewController *chatVC1 = [[ChatListViewController alloc] init];
//    chatVC1.tabBarItem.title = @"Chat1";
//    chatVC1.view.backgroundColor = [UIColor whiteColor];
//    ChatListViewController *chatVC2 = [[ChatListViewController alloc] init];
//    chatVC2.tabBarItem.title = @"Chat2";
//    chatVC2.view.backgroundColor = [UIColor blueColor];
//    ChatListViewController *chatVC3 = [[ChatListViewController alloc] init];
//    chatVC3.tabBarItem.title = @"Chat3";
//    chatVC3.view.backgroundColor = [UIColor cyanColor];
//    
//    UITabBarController *tabVC = [[UITabBarController alloc] init];
//    tabVC.viewControllers = @[vc,chatVC1,chatVC2,chatVC3];
//    
//    [self.navigationController pushViewController:tabVC animated:YES];
    [self RCIMregister];
}

- (void)forgetPasswordClick:(UIButton *)sender
{
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchIDauthenticate
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"reason" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:[NSString stringWithFormat:@"error:%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"not support" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

@end
