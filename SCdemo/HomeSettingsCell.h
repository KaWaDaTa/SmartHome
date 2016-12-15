//
//  TestTableViewCell.h
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegSlider.h"
#import "HomeSettingModel.h"

@interface HomeSettingsCell : UITableViewCell<SegSliderDelegate>
@property (nonatomic, strong) NSArray *homeSettingModels;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModels:(NSArray<HomeSettingModel *> *)models;
@end
