//
//  HomeSettingView.m
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeSettingView.h"
#import "SegSlider.h"
#import "GradientSlider.h"
#import "VideoPlayerView.h"

@interface HomeSettingView ()
@property (nonatomic, strong) HomeSettingModel *homeSettingModel;
@end

@implementation HomeSettingView

- (NSMutableArray<UIView *> *)controls
{
    if (!_controls) {
        _controls = [[NSMutableArray alloc] init];
    }
    return _controls;
}

+ (HomeSettingView *)homeSettingViewWithModel:(HomeSettingModel *)model
{
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(HomeSettingModel *)model
{
    self = [super init];
    if (self) {
        self.type = model.type;
        self.homeSettingModel = model;
        [self setupUIwithModel:model];
    }
    return self;
}

- (void)setupUIwithModel:(HomeSettingModel *)model
{
    if (self.type == LayoutTypeNormal) {
        
        UIButton *timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timerBtn setImage:[UIImage imageNamed:@"秒表"] forState:UIControlStateNormal];
        [self addSubview:timerBtn];
        [timerBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.right.equalTo(-10);
            make.width.equalTo(20);
            make.height.equalTo(25);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:model.homeComponentModels[0].icon];
        [self addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.top.equalTo(self).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.homeComponentModels[0].name;
        [label setTextColor:[UIColor colorWithHexString:@"#008ea2"]];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.bottom).offset(10);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
        NXTSegmentedControl *switch1 = [[NXTSegmentedControl alloc] initWithItems:@[@"ON",@"OFF"]];
        [self.controls addObject:switch1];
        switch1.tintColor = [UIColor whiteColor];
        if (model.homeComponentModels[0].on == YES) {
            switch1.selectedSegmentIndex = 0;
        } else if (model.homeComponentModels[0].on == NO) {
            switch1.selectedSegmentIndex = 1;
        }
        [switch1 setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"#cacaca"] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        switch1.thumbColor = [UIColor colorWithHexString:@"#008ea2"];
        [self addSubview:switch1];
        [switch1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@40);
            make.right.equalTo(@(-40));
            make.width.equalTo(@110);
            make.height.equalTo(@50);
        }];
        
        self.sliderContainer = ({
            UIView *sliderContainer = [[UIView alloc] init];
            sliderContainer.backgroundColor = [UIColor colorWithHexString:@"#cacaca"alpha:0.4];
            [self addSubview:sliderContainer];
            [sliderContainer makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(90);
            }];
            
            sliderContainer;
        });

    } else if (self.type == LayoutTypeDouble) {
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5);
        }];
        
        UIView *botView = [[UIView alloc] init];
        botView.backgroundColor = [UIColor whiteColor];
        [self addSubview:botView];
        [botView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#cacaca" alpha:0.4];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(1);
        }];
        
        for (NSInteger i = 0 ; i < 2; i++) {
            UIView *view = [[UIView alloc] init];
            if (i == 0) {
                view = topView;
            } else if (i == 1) {
                view = botView;
            }
            UIButton *timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [timerBtn setImage:[UIImage imageNamed:@"秒表"] forState:UIControlStateNormal];
            [view addSubview:timerBtn];
            [timerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.right.equalTo(-10);
                make.width.equalTo(20);
                make.height.equalTo(25);
            }];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:model.homeComponentModels[i].icon];
            [view addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(40);
                make.centerY.equalTo(view).offset(-10);
                make.width.equalTo(60);
                make.height.equalTo(60);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = model.homeComponentModels[i].name;
            [label setTextColor:[UIColor colorWithHexString:@"#008ea2"]];
            [view addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView);
                make.top.equalTo(imageView.bottom).offset(10);
                make.width.equalTo(100);
                make.height.equalTo(20);
            }];
            
            NXTSegmentedControl *switch1 = [[NXTSegmentedControl alloc] initWithItems:@[@"ON",@"OFF"]];
            [self.controls addObject:switch1];
            switch1.tintColor = [UIColor whiteColor];
            if (model.homeComponentModels[i].on == YES) {
                switch1.selectedSegmentIndex = 0;
            } else if (model.homeComponentModels[i].on == NO) {
                switch1.selectedSegmentIndex = 1;
            }
            [switch1 setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"#cacaca"] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            switch1.thumbColor = [UIColor colorWithHexString:@"#008ea2"];
            [view addSubview:switch1];
            [switch1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(@(-40));
                make.width.equalTo(@110);
                make.height.equalTo(@50);
            }];
        }
    } else if (self.type == LayoutTypeTV) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:model.homeComponentModels[0].icon];
        [self addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.top.equalTo(self).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.homeComponentModels[0].name;
        [label setTextColor:[UIColor colorWithHexString:@"#008ea2"]];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.bottom).offset(10);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
        NXTSegmentedControl *switch1 = [[NXTSegmentedControl alloc] initWithItems:@[@"ON",@"OFF"]];
        [self.controls addObject:switch1];
        switch1.tintColor = [UIColor whiteColor];
        if (model.homeComponentModels[0].on == YES) {
            switch1.selectedSegmentIndex = 0;
        } else if (model.homeComponentModels[0].on == NO) {
            switch1.selectedSegmentIndex = 1;
        }
        [switch1 setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"#cacaca"] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        switch1.thumbColor = [UIColor colorWithHexString:@"#008ea2"];
        [self addSubview:switch1];
        [switch1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@40);
            make.right.equalTo(@(-40));
            make.width.equalTo(@110);
            make.height.equalTo(@50);
        }];

    } else if (self.type == LayoutTypeVideo) {
        VideoPlayerView *player = [[VideoPlayerView alloc] initWithURL:model.url];
        [self addSubview:player];
        [player makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    //set shadow
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 3;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.type == LayoutTypeNormal) {
        if (self.sliderContainer.subviews.count != 0) {
            return;
        }
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.sliderContainer.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, 5)];
        [path addLineToPoint:CGPointMake(70, 5)];
        [path addLineToPoint:CGPointMake(75, 0)];
        [path addLineToPoint:CGPointMake(80, 5)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, 5)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path closePath];
        maskLayer.path = path.CGPath;
        self.sliderContainer.layer.mask = maskLayer;
        
        UILabel *option = [[UILabel alloc] init];
        option.text = self.homeSettingModel.optionSliderModels[0].title;
        option.textAlignment = NSTextAlignmentCenter;
        [option setTextColor:[UIColor lightGrayColor]];
        [self addSubview:option];
        [option makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(75 - self.frame.size.width / 2);
            make.bottom.equalTo(self.sliderContainer.top);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
        if ([self.homeSettingModel.optionSliderModels[0].title isEqualToString:@"Color"]) {
            GradientSlider *slider = [[GradientSlider alloc] init];
            [self.sliderContainer addSubview:slider];
            [slider makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.sliderContainer);
                make.centerY.equalTo(self.sliderContainer).offset(5);
                make.left.equalTo(30);
                make.right.equalTo(-30);
            }];
        } else {
            NSMutableArray *numbers = [[NSMutableArray alloc] init];
            for (NSInteger i = 0 ; i < self.homeSettingModel.optionSliderModels[0].options.count; i++) {
                NSNumber *number = [NSNumber numberWithInteger:i];
                [numbers addObject:number];
            }
            
            SegSlider *slider = [[SegSlider alloc] initWithNumbers:numbers];
            slider.maximumTrackTintColor = [UIColor whiteColor];
            slider.minimumTrackTintColor = [UIColor whiteColor];
            [self.sliderContainer addSubview:slider];
            [slider makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.sliderContainer);
                make.centerY.equalTo(self.sliderContainer).offset(5);
                make.left.equalTo(30);
                make.right.equalTo(-30);
            }];
            
            NSMutableArray *optionViews = [[NSMutableArray alloc] init];
            NSArray *options = self.homeSettingModel.optionSliderModels[0].options;
            for (NSInteger i = 0; i< options.count; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:13];
                label.text = options[i];
                label.textColor = [UIColor colorWithHexString:@"#008ea2"];
                label.textAlignment = NSTextAlignmentCenter;
                [self.sliderContainer addSubview:label];
                [optionViews addObject:label];
            }
            [optionViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
            [optionViews makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(slider.top);
                make.height.equalTo(20);
            }];
        }
    }
}

@end
