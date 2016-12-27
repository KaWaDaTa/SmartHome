//
//  HomeSettingModel.h
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeComponentModel.h"
#import "OptionSliderModel.h"

@interface HomeSettingModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) LayoutType type;
@property (nonatomic, strong) NSArray<HomeComponentModel *> *homeComponentModels;
@property (nonatomic, strong) NSArray<OptionSliderModel *> *optionSliderModels;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *imgName;

- (instancetype)initWithTitle:(NSString *)title type:(LayoutType)type homeComponentModels:(NSArray<HomeComponentModel *> *)homeComponentModels optionSliderModels:(NSArray<OptionSliderModel *> *)optionSliderModels url:(NSURL *)url;

@end
