//
//  HomeSettingContainerView.h
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSettingView.h"

//该类只是为了实现阴影效果
@interface HomeSettingContainerView : UIView

@property (nonatomic, strong) HomeSettingView *homeSettingView;

+ (HomeSettingContainerView *)homeSettingContainerViewWithModel:(HomeSettingModel *)model;

@end
