//
//  AddDeviceViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *indexPaths;
@end

@implementation AddDeviceViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(50, 0, 50, 0));
        }];
    }
    return _tableView;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
        _titles = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"TV", nil),NSLocalizedString(@"Fridge", nil),NSLocalizedString(@"Light", nil),NSLocalizedString(@"Socket", nil),NSLocalizedString(@"Blinds", nil),NSLocalizedString(@"Door", nil),NSLocalizedString(@"Air condition", nil),NSLocalizedString(@"Air purifier", nil),NSLocalizedString(@"Fan", nil),]];
    }
    return _titles;
}

- (NSMutableArray<NSIndexPath *> *)indexPaths
{
    if (!_indexPaths) {
        _indexPaths = [[NSMutableArray alloc] init];
    }
    return _indexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Add devices", nil);
    [self setupUI];
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"Option one to two devices", nil);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    UIButton *determine = [UIButton buttonWithType:UIButtonTypeCustom];
    [determine addTarget:self action:@selector(determineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [determine setBackgroundColor:[UIColor colorWithHexString:@"#00c8e3"]];
    [determine setTitle:NSLocalizedString(@"Determine", nil) forState:UIControlStateNormal];
    [self.view addSubview:determine];
    [determine makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.tableView.bottom);
    }];
}

- (void)determineBtnClick:(UIButton *)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Function not yet implemented!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone && self.indexPaths.count < 2) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.indexPaths addObject:indexPath];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.indexPaths removeObject:indexPath];
    }
    
}

@end
