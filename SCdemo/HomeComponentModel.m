//
//  HomeComponentModel.m
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeComponentModel.h"

@implementation HomeComponentModel

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name on:(BOOL)on
{
    self = [super init];
    if (self) {
        self.icon = icon;
        self.name = name;
        self.on = on;
    }
    return self;
}

@end
