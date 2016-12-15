//
//  OptionSliderModel.m
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "OptionSliderModel.h"

@implementation OptionSliderModel

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options
{
    self = [super init];
    if (self) {
        self.title = title;
        self.options = options;
    }
    return self;
}

@end
