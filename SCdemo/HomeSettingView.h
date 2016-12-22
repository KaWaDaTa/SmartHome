//
//  HomeSettingView.h
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSettingModel.h"

@interface HomeSettingView : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) LayoutType type;
@property (nonatomic, strong) UIView *sliderContainer;
@property (nonatomic, strong) NSMutableArray<UIView *> *controls;

+ (HomeSettingView *)homeSettingViewWithModel:(HomeSettingModel *)model;

@end
