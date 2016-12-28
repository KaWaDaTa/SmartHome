//
//  SceneScorllViewContainer.h
//  SCdemo
//
//  Created by appteam on 2016/12/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSettingModel.h"

@interface SceneScorllViewContainer : UIView
@property (nonatomic, strong) UIScrollView *bigScrollView;//显示内容
@property (nonatomic, strong) UIScrollView *smallScrollView;//实现pagingEnabled效果
- (instancetype)initWithModels:(NSArray<HomeSettingModel *> *)models;
@end
