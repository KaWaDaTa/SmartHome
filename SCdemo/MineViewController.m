//
//  MineViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "MineViewController.h"
#import "MineStretchyHeaderView.h"
#import "EditViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MineStretchyHeaderView *stretchyHeader;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation MineViewController

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[NSLocalizedString(@"My Profile", nil),NSLocalizedString(@"Remote access", nil),NSLocalizedString(@"Management", nil),NSLocalizedString(@"Settings", nil)];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    _table.bounces = NO;
    _table.delegate = self;
    _table.dataSource = self;
    
    NSArray *colors = @[[UIColor colorWithHexString:@"#00c8e3"],[UIColor colorWithHexString:@"#ffc658"],[UIColor colorWithHexString:@"#ff5a60"]];
    NSArray *titles = @[NSLocalizedString(@"Edit card", nil),NSLocalizedString(@"Gateway", nil),NSLocalizedString(@"View the event", nil)];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [btn addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.backgroundColor = colors[i];
        [tableHeaderView addSubview:btn];
        [btns addObject:btn];
    }
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
    [btns makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.bottom.equalTo(-5);
    }];
    
    for (NSInteger i = 0; i < btns.count; i++) {
        UIButton *btn = btns[i];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(btn);
            make.bottom.equalTo(btn).offset(-5);
            make.height.equalTo(20);
        }];
    }
    
    _table.tableHeaderView = tableHeaderView;
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [self.view addSubview:_table];
    [_table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CGSize headerSize = CGSizeMake(_table.frame.size.width, 200);
    self.stretchyHeader = [[MineStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [_table addSubview:self.stretchyHeader];
    [_table setContentOffset:CGPointMake(0, -200)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)editButtonClicked:(UIButton *)sender
{
    EditViewController *vc = [[EditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
