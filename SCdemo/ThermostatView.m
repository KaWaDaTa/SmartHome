//
//  ThermostatView.m
//  SCdemo
//
//  Created by appteam on 2016/12/26.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ThermostatView.h"
#import "EFCircularSlider.h"

@interface ThermostatView ()
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, strong) EFCircularSlider *slider;
@end

@implementation ThermostatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"Thermostat", nil);
    [self addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
    }];
    
    self.slider = ({
        EFCircularSlider *slider = [[EFCircularSlider alloc] init];
        slider.backgroundColor = [UIColor clearColor];
        slider.lineWidth = 15;
        slider.handleColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1];
        slider.unfilledColor = [UIColor colorWithHexString:@"#ebebeb"];
        slider.filledColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1];
        slider.handleType = EFBigCircle;
        [slider setInnerMarkingLabels:@[@"0",@"1",@"3",@"4",@"5",@"6"]];
        [self addSubview:slider];
        [slider makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(30);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
            make.width.equalTo(self);
        }];
        
        slider;
    });
    
    self.innerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.slider);
            make.width.height.equalTo(60);
        }];
        
        view;
    });
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setImage:[UIImage imageNamed:@"减.gif"] forState:UIControlStateNormal];
    [self addSubview:minus];
    [minus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(-10);
        make.width.height.equalTo(40);
    }];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [plus setImage:[UIImage imageNamed:@"加.gif"] forState:UIControlStateNormal];
    [self addSubview:plus];
    [plus makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
        make.width.height.equalTo(40);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.innerView setRoundedCorners:UIRectCornerAllCorners radius:30];
}

@end
