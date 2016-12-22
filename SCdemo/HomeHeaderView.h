//
//  HomeHeaderView.h
//  SCdemo
//
//  Created by appteam on 2016/12/22.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSectionModel.h"

@interface HomeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) HomeSectionModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *timer;

@end
