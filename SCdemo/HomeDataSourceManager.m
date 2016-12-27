//
//  HomeDataSourceManager.m
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeDataSourceManager.h"
#import "HomeSettingModel.h"

@implementation HomeDataSourceManager

+ (HomeDataSourceManager *)sharedInstance
{
    static HomeDataSourceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSArray *sectionTitles = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Simon's", nil),NSLocalizedString(@"Living room", nil),NSLocalizedString(@"Bedroom", nil),NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Balcony", nil),NSLocalizedString(@"Scene", nil)]];
    NSArray *cardTypes = @[@(CardTypeFavorites),@(CardTypeZone),@(CardTypeZone),@(CardTypeDevices),@(CardTypeZone),@(CardTypeFavorites)];
    
    NSArray *icons = @[@"灯",@"咖啡机",@"风扇",@"冰箱",@"灯"];
    NSArray *names = @[@"Lights",@"Coffee",@"Fan",@"Fridge",@"Lights1"];
    NSArray *titles = @[@"Color",@"Mode",@"Wind power",@"Temperature",@"Color"];
    NSArray *options = @[@[@"Warm yellow"],@[@"Auto",@"Warm",@"Heat",@"Refrigeration"],@[@"First gear",@"Second gear",@"Third gear"],@[@"First gear",@"Second gear",@"Third gear"],@[@"Warm yellow"]];
    NSArray *imgNames = @[@"sleep_mode",@"music_mode",@"sleep_mode",@"music_mode",@"sleep_mode"];
    NSArray *sceneTitles = @[@"Sleep Mode",@"Music Mode",@"Sleep Mode",@"Music Mode",@"Sleep Mode"];
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < sectionTitles.count; i++) {
            HomeSectionModel *sectionModel = [[HomeSectionModel alloc] init];
            sectionModel.sectionTitle = sectionTitles[i];
            sectionModel.currentType = [cardTypes[i] unsignedIntegerValue];
            NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
            for (NSInteger j = 0; j <5; j++) {
                if (i == 3 ) {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.title = @"video";
                    
                    model.type = LayoutTypeVideo;
                    model.url = [NSURL URLWithString:@"http://vmovier.qiniudn.com/559b918dbf717.mp4"];
                    [sectionArray addObject:model];
                } else if (i == 4) {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.title = @"Blinds";
                    model.type = LayoutTypeNormal;
                    
                    HomeComponentModel *componentModel = [[HomeComponentModel alloc] init];
                    componentModel.icon = @"窗帘";
                    componentModel.on = YES;
                    componentModel.name = @"Blinds";
                    
                    OptionSliderModel *optionModel = [[OptionSliderModel alloc] init];
                    optionModel.title = @"Up-down";
                    
                    model.homeComponentModels = @[componentModel];
                    model.optionSliderModels = @[optionModel];
                    [sectionArray addObject:model];
                } else if (i == 0 && j == 0) {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.title = @"Light";
                    model.type = LayoutTypeDouble;
                    
                    HomeComponentModel *componentModel = [[HomeComponentModel alloc] init];
                    componentModel.icon = @"灯";
                    componentModel.on = NO;
                    componentModel.name = @"Lights";
                    
                    HomeComponentModel *componentModel1 = [[HomeComponentModel alloc] init];
                    componentModel1.icon = @"插座";
                    componentModel1.on = YES;
                    componentModel1.name = @"Socket";
                    
                    model.homeComponentModels = @[componentModel,componentModel1];
                    [sectionArray addObject:model];
                } else if (i == 2 && j == 0) {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.type = LayoutTypeThermostat;
                    model.title = NSLocalizedString(@"Thermostat", nil);
                    [sectionArray addObject:model];
                } else if (i == 5) {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.type = LayoutTypeScene;
                    model.imgName = imgNames[j];
                    model.title = sceneTitles[j];
                    [sectionArray addObject:model];
                } else {
                    HomeSettingModel *model = [[HomeSettingModel alloc] init];
                    model.title = names[j];
                    model.type = LayoutTypeNormal;
                    
                    HomeComponentModel *componentModel = [[HomeComponentModel alloc] init];
                    componentModel.icon = icons[j];
                    componentModel.on = YES;
                    componentModel.name = names[j];
                    
                    OptionSliderModel *optionModel = [[OptionSliderModel alloc] init];
                    optionModel.title = titles[j];
                    optionModel.options = options[j];
                    
                    model.homeComponentModels = @[componentModel];
                    model.optionSliderModels = @[optionModel];
                    [sectionArray addObject:model];
                }
                sectionModel.models = sectionArray;
            }
            [_dataSource addObject:sectionModel];
        }
    }
}

@end
