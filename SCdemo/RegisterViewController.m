//
//  RegisterViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginTextField.h"
#import "WelcomeViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) LoginTextField *userNameField;
@property (nonatomic, strong) LoginTextField *passwordField;
@property (nonatomic, strong) UIButton *createBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    
    [self setupUI];
}

- (void)setupUI
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(10);
        make.width.equalTo(100);
        make.height.equalTo(40);
    }];
    
    self.userNameField = ({
        LoginTextField *textField = [[LoginTextField alloc] init];
        textField.layer.cornerRadius = 22;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"please input phone number", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#00c8e3"]}];
        textField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(150);
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.height.equalTo(45);
        }];
        
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [rightView setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        textField;
    });
    
    self.passwordField = ({
        LoginTextField *textField = [[LoginTextField alloc] init];
        textField.secureTextEntry = YES;
        textField.layer.cornerRadius = 22;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"please input password", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#00c8e3"]}];
        textField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameField.bottom).offset(20);
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.height.equalTo(45);
        }];
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(eye:) forControlEvents:UIControlEventTouchUpInside];
        [rightView setBackgroundImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
        [rightView setBackgroundImage:[UIImage imageNamed:@"眼睛睁开"] forState:UIControlStateSelected];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        textField;
    });
    
    UITextField *verifyField = [[UITextField alloc] init];
    verifyField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verifyField];
    [verifyField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.bottom).offset(20);
        make.left.equalTo(30);
        make.width.equalTo(self.passwordField).offset(-150);
        make.height.equalTo(45);
    }];
    
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyButton.backgroundColor = [UIColor whiteColor];
    verifyButton.layer.cornerRadius = 22;
    verifyButton.layer.masksToBounds = YES;
    [verifyButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"get code", nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#00c8e3"]}] forState:UIControlStateNormal];
    [self.view addSubview:verifyButton];
    [verifyButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.bottom).offset(20);
        make.right.equalTo(-30);
        make.width.equalTo(150);
        make.height.equalTo(45);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyField.bottom).offset(-1);
        make.left.equalTo(30);
        make.height.equalTo(1);
        make.width.equalTo(verifyField).offset(22);
    }];
    
    self.createBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 22;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:NSLocalizedString(@"create", nil) forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.bottom).offset(40);
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.height.equalTo(45);
        }];
        
        btn;
    });
    
}

#pragma buttonActions
- (void)loginBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)create:(UIButton *)sender
{
    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    [self.navigationController pushViewController:welcomeVC animated:YES];
}

@end
