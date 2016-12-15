//
//  HomeSectionModel.m
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeSectionModel.h"

@implementation HomeSectionModel

- (instancetype)initWithSectionTitle:(NSString *)sectionTitle isExpanded:(BOOL)isExpanded models:(NSMutableArray<HomeSettingModel *> *)models
{
    self = [super init];
    if (self) {
        self.sectionTitle = sectionTitle;
        self.isExpanded = isExpanded;
        self.models = models;
    }
    return self;
}

@end
