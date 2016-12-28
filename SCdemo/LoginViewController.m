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

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *fingerprintBtn;
@property (nonatomic, strong) UILabel *fingerprintLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupUI];
    [self checkUserInfo];
}

- (void)checkUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults dictionaryForKey:@"user"];
    if (dic) {
        _userNameField.text = dic[@"username"];
//        if (dic[@"password"]) {
//            _passwordField.text = dic[@"password"];
//        }
    }
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
        textField.delegate = self;
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
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"password"] && [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        self.fingerprintBtn = ({
            UIButton *fingerprintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [fingerprintBtn addTarget:self action:@selector(touchIDauthenticate) forControlEvents:UIControlEventTouchUpInside];
            [fingerprintBtn setBackgroundImage:[UIImage imageNamed:@"指纹"] forState:UIControlStateNormal];
            [self.view addSubview:fingerprintBtn];
            [fingerprintBtn makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(35);
                make.centerX.equalTo(self.view);
                make.width.height.equalTo(100);
            }];
            
            fingerprintBtn;
        });
        
        self.fingerprintLabel = ({
            UILabel *fingerprintLabel = [[UILabel alloc] init];
            fingerprintLabel.textAlignment = NSTextAlignmentCenter;
            fingerprintLabel.text = NSLocalizedString(@"fingerprint", nil);
            fingerprintLabel.textColor = [UIColor whiteColor];
            [self.view addSubview:fingerprintLabel];
            [fingerprintLabel makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.fingerprintBtn.top);
                make.centerX.equalTo(self.view);
                make.width.equalTo(100);
                make.height.equalTo(30);
            }];
            
            fingerprintLabel;
        });
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *currentUserName = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"username"];
    if (self.fingerprintBtn && self.fingerprintLabel) {
        if ([textField.text isEqualToString:currentUserName]) {
            self.fingerprintBtn.hidden = NO;
            self.fingerprintLabel.hidden = NO;
        } else {
            self.fingerprintBtn.hidden = YES;
            self.fingerprintLabel.hidden = YES;
        }
    }
}

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
    [self loginWithUserName:self.userNameField.text password:self.passwordField.text];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    if (!userName || [userName isEqualToString:@""]) {
        [self showAlertWithTitle:NSLocalizedString(@"Message", nil) msg:NSLocalizedString(@"The username is empty!", nil)];
        return;
    }
    if (!password || [password isEqualToString:@""]) {
        [self showAlertWithTitle:NSLocalizedString(@"Message", nil) msg:NSLocalizedString(@"The password is empty!", nil)];
        return;
    }
    [self login433WithUserName:userName password:password];
}

- (void)login433WithUserName:(NSString *)userName password:(NSString *)password
{
    __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
         hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    hud.mode = MBProgressHUDModeIndeterminate;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *paras = @{@"userName" : userName , @"password" : password};
    [manager POST:@"http://120.77.13.77:8080/AppInterface/appLogin" parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSLog(@"%@",responseDic);
        if ([(NSNumber *)responseDic[@"Result"] intValue] == 1) {
            NSString *token = [responseDic[@"Msg"] componentsSeparatedByString:@","][0];
            NSString *gatewayId = [responseDic[@"Msg"] componentsSeparatedByString:@","][1];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic;
            dic = @{
                    @"token" : token,
                    @"gatewayid" : gatewayId,
                    @"username" : userName,
                    @"password" : password};
            [defaults setObject:dic forKey:@"user"];
            [defaults synchronize];
            
            [self RCIMregisterWithUserName:userName password:password];
            
        } else {
            [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
            [self showAlertWithTitle:NSLocalizedString(@"Fail to log in", nil) msg:responseDic[@"Msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
        [self showAlertWithTitle:NSLocalizedString(@"Fail to log in", nil) msg:nil];
    }];
}

- (void)forgetPasswordClick:(UIButton *)sender
{
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchIDauthenticate
{
    __weak typeof(self) weakSelf = self;
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"verification" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [weakSelf loginWithUserName:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"username"] password:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"password"]];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"error:%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
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
