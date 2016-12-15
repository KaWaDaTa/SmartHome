//
//  GroupManagerViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "GroupManagerViewController.h"
#import "HomeDataSourceManager.h"

@interface GroupManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GroupManagerViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        _dataSource = [HomeDataSourceManager sharedInstance].dataSource;
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupUI];
    [self setEditing:YES animated:YES];
}

- (void)setupUI
{
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.layer.borderColor = [UIColor colorWithHexString:@"#00c8e3"].CGColor;
    add.layer.borderWidth = 1;
    [add addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [add setTitle:NSLocalizedString(@"Add Group", nil) forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:add];
    [add makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.bottom.equalTo(self.tableView.top).offset(-10);
        make.width.equalTo(100);
        make.top.equalTo(10);
    }];
}

- (void)addBtnClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    TBAlertController *alert = [TBAlertController alertControllerWithTitle:NSLocalizedString(@"Add Group", nil) message:NSLocalizedString(@"Input name for new group", nil) preferredStyle:TBAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:[TBAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:TBAlertActionStyleCancel handler:nil]];
    [alert addAction:[TBAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        HomeSectionModel *model = [[HomeSectionModel alloc] initWithSectionTitle:alert.textFields[0].text isExpanded:NO models:nil];
        [weakSelf.dataSource addObject:model];
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView endUpdates];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing == NO) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self.tableView setEditing:editing animated:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    cell.textLabel.text = [self.dataSource[indexPath.row] sectionTitle];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    HomeSectionModel *model = self.dataSource[fromIndexPath.row];
    [self.dataSource removeObjectAtIndex:fromIndexPath.row];
    [self.dataSource insertObject:model atIndex:toIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
