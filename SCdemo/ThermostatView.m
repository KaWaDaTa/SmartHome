//
//  ThermostatView.m
//  SCdemo
//
//  Created by appteam on 2016/12/26.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ThermostatView.h"
#import "EFCircularSlider.h"

#define kInnerRadius 30
typedef NS_ENUM(NSUInteger, ConditionType) {
    Cool = 200,
    Open,
    Humidification,
    Fan,
    Auto,
    Heat,
};
@interface ThermostatView ()
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, strong) EFCircularSlider *slider;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UIImageView *dot;
@property (nonatomic, strong) NSMutableArray *conditionIcons;
@end

@implementation ThermostatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)conditionIcons
{
    if (!_conditionIcons) {
        _conditionIcons = [[NSMutableArray alloc] init];
    }
    return _conditionIcons;
}

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
        [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        slider.backgroundColor = [UIColor clearColor];
        slider.lineWidth = 15;
        slider.handleColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1];
        slider.unfilledColor = [UIColor colorWithHexString:@"#ebebeb"];
        slider.filledColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1];
        slider.handleType = EFBigCircle;
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
            make.width.height.equalTo(kInnerRadius * 2);
        }];
        
        view;
    });
    
    if (!self.dot) {
        self.dot = [[UIImageView alloc] init];
        self.dot.layer.cornerRadius = 2.5;
        self.dot.layer.masksToBounds = YES;
        self.dot.image = [UIImage ImageFromColor:[UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1]];
        [self.innerView addSubview:self.dot];
        [self.dot makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(5);
            make.centerX.equalTo(self.innerView).offset((kInnerRadius - 10) * sin(0*M_PI * 2 /6.0));
            make.centerY.equalTo(self.innerView).offset(-(kInnerRadius - 10) * cos(0*M_PI * 2 /6.0));
        }];
    }
    
    self.showLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%.0f",self.slider.currentValue];
        label.textColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1];
        [self.innerView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.innerView);
        }];
        
        label;
    });
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    minus.tag = 100;
    [minus addTarget:self action:@selector(minusPlusClick:) forControlEvents:UIControlEventTouchUpInside];
    [minus setImage:[UIImage imageNamed:@"减.gif"] forState:UIControlStateNormal];
    [self addSubview:minus];
    [minus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(-10);
        make.width.height.equalTo(40);
    }];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.tag = 101;
    [plus addTarget:self action:@selector(minusPlusClick:) forControlEvents:UIControlEventTouchUpInside];
    [plus setImage:[UIImage imageNamed:@"加.gif"] forState:UIControlStateNormal];
    [self addSubview:plus];
    [plus makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
        make.width.height.equalTo(40);
    }];
    
    NSArray *icons = @[@"制冷",@"开关-(1)",@"加湿",@"风速",@"自动",@"制热"];
    NSArray *selectedIcons = @[@"制冷1",@"开关1",@"加湿1",@"风速1",@"自动1",@"制热1"];
    
    for (NSInteger i=0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        btn.tag = Cool + i;
        [btn addTarget:self action:@selector(innerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedIcons[i]] forState:UIControlStateSelected];
        [self.slider addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(37);
            make.centerX.equalTo(self.slider).offset((kInnerRadius + 13) * sin(i*M_PI * 2 /6.0));
            make.centerY.equalTo(self.slider).offset(-(kInnerRadius + 13) * cos(i*M_PI * 2 /6.0));
        }];
        [self.conditionIcons addObject:btn];
    }
}

- (void)minusPlusClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        self.slider.currentValue -= 1.0;
    } else {
        self.slider.currentValue += 1.0;
    }
}

- (void)innerBtnClick:(UIButton *)sender
{
    NSInteger i = sender.tag - 200;
    for (UIButton *btn in self.conditionIcons) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    [self triangleWithTag:i];
}

- (void)triangleWithTag:(NSInteger)i
{
    float startAngle = i * 2 * M_PI / 6 - M_PI / 2 + M_PI / 18.0;
    float endAngle =  2 * M_PI + i * 2 * M_PI / 6 - M_PI / 2 - M_PI / 18.0;
    CGPoint point = CGPointMake(kInnerRadius + kInnerRadius * sin(i*M_PI * 2 /6.0), kInnerRadius - kInnerRadius * cos(i*M_PI * 2 /6.0));
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.innerView.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kInnerRadius, kInnerRadius) radius:kInnerRadius - 5 startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addLineToPoint:point];
    [path closePath];
    maskLayer.path = path.CGPath;
    self.innerView.layer.mask = maskLayer;
    
    [self.dot remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(5);
        make.centerX.equalTo(self.innerView).offset((kInnerRadius - 10) * sin(i*M_PI * 2 /6.0));
        make.centerY.equalTo(self.innerView).offset(-(kInnerRadius - 10) * cos(i*M_PI * 2 /6.0));
    }];
}

- (void)sliderChange:(EFCircularSlider *)sender
{
    self.showLabel.text = [NSString stringWithFormat:@"%.0f",sender.currentValue];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.innerView setRoundedCorners:UIRectCornerAllCorners radius:kInnerRadius];
    [self triangleWithTag:0];
}

@end
