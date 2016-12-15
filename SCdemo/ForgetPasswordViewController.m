//
//  ForgetPasswordViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/8.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginTextField.h"

@interface ForgetPasswordViewController ()
@property (nonatomic, copy) NSMutableArray *labels;
@property (nonatomic, strong) LoginTextField *phoneField;
@property (nonatomic, strong) LoginTextField *verifyField;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Find the password", nil);
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#00c8e3"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00c8e3"]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupUI
{
    NSArray *labelTitles = @[NSLocalizedString(@"Input phone number", nil),NSLocalizedString(@"Verify", nil),NSLocalizedString(@"Set new password", nil)];
    _labels = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3 ; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.text = labelTitles[i];
        label.textColor = [UIColor lightGrayColor];
        [self.view addSubview:label];
        [_labels addObject:label];
    }
    [_labels mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [_labels makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(80);
        make.height.equalTo(30);
    }];
    
    UIView *circle0 = [[UIView alloc] init];
    circle0.layer.cornerRadius = 5;
    circle0.layer.masksToBounds = YES;
    circle0.layer.borderColor = [UIColor colorWithHexString:@"#00c8e3"].CGColor;
    circle0.layer.borderWidth = 2;
    [self.view addSubview:circle0];
    [circle0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_labels[0]);
        make.top.equalTo(((UILabel *)_labels[0]).bottom);
        make.width.height.equalTo(10);
    }];
    
    UIView *circle1 = [[UIView alloc] init];
    circle1.layer.cornerRadius = 5;
    circle1.layer.masksToBounds = YES;
    circle1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    circle1.layer.borderWidth = 2;
    [self.view addSubview:circle1];
    [circle1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_labels[1]);
        make.top.equalTo(((UILabel *)_labels[1]).bottom);
        make.width.height.equalTo(10);
    }];
    
    UIView *circle2 = [[UIView alloc] init];
    circle2.layer.cornerRadius = 5;
    circle2.layer.masksToBounds = YES;
    circle2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    circle2.layer.borderWidth = 2;
    [self.view addSubview:circle2];
    [circle2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_labels[2]);
        make.top.equalTo(((UILabel *)_labels[2]).bottom);
        make.width.height.equalTo(10);
    }];
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(2);
        make.centerY.equalTo(circle0);
        make.left.equalTo(circle0.right);
        make.right.equalTo(circle1.left);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(2);
        make.centerY.equalTo(circle0);
        make.left.equalTo(circle1.right);
        make.right.equalTo(circle2.left);
    }];
    
    self.phoneField = ({
        LoginTextField *field = [[LoginTextField alloc] init];
        [field setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Input phone number you register", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        field.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
        [self.view addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(line0).offset(50);
            make.height.equalTo(50);
        }];
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(clearPhone:) forControlEvents:UIControlEventTouchUpInside];
        [rightView setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        field.rightView = rightView;
        field.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        field;
    });
    
    self.verifyField = ({
        LoginTextField *field = [[LoginTextField alloc] init];
        [field setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Input verification code", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        field.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
        [self.view addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.width.equalTo(kScreenWidth * 2 / 3);
            make.top.equalTo(self.phoneField.bottom).offset(5);
            make.height.equalTo(50);
        }];
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(clearVerification:) forControlEvents:UIControlEventTouchUpInside];
        [rightView setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        rightView.bounds = CGRectMake(0, 0, 40, 40);
        field.rightView = rightView;
        field.rightViewMode = UITextFieldViewModeAlways;
        rightView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        field;
    });
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    [self.view addSubview:container];
    [container makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyField.right);
        make.top.equalTo(self.verifyField);
        make.bottom.equalTo(self.verifyField);
        make.width.equalTo(kScreenWidth / 3);
    }];
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.layer.cornerRadius = 25;
    verifyBtn.layer.masksToBounds = YES;
    verifyBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    [verifyBtn setTitle:NSLocalizedString(@"Verify", nil) forState:UIControlStateNormal];
    [self.view addSubview:verifyBtn];
    [verifyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verifyField.bottom).offset(80);
        make.height.equalTo(50);
        make.width.equalTo(200);
    }];
}

- (void)clearPhone:(UIButton *)sender
{
    self.phoneField.text = @"";
}

- (void)clearVerification:(UIButton *)sender
{
    self.verifyField.text = @"";
}

@end
