//
//  ZoneViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/19.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ZoneViewController.h"
#import "ZoneTableViewCell.h"

@interface ZoneViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZoneViewController

- (NSArray *)zoneArr
{
    if (!_zoneArr) {
        _zoneArr = [[NSMutableArray alloc] init];
    }
    return _zoneArr;
}

- (instancetype)initWithZoneArr:(NSArray *)zoneArr
{
    self = [super init];
    if (self) {
        self.zoneArr = zoneArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table = ({
        UITableView *table = [[UITableView alloc] init];
        [table registerClass:[ZoneTableViewCell class] forCellReuseIdentifier:@"ZoneCellId"];
        table.backgroundColor = [UIColor clearColor];
        table.tableFooterView = [UIView new];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        [table makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        table;
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#00c8e3"];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.zoneArr.count / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZoneCellId";
    ZoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ZoneTableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.image.image = [UIImage imageNamed:@"Red bee APP iCon-60"];
    NSString *zoneIdstr = self.zoneArr[indexPath.row * 3];
    cell.zoneId.text = [NSString stringWithFormat:@"id:%@",zoneIdstr];
    NSString *statusStr = self.zoneArr[indexPath.row * 3 + 1];
    if ([statusStr isEqualToString:@"00"]) {
        cell.status.text = NSLocalizedString(@"close", nil);
    } else if ([statusStr isEqualToString:@"01"]) {
        cell.status.text = NSLocalizedString(@"open", nil);
    }
    NSString *alarmStatusStr = self.zoneArr[indexPath.row *3 + 2];
    if ([alarmStatusStr isEqualToString:@"00"]) {
        cell.alarmStatus.text = NSLocalizedString(@"not in alarming", nil);
    } else if ([alarmStatusStr isEqualToString:@"01"]) {
        cell.alarmStatus.text = NSLocalizedString(@"in alarming", nil);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ZoneCellId" configuration:^(id cell) {
        ZoneTableViewCell *mCell = (ZoneTableViewCell *)cell;
        mCell.image.image = [UIImage imageNamed:@"Red bee APP iCon-60"];
        NSString *zoneIdstr = self.zoneArr[indexPath.row * 3];
        mCell.zoneId.text = [NSString stringWithFormat:@"id:%@",zoneIdstr];
        NSString *statusStr = self.zoneArr[indexPath.row * 3 + 1];
        if ([statusStr isEqualToString:@"00"]) {
            mCell.status.text = NSLocalizedString(@"close", nil);
        } else if ([statusStr isEqualToString:@"01"]) {
            mCell.status.text = NSLocalizedString(@"open", nil);
        }
        NSString *alarmStatusStr = self.zoneArr[indexPath.row *3 + 2];
        if ([alarmStatusStr isEqualToString:@"00"]) {
            mCell.alarmStatus.text = NSLocalizedString(@"not in alarming", nil);
        } else if ([alarmStatusStr isEqualToString:@"01"]) {
            mCell.alarmStatus.text = NSLocalizedString(@"in alarming", nil);
        }
    }];
}

@end
