//
//  SecurityViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/6.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "SecurityViewController.h"
#import "LeftImageButton.h"
#import "SecuritySettingViewController.h"

@interface SecurityViewController ()

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setupUI
{
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.layer.cornerRadius = 15;
    voice.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:voice];
    [voice makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30);
        make.left.equalTo(10);
        make.top.equalTo(25);
    }];
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    [setting addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    setting.layer.cornerRadius = 15;
    setting.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:setting];
    [setting makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30);
        make.right.equalTo(-10);
        make.top.equalTo(25);
    }];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.text = NSLocalizedString(@"Will", nil);
    label0.font = [UIFont systemFontOfSize:35];
    [self.view addSubview:label0];
    [label0 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(100);
        make.height.equalTo(40);
        make.right.equalTo(-10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = NSLocalizedString(@"Do you ready to arm?", nil);
    [self.view addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(label0.bottom);
        make.height.equalTo(40);
        make.right.equalTo(-10);
    }];
    
    LeftImageButton *silentBtn = [LeftImageButton buttonWithType:UIButtonTypeCustom];
    silentBtn.layer.borderColor = [UIColor colorWithHexString:@"#00c8e3"].CGColor;
    silentBtn.layer.borderWidth = 2;
    [silentBtn setTitleColor:[UIColor colorWithHexString:@"#00c8e3"] forState:UIControlStateNormal];
    [silentBtn setBackgroundColor:[UIColor whiteColor]];
    //    [awayBtn setImage:[UIImage imageNamed:@"away.jpg"] forState:UIControlStateNormal];
    [silentBtn setTitle:NSLocalizedString(@"Silent", nil) forState:UIControlStateNormal];
    [self.view addSubview:silentBtn];
    [silentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(-60);
        make.height.equalTo(100);
    }];
    
    LeftImageButton *stayBtn = [LeftImageButton buttonWithType:UIButtonTypeCustom];
    [stayBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffc658"]];
    //    [awayBtn setImage:[UIImage imageNamed:@"away.jpg"] forState:UIControlStateNormal];
    [stayBtn setTitle:NSLocalizedString(@"Stay", nil) forState:UIControlStateNormal];
    [self.view addSubview:stayBtn];
    [stayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(silentBtn.top).offset(-15);
        make.height.equalTo(150);
    }];
    
    LeftImageButton *awayBtn = [LeftImageButton buttonWithType:UIButtonTypeCustom];
    [awayBtn setBackgroundColor:[UIColor colorWithHexString:@"#ff5a60"]];
    //    [awayBtn setImage:[UIImage imageNamed:@"away.jpg"] forState:UIControlStateNormal];
    [awayBtn setTitle:NSLocalizedString(@"Away", nil) forState:UIControlStateNormal];
    [self.view addSubview:awayBtn];
    [awayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(stayBtn.top).offset(-10);
        make.height.equalTo(150);
    }];
}

- (void)settingBtnClick:(UIButton *)sender
{
    SecuritySettingViewController *vc = [[SecuritySettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
