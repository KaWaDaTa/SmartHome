//
//  ConnectGateWayViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ConnectGateWayViewController.h"

@interface ConnectGateWayViewController ()

@end

@implementation ConnectGateWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.view.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage ImageFromColor:[UIColor colorWithHexString:@"#00c8e3"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"连接网关英文.jpg"];
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(-30, 0, 0, 0));
    }];
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

@end
