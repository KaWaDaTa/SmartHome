//
//  MineStretchyHeaderView.m
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "MineStretchyHeaderView.h"
#import <UIImageView+WebCache.h>

@implementation MineStretchyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // you can change wether it expands at the top or as soon as you scroll down
        self.expansionMode = GSKStretchyHeaderViewExpansionModeTopOnly;
        
        // You can change the minimum and maximum content heights
        self.minimumContentHeight = 64; // you can replace the navigation bar with a stretchy header view
        self.maximumContentHeight = 200;
        
        // You can specify if the content expands when the table view bounces, and if it shrinks if contentView.height < maximumContentHeight. This is specially convenient if you use auto layout inside the stretchy header view
        self.contentShrinks = NO;
        self.contentExpands = NO; // useful if you want to display the refreshControl below the header view
        
        // You can specify wether the content view sticks to the top or the bottom of the header view if one of the previous properties is set to NO
        // In this case, when the user bounces the scrollView, the content will keep its height and will stick to the bottom of the header view
        self.contentAnchor = GSKStretchyHeaderViewContentAnchorBottom;
        
        [self updateUI];
    }
    return self;
}

- (void)updateUI
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
    [maskPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, self.contentView.bounds.size.height)];
    [maskPath addArcWithCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -250) radius:self.contentView.bounds.size.height + 250
                    startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(0, 0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    [voice setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    voice.backgroundColor = [UIColor lightTextColor];
    [self.contentView addSubview:voice];
    [voice makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(@10);
        make.top.equalTo(@22);
    }];
    voice.layer.cornerRadius = 20;
    
    UIImageView *portrait = [[UIImageView alloc] init];
    portrait.layer.cornerRadius = 40;
    portrait.layer.masksToBounds = YES;
    [self.contentView addSubview:portrait];
    [portrait makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.equalTo(80);
    }];
    [portrait sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri]  placeholderImage:[UIImage imageNamed:@"头像"]];
    
    UILabel *name = [[UILabel alloc] init];
    name.adjustsFontSizeToFitWidth = YES;
    name.text = [RCIM sharedRCIM].currentUserInfo.name;
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portrait.bottom).offset(5);
        make.centerX.equalTo(portrait);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
}


@end
