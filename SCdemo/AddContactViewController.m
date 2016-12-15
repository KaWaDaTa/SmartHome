//
//  AddContactViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "AddContactViewController.h"
#import "AddContactTableViewCell.h"

@interface AddContactViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *table;
@end

@implementation AddContactViewController
{
    NSArray *_icons;
    NSArray *_titles;
    NSArray *_subtitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _icons = @[@"二维码",@"添加新朋友",@"建立群聊"];
    _titles = @[NSLocalizedString(@"Scan QR code", nil),NSLocalizedString(@"Mobile contacts", nil),NSLocalizedString(@"Join private group", nil)];
    _subtitles = @[NSLocalizedString(@"Scan contact's QR code", nil),NSLocalizedString(@"Add from phone", nil),NSLocalizedString(@"Join a group with friends nearby", nil)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Add contacts", nil);
    self.tabBarController.tabBar.hidden = YES;
    
    UIButton *QRCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [QRCode addTarget:self action:@selector(myQRCode:) forControlEvents:UIControlEventTouchUpInside];
    QRCode.bounds = CGRectMake(0, 0, 20, 20);
    [QRCode setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    UIBarButtonItem *QRItem = [[UIBarButtonItem alloc] initWithCustomView:QRCode];
    self.navigationItem.rightBarButtonItem = QRItem;
    
    [self setupUI];
}

- (void)setupUI
{
    self.searchField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"ID/Phone", nil);
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"搜索"];
        leftView.bounds = CGRectMake(0, 0, 20, 20);
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(75);
            make.height.equalTo(40);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.width.equalTo(textField);
            make.height.equalTo(1);
            make.top.equalTo(textField.bottom).offset(-1);
        }];
        
        textField;
    });
    
    self.table = ({
        UITableView *table = [[UITableView alloc] init];
        [table registerClass:[AddContactTableViewCell class] forCellReuseIdentifier:@"AddContactCellId"];
        table.tableFooterView = [UIView new];
        table.tableHeaderView = [UIView new];
        table.scrollEnabled = NO;
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        [table makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.searchField.bottom).offset(30);
            make.height.equalTo(kScreenHeight *3 / 8 + 3);
        }];
        
        table;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchField becomeFirstResponder];
}

- (void)myQRCode:(UIButton *)sender
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AddContactCellId";
    AddContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.iconImgView.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.titleLabel.text = _titles[indexPath.row];
    cell.subtitleLabel.text = _subtitles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"AddContactCellId" configuration:^(AddContactTableViewCell *cell) {
        cell.iconImgView.image = [UIImage imageNamed:_icons[indexPath.row]];
        cell.titleLabel.text = _titles[indexPath.row];
        cell.subtitleLabel.text = _subtitles[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
