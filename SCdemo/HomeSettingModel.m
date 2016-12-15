//
//  HomeSettingModel.m
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeSettingModel.h"

@implementation HomeSettingModel

- (instancetype)initWithTitle:(NSString *)title type:(LayoutType)type homeComponentModels:(NSArray<HomeComponentModel *> *)homeComponentModels optionSliderModels:(NSArray<OptionSliderModel *> *)optionSliderModels url:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.title = title;
        self.type = type;
        self.homeComponentModels = homeComponentModels;
        self.optionSliderModels = optionSliderModels;
        self.url = url;
    }
    return self;
}

@end
