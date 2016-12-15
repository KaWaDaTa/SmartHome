//
//  WelcomeViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/8.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PerfectInfoViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI
{
    UIButton *perfectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [perfectBtn setTitle:NSLocalizedString(@"Perfect information", nil) forState:UIControlStateNormal];
    [perfectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [perfectBtn addTarget:self action:@selector(perfectInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:perfectBtn];
    [perfectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
}

- (void)perfectInfoClick:(UIButton *)sender
{
    PerfectInfoViewController *vc = [[PerfectInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
