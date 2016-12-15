//
//  ChatInfoViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ChatInfoViewController.h"
#import "UserInfoDataSource.h"
#import <UIButton+WebCache.h>

@interface ChatInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) RCConversationType type;
@property (nonatomic, strong) NSString *targetId;
@end

@implementation ChatInfoViewController
{
    NSArray *_titles;
}

- (instancetype)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId
{
    self = [super init];
    if (self) {
        self.type = conversationType;
        self.targetId = targetId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _titles = @[NSLocalizedString(@"Sticky on top", nil),NSLocalizedString(@"Mute notifications", nil),NSLocalizedString(@"Chat files", nil),NSLocalizedString(@"Background", nil),NSLocalizedString(@"Search history", nil),NSLocalizedString(@"Chear chat history", nil),NSLocalizedString(@"Report", nil)];
    
    self.table = ({
        UITableView *table = [[UITableView alloc] init];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, kScreenWidth, 100);
        view.backgroundColor = [UIColor whiteColor];
        table.tableHeaderView = view;
        
        table.tableFooterView = [UIView new];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        [table makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        RCUserInfo *userInfo =  [[UserInfoDataSource sharedInstance] getUserInfoForUserId:self.targetId];
        UIButton *targetUser = [UIButton buttonWithType:UIButtonTypeCustom];
        [targetUser sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] forState:UIControlStateNormal];
        targetUser.layer.cornerRadius = 20;
        targetUser.layer.masksToBounds = YES;
        [view addSubview:targetUser];
        [targetUser makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(40);
            make.centerY.equalTo(view);
            make.left.equalTo(20);
        }];
        
        UILabel *targetName = [[UILabel alloc] init];
        targetName.text = userInfo.name;
        targetName.font = [UIFont systemFontOfSize:10];
        targetName.textColor = [UIColor lightGrayColor];
        [view addSubview:targetName];
        [targetName makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(targetUser);
            make.top.equalTo(targetUser.bottom).offset(5);
            make.bottom.equalTo(view).offset(-10);
        }];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        addBtn.layer.cornerRadius = 20;
        addBtn.layer.masksToBounds = YES;
        [view addSubview:addBtn];
        [addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(40);
            make.centerY.equalTo(view);
            make.left.equalTo(targetUser.right).offset(20);
        }];
        
        table;
    });
}

- (void)stickOnTopSwitch:(UISwitch *)sender
{
    
}

- (void)muteNotificationsSwitch:(UISwitch *)sender
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _titles[indexPath.row];
    if (indexPath.row == 0) {
        UISwitch *switch0 = [[UISwitch alloc] init];
        switch0.onTintColor = [UIColor colorWithHexString:@"#00c8e3"];
        [switch0 addTarget:self action:@selector(stickOnTopSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switch0;
    } else if (indexPath.row == 1) {
        UISwitch *switch1 = [[UISwitch alloc] init];
        [switch1 addTarget:self action:@selector(muteNotificationsSwitch:) forControlEvents:UIControlEventValueChanged];
        switch1.onTintColor = [UIColor colorWithHexString:@"#00c8e3"];
        cell.accessoryView = switch1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
