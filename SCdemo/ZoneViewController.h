//
//  ZoneViewController.h
//  SCdemo
//
//  Created by appteam on 2016/12/19.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoneViewController : UIViewController

@property (nonatomic, strong) NSArray *zoneArr;
@property (nonatomic, strong) UITableView *table;

- (instancetype)initWithZoneArr:(NSArray *)zoneArr;

@end
