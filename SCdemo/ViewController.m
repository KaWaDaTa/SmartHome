//
//  ViewController.m
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ViewController.h"
#import "StretchyHeaderView.h"
#import "HomeSettingsCell.h"
#import "VideoPlayCell.h"
#import "SecurityViewController.h"
#import "HomeComponentModel.h"
#import "OptionSliderModel.h"
#import "HomeDataSourceManager.h"
#import "ZoneViewController.h"

@interface ViewController ()<GSKStretchyHeaderViewStretchDelegate,StretchyHeaderDelegate,UITableViewDelegate,UITableViewDataSource,VideoPlayDelegate>

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) StretchyHeaderView *stretchyHeader;
@property (nonatomic, strong) NSMutableArray<HomeSectionModel *> *dataSource;

@end

@implementation ViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    //去除空的分区
    NSMutableArray *origin = [HomeDataSourceManager sharedInstance].dataSource;
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (HomeSectionModel *model in origin) {
        if (model.models.count != 0) {
            [tmp addObject:model];
        }
    }
    _dataSource = tmp;
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [_table registerClass:[HomeSettingsCell class] forCellReuseIdentifier:@"HomeSettingsCellId"];
    [_table registerClass:[VideoPlayCell class] forCellReuseIdentifier:@"VideoCell"];
    _table.backgroundColor = [UIColor whiteColor];
    _table.separatorColor = [UIColor clearColor];
//    _table.bounces = NO;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    [_table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CGSize headerSize = CGSizeMake(_table.frame.size.width, 436);
    self.stretchyHeader = [[StretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    self.stretchyHeader.stretchDelegate = self;
    self.stretchyHeader.delegate = self;
    [_table addSubview:self.stretchyHeader];
    [_table setContentOffset:CGPointMake(0, -436)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.table reloadData];
}

- (void)tapSecurity
{
    ZoneViewController *vc = [[ZoneViewController alloc] initWithZoneArr:@[@"1",@"00",@"01",@"2",@"01",@"00"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)stretchyHeaderView:(GSKStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor
{
    UIView *info = ((StretchyHeaderView *)headerView).info;
    UILabel *infoLabel = ((StretchyHeaderView *)headerView).infoLabel;
    UIButton *leftBtn = ((StretchyHeaderView *)headerView).leftBtn;
    UILabel *leftLabel = ((StretchyHeaderView *)headerView).leftLabel;
    UIButton *rightBtn = ((StretchyHeaderView *)headerView).rightBtn;
    UILabel *rightLabel = ((StretchyHeaderView *)headerView).rightLabel;
    
    CGFloat factor = stretchFactor / 1;
    info.alpha = factor;
    if (factor == 0) {
//        info.layer.cornerRadius = 0;
//        info.alpha = 1;
//        [info remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@25);
//            make.width.equalTo(@100);
//            make.top.equalTo(headerView.contentView).offset(25);
//            make.right.equalTo(headerView.contentView).offset(-10);
//        }];
        //        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"user" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
        //        self.navigationItem.rightBarButtonItem = item;
    } else {
        //        self.navigationItem.rightBarButtonItem = nil;
        info.alpha = factor;
        infoLabel.alpha = factor;
        leftBtn.alpha = factor;
        leftLabel.alpha = factor;
        rightBtn.alpha = factor;
        rightLabel.alpha = factor;
        
//        info.layer.cornerRadius = 57.5;
//        [info remakeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(headerView.contentView).centerOffset(CGPointMake(0, 35.5));
//            make.width.height.equalTo(@115);
//        }];
    }
    if (factor < 0.95) {
        info.userInteractionEnabled = NO;
    } else {
        info.userInteractionEnabled = YES;
    }
}

- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender
{
    
}

- (void)doubleTapWithVideoPlayView:(VideoPlayerView *)videoPlayView andSuperView:(UIView *)superView
{
    videoPlayView.isFullScreen = !videoPlayView.isFullScreen;
    if (videoPlayView.isFullScreen) {
        self.tabBarController.tabBar.hidden = YES;
        [videoPlayView removeFromSuperview];
        [self.view addSubview:videoPlayView];
        [videoPlayView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        self.tabBarController.tabBar.hidden = NO;
        [videoPlayView removeFromSuperview];
        [superView addSubview:videoPlayView];
        [videoPlayView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 4) {
//        NSString *cellId = @"VideoCell";
//        VideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[VideoPlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        }
//        cell.URL = nil;
//        
//        cell.delegate = self;
////        cell.URL = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2016/222l873ttj77llkzbzs/222/hls_vod_mvp.m3u8"];
//        cell.URL = [NSURL URLWithString:@"http://vmovier.qiniudn.com/559b918dbf717.mp4"];
//        return cell;
//    } else {
        HomeSettingsCell *cell = [[HomeSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeSettingsCellId" andModels:[self.dataSource[indexPath.section] models]];
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 4) {
//        return [tableView fd_heightForCellWithIdentifier:@"VideoCell" configuration:^(id cell) {
//            
//        }];
//    } else {
        return 253;
//    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
        tableViewHeaderFooterView.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        tableViewHeaderFooterView.textLabel.font = [UIFont systemFontOfSize:22];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataSource[section].sectionTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
