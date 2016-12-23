//
//  HomeSettingContainerView.m
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeSettingContainerView.h"

@implementation HomeSettingContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (HomeSettingContainerView *)homeSettingContainerViewWithModel:(HomeSettingModel *)model
{
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(HomeSettingModel *)model
{
    self = [super init];
    if (self) {
        
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 4;
        
        self.homeSettingView = ({
            HomeSettingView *view = [HomeSettingView homeSettingViewWithModel:model];
            [self addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            view;
        });
    }
    return self;
}

@end
