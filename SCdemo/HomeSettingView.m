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

- (void)setIsSelected:(BOOL)isSelected
{
    [self layoutIfNeeded];
    _isSelected = isSelected;
    if (_isSelected) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, 9)];
        [path addLineToPoint:CGPointMake(20, 9)];
        [path addLineToPoint:CGPointMake(30, 0)];
        [path addLineToPoint:CGPointMake(40, 9)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, 9)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path closePath];
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    } else {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, 9)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, 9)];
        [path addLineToPoint:CGPointMake(maskLayer.frame.size.width, maskLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, maskLayer.frame.size.height)];
        [path closePath];
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

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
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self addSubview:header];
    [header makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(9);
    }];
    if (self.type == LayoutTypeNormal) {
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(9);
            make.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.4).offset(-9*0.4);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = model.homeComponentModels[0].name;
        [label setTextColor:[UIColor colorWithHexString:@"#313131"]];
        [topView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(topView);
            make.width.equalTo(topView).multipliedBy(0.5);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:model.homeComponentModels[0].icon];
        [topView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-40);
            make.centerY.equalTo(label);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        
        self.sliderContainer = ({
            UIView *sliderContainer = [[UIView alloc] init];
            sliderContainer.backgroundColor = [UIColor colorWithHexString:@"#cacaca"alpha:0.4];
            [self addSubview:sliderContainer];
            [sliderContainer makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.6).offset(-9*0.6);
            }];
            
            sliderContainer;
        });

		UILabel *option = [[UILabel alloc] init];
		[option setFont:[UIFont systemFontOfSize:15]];
		option.text = self.homeSettingModel.optionSliderModels[0].title;
		option.textAlignment = NSTextAlignmentCenter;
		[option setTextColor:[UIColor lightGrayColor]];
		[self.sliderContainer addSubview:option];
		[option makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.sliderContainer.left).offset(15);
			make.top.equalTo(self.sliderContainer.top).offset(15);
			make.height.equalTo(15);
		}];
		
		if ([self.homeSettingModel.optionSliderModels[0].title isEqualToString:@"Color"]) {
			GradientSlider *slider = [[GradientSlider alloc] init];
			self.slider = slider;
			[self.sliderContainer addSubview:slider];
			[slider makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.sliderContainer);
				make.centerY.equalTo(self.sliderContainer).offset(25);
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
			self.slider = slider;
			slider.maximumTrackTintColor = [UIColor whiteColor];
			slider.minimumTrackTintColor = [UIColor whiteColor];
			[self.sliderContainer addSubview:slider];
			[slider makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.sliderContainer);
				make.centerY.equalTo(self.sliderContainer).offset(25);
				make.left.equalTo(30);
				make.right.equalTo(-30);
			}];
			
			NSMutableArray *optionViews = [[NSMutableArray alloc] init];
			NSArray *options = self.homeSettingModel.optionSliderModels[0].options;
			for (NSInteger i = 0; i< options.count; i++) {
				UILabel *label = [[UILabel alloc] init];
				label.font = [UIFont systemFontOfSize:10];
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
		
    } else if (self.type == LayoutTypeDouble) {
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(9);
            make.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5).offset(-9*0.5);
        }];
		
        UIView *botView = [[UIView alloc] init];
        botView.backgroundColor = [UIColor whiteColor];
        [self addSubview:botView];
        [botView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5).offset(-9*0.5);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#cacaca" alpha:0.4];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(4.5);
            make.centerX.equalTo(self);
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
            
            UILabel *label = [[UILabel alloc] init];
            label.text = model.homeComponentModels[i].name;
            [label setTextColor:[UIColor colorWithHexString:@"#313131"]];
            [view addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.centerY.equalTo(view);
                make.width.equalTo(view).multipliedBy(0.5);
            }];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:model.homeComponentModels[i].icon];
            [view addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-40);
                make.centerY.equalTo(label);
                make.width.equalTo(60);
                make.height.equalTo(60);
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
		if (!self.sliderContainer.layer.mask) {
			CAShapeLayer *maskLayer = [CAShapeLayer layer];
			maskLayer.frame = self.sliderContainer.bounds;
			UIBezierPath *path = [UIBezierPath bezierPath];
			[path moveToPoint:CGPointMake(0, maskLayer.frame.size.height)];
			[path addLineToPoint:CGPointMake(0, 5)];
			[path addLineToPoint:CGPointMake(30, 5)];
			[path addLineToPoint:CGPointMake(35, 0)];
			[path addLineToPoint:CGPointMake(40, 5)];
			[path addLineToPoint:CGPointMake(maskLayer.frame.size.width, 5)];
			[path addLineToPoint:CGPointMake(maskLayer.frame.size.width, maskLayer.frame.size.height)];
			[path addLineToPoint:CGPointMake(0, maskLayer.frame.size.height)];
			[path closePath];
			maskLayer.path = path.CGPath;
			self.sliderContainer.layer.mask = maskLayer;

		}
    }
    self.isSelected = NO;
}

@end
