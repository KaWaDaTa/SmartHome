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
#import "HomeHeaderView.h"
#import "HomeFooterView.h"

@interface ViewController ()<GSKStretchyHeaderViewStretchDelegate,StretchyHeaderDelegate,UITableViewDelegate,UITableViewDataSource,VideoPlayDelegate,MBProgressHUDDelegate>

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) StretchyHeaderView *stretchyHeader;
@property (nonatomic, strong) NSMutableArray<HomeSectionModel *> *dataSource;
@property (nonatomic, copy) NSArray *zoneArr;//zone信息数组
@property (nonatomic, retain) NSTimer *timer;//获取Panel信息的Timer
@property (nonatomic, retain) NSTimer *onlineTimer;//检测在线状态的Timer
@property (nonatomic, copy) NSString *in_alarm;
@property (nonatomic, copy) NSString *alarm_level;//报警状态
@property (nonatomic, copy) NSString *onlineState;//在线状态

@property (nonatomic, strong) MBProgressHUD *mHUD;//setArm是否成功time out HUD
@property (nonatomic, assign) BOOL succeed;//setArm是否成功，time out 10s

@property (nonatomic, strong) ZoneViewController *zoneVC;

@end

@implementation ViewController {
//    dispatch_source_t _countdownTimer;
}

- (NSMutableArray *)dataSource {
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

- (void)setZoneArr:(NSArray *)zoneArr {
    if (_zoneArr != zoneArr) {
        _zoneArr = zoneArr;
        self.zoneVC.zoneArr = zoneArr;
        [self.zoneVC.table reloadData];
    }
}

//- (void)setIn_alarm:(NSString *)in_alarm
//{
//    if (_in_alarm != in_alarm) {
//        _in_alarm = [in_alarm copy];
//        if ([_in_alarm isEqualToString:@"00"]) {
//            _in_alarm_label.text = NSLocalizedString(@"not in alarming", nil);
//        } else if ([_in_alarm isEqualToString:@"01"]) {
//            _in_alarm_label.text = NSLocalizedString(@"in alarming", nil);
//        }
//    }
//}

- (void)setOnlineState:(NSString *)onlineState {
    if (_onlineState != onlineState) {
        _onlineState = [onlineState copy];
        if ([_onlineState isEqualToString:@"online"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"panel online", nil);
            [hud hideAnimated:YES afterDelay:1];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"panel offline", nil);
            [hud hideAnimated:YES afterDelay:1];
        }
    }
}

- (void)setAlarm_level:(NSString *)alarm_level {
    if (_alarm_level != alarm_level) {
        self.succeed = YES;
        if (self.mHUD) {//收到反馈,设置成功
            [self.mHUD hideAnimated:YES];
            self.mHUD = nil;
        }
        _alarm_level = [alarm_level copy];
        if ([_alarm_level isEqualToString:@"01"]) {
            [self.stretchyHeader setCurrentArmStyle:ArmStyleDisarmed];
        } else if ([_alarm_level isEqualToString:@"02"]) {
            [self.stretchyHeader setCurrentArmStyle:ArmStyleStay];
        } else if ([_alarm_level isEqualToString:@"04"]) {
            [self.stretchyHeader setCurrentArmStyle:ArmStyleAway];
        }
    }
}

//time out HUD隐藏,如果是10s计时自动隐藏，说明time out,如果是我们强制隐藏的,说明成功
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (!self.succeed) {//10s还没有收到反馈
        MBProgressHUD *mhud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mhud.mode = MBProgressHUDModeText;
        mhud.label.text = NSLocalizedString(@"Time out!", nil);
        [mhud hideAnimated:YES afterDelay:1];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.onlineState = @"offline";
    
    _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(requestInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    _onlineTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(checkPanelOnline) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_onlineTimer forMode:NSDefaultRunLoopMode];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [_table registerClass:[HomeSettingsCell class] forCellReuseIdentifier:@"HomeSettingsCellId"];
    [_table registerClass:[VideoPlayCell class] forCellReuseIdentifier:@"VideoCell"];
    _table.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    _table.separatorColor = [UIColor colorWithHexString:@"#f6f6f6"];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    [_table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CGSize headerSize = CGSizeMake(_table.frame.size.width, 336);
    self.stretchyHeader = [[StretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    self.stretchyHeader.stretchDelegate = self;
    self.stretchyHeader.delegate = self;
    [_table addSubview:self.stretchyHeader];
    [_table setContentOffset:CGPointMake(0, -336)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.table reloadData];
    [_timer setFireDate:[NSDate distantPast]];
    [_onlineTimer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [_timer setFireDate:[NSDate distantFuture]];
//    [_onlineTimer setFireDate:[NSDate distantFuture]];
}

-(UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UIViewController *vc = ((UINavigationController *)viewController).viewControllers[0];
    if ([vc isKindOfClass:[self class]]) {
        [_timer setFireDate:[NSDate distantPast]];
        [_onlineTimer setFireDate:[NSDate distantPast]];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        [_onlineTimer setFireDate:[NSDate distantFuture]];
    }
}

/*
//尚未使用倒计时
-(void)openCountdown {
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_countdownTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_countdownTimer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_countdownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                // %.2d seconds
            });
            time--;
        }
    });
    dispatch_resume(_countdownTimer);
}

- (void)closeCountdown {
    dispatch_source_cancel(_countdownTimer);
}
*/
//点击Zone信息
- (void)tapSecurity {
    if (![self.onlineState isEqualToString:@"online"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"panel offline", nil);
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    if (self.zoneArr) {
        if (!self.zoneVC) {
            self.zoneVC = ({
                ZoneViewController *vc = [[ZoneViewController alloc] initWithZoneArr:self.zoneArr];
                
                vc;
            });
        }
        
        [self.navigationController pushViewController:self.zoneVC animated:YES];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"Zone is empty!", nil);
        [hud hideAnimated:YES afterDelay:1];
    }
}

//设置报警状态
- (void)tapSetArm:(UIButton *)sender {
    self.succeed = NO;
    if (![self.onlineState isEqualToString:@"online"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"panel offline", nil);
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    if ((sender.tag == ArmStyleStay && [_alarm_level isEqualToString:@"04"]) || (sender.tag == ArmStyleAway && [_alarm_level isEqualToString:@"02"])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"you have to disarm first", nil);
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    sender.enabled = NO;
    NSString *url = @"";
    switch (sender.tag) {
        case ArmStyleStay:
            url = @"http://120.77.13.77:8080/AppInterface/appStayGateway";
            break;
        case ArmStyleAway:
            url = @"http://120.77.13.77:8080/AppInterface/appAwayGateway";
            break;
        case ArmStyleDisarmed:
            url = @"http://120.77.13.77:8080/AppInterface/appDisarmGateway";
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *token = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"] objectForKey:@"token"];
    NSString *gatewayId = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"] objectForKey:@"gatewayid"];
    NSDictionary *paras = @{
                            @"gatewayId" : gatewayId,
                            @"access_token" : token
                            };
    [manager POST:url parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sender.enabled = YES;
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSLog(@"alarm response:%@",responseDic);
        if ([(NSNumber *)responseDic[@"Result"] integerValue] == 1) {//设置成功但还需要接收到反馈，time out 10s
            self.mHUD = ({
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.delegate = self;
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = NSLocalizedString(@"Setting up...", nil);
                [hud hideAnimated:YES afterDelay:10];
                
                hud;
            });
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"Fail", nil);
            hud.detailsLabel.text = responseDic[@"Msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sender.enabled = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"Fail", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

//检查Panel在线状态
- (void)checkPanelOnline {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paras = @{
                            @"gatewayId" : [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"gatewayid"],
                            @"access_token" : [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"][@"token"]
                            };
    [manager GET:@"http://120.77.13.77:8080/AppInterface/appCheckPanelState" parameters:paras progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"onlineState:%@",responseObject);
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([(NSNumber *)responseDic[@"Result"] integerValue] == 1) {
            NSString *msg = responseDic[@"Msg"];
            if ([msg isEqualToString:@"0"]) {
                self.onlineState = @"offline";
            } else if ([msg isEqualToString:@"1"]) {
                self.onlineState = @"connecting";
            } else if ([msg isEqualToString:@"2"]) {
                self.onlineState = @"online";
            }
        } else {
            self.onlineState = @"invalid";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.onlineState = @"invalid";
    }];
}

//获取panel信息，处于什么报警状态
- (void)requestInfo {
    if (![self.onlineState isEqualToString:@"online"]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *token = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"] objectForKey:@"token"];
    NSString *gatewayId = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"] objectForKey:@"gatewayid"];
    NSDictionary *paras = @{
                            @"gatewayId" : gatewayId,
                            @"access_token" : token
                            };
    [manager POST:@"http://120.77.13.77:8080/AppInterface/appGetPanelInfo" parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSLog(@"%@",responseDic);
        if ([(NSNumber *)responseDic[@"Result"] integerValue] == 1) {//成功
            NSString *panel = responseDic[@"Panel"];
            if (panel && ![panel isEqualToString:@""]) {
                NSArray *panelArr = [panel componentsSeparatedByString:@","];
                NSString *pre_inAlarm = panelArr[0];
                self.in_alarm = panelArr[1];
                self.alarm_level = panelArr[2];
            }
            
            NSString *zone = responseDic[@"Zone"];
            if (zone && ![zone isEqualToString:@""]) {
                zone = [zone substringToIndex:zone.length - 1];
                self.zoneArr = [zone componentsSeparatedByString:@","];
            } else {
                self.zoneArr = nil;
            }
        } else {
            NSLog(@"request info result fail");
            NSString *errorStr = responseDic[@"Msg"];
            self.zoneArr = nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"request info fail");
        self.zoneArr = nil;
    }];
}

- (void)stretchyHeaderView:(GSKStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor {
    UIView *info = ((StretchyHeaderView *)headerView).info;
    UILabel *infoLabel = ((StretchyHeaderView *)headerView).infoLabel;
    UIButton *leftBtn = ((StretchyHeaderView *)headerView).leftBtn;
    UILabel *leftLabel = ((StretchyHeaderView *)headerView).leftLabel;
    UIButton *rightBtn = ((StretchyHeaderView *)headerView).rightBtn;
    UILabel *rightLabel = ((StretchyHeaderView *)headerView).rightLabel;
    
    CGFloat factor = stretchFactor / 1;
    info.alpha = factor;
    if (factor == 0) {
    } else {
        info.alpha = factor;
        infoLabel.alpha = factor;
        leftBtn.alpha = factor;
        leftLabel.alpha = factor;
        rightBtn.alpha = factor;
        rightLabel.alpha = factor;
        
    }
    if (factor < 0.95) {
        info.userInteractionEnabled = NO;
    } else {
        info.userInteractionEnabled = YES;
    }
}

- (void)doubleTapWithVideoPlayView:(VideoPlayerView *)videoPlayView andSuperView:(UIView *)superView {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[HomeDataSourceManager sharedInstance].dataSource[indexPath.section].sectionTitle isEqualToString:NSLocalizedString(@"Scene", nil)]) {
        return kSceneHeight;
    }
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeHeaderId"];
    if (!view) {
        view = [[HomeHeaderView alloc] initWithReuseIdentifier:@"HomeHeaderId"];
    }
    view.model = self.dataSource[section];
    view.model.currentSection = section;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        HomeFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeFooterId"];
        if (!view) {
            view = [[HomeFooterView alloc] initWithReuseIdentifier:@"HomeFooterId"];
        }
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 95.5 + 44;
    }
    return 0.000001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
