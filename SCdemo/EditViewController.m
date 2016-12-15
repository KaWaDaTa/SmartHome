//
//  EditViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "EditViewController.h"
#import "HomeSectionModel.h"
#import "HeaderView.h"
#import "HomeDataSourceManager.h"
#import "AddDeviceViewController.h"
#import "GroupManagerViewController.h"

static NSString *kCellIdentifier = @"UITableViewCell";
static NSString *kHeaderIdentifier = @"HeaderView";

@interface EditViewController ()<TBActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *sectionDataSources;
@property (nonatomic, strong) TBActionSheet *sheet;

@end

@implementation EditViewController

- (NSMutableArray *)sectionDataSources
{
    if (_sectionDataSources == nil) {
        _sectionDataSources = [[NSMutableArray alloc] init];
    }
    _sectionDataSources = [HomeDataSourceManager sharedInstance].dataSource;
    return _sectionDataSources;
}

- (TBActionSheet *)sheet
{
    if (!_sheet) {
        _sheet = [[TBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"grouping management", nil), nil];
        _sheet.ambientColor = [UIColor colorWithHexString:@"#00c8e3"];
        _sheet.cancelButtonColor = [UIColor whiteColor];
        _sheet.tintColor = [UIColor whiteColor];
    }
    return _sheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.view.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[self ImageFromColor:[UIColor colorWithHexString:@"#00c8e3"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self setEditing:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)add
{
    AddDeviceViewController *vc = [[AddDeviceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        GroupManagerViewController *vc = [[GroupManagerViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
        [navc.navigationBar setBackgroundImage:[self ImageFromColor:[UIColor colorWithHexString:@"#00c8e3"]] forBarMetrics:UIBarMetricsDefault];
        navc.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:navc animated:YES completion:nil];
    }
}

- (UIImage *)ImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 100, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HomeSectionModel *sectionModel = self.sectionDataSources[section];
    return sectionModel.isExpanded ? sectionModel.models.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    // Configure the cell...
    HomeSectionModel *sectionModel = self.sectionDataSources[indexPath.section];
    HomeSettingModel *cellModel = sectionModel.models[indexPath.row];
    cell.textLabel.text = cellModel.title;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
    
    HomeSectionModel *sectionModel = self.sectionDataSources[section];
    view.model = sectionModel;
    view.expandCallback = ^(BOOL isExpanded) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                 withRowAnimation:UITableViewRowAnimationFade];
    };
    view.longpressCallback = ^(UILongPressGestureRecognizer *sender) {
        if (sender.state != UIGestureRecognizerStateBegan) {
            return;
        }
        [self.sheet show];
    };
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
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
        [[self.sectionDataSources[indexPath.section] models] removeObjectAtIndex:indexPath.row];
        if ([self.sectionDataSources[indexPath.section] models].count == 0) {
            [self.sectionDataSources removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    HomeSettingModel *model = [self.sectionDataSources[fromIndexPath.section] models][fromIndexPath.row];
    [[self.sectionDataSources[fromIndexPath.section] models] removeObjectAtIndex:fromIndexPath.row];
    [[self.sectionDataSources[toIndexPath.section] models] insertObject:model atIndex:toIndexPath.row];
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
