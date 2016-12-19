//
//  ZoneTableViewCell.h
//  SCdemo
//
//  Created by appteam on 2016/12/19.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoneTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *zoneId;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *alarmStatus;

@end
