//
//  TestTableViewCell.m
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeSettingsCell.h"
#import "VideoPlayerView.h"
#import "GradientSlider.h"
#import "HomeSettingView.h"
//#import "ScrollView.h"
#import "ScrollViewContainer.h"

@interface HomeSettingsCell ()

@end

@implementation HomeSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModels:(NSArray<HomeSettingModel *> *)models
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.homeSettingModels = models;
//        ScrollView *scroll = [[ScrollView alloc] init];
        ScrollViewContainer *scrollContainer = [[ScrollViewContainer alloc] init];
        [self.contentView addSubview:scrollContainer];
        [scrollContainer makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        ScrollView *scroll = scrollContainer.scrollView;
        scroll.pagingEnabled = YES;
        scroll.showsHorizontalScrollIndicator = NO;
//        [self.contentView addSubview:scroll];
//        [scroll makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(10, 0, 0, 0));
//            make.height.equalTo(@200);
//        }];
        
        UIView* contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll).offset(UIEdgeInsetsMake(5, 0, 5, 0));
            make.height.equalTo(scroll).offset(-10);
        }];
        
        UIView *lastView;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
        
        for (int i = 0; i < models.count; i++) {
            HomeSettingView *view = [HomeSettingView homeSettingViewWithModel:models[i]];
            [contentView addSubview:view];
            
            if (i == 0) {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@10);
                    make.top.equalTo(@0);
                    make.height.equalTo(contentView);
                    make.width.equalTo(@(width));
                }];
            } else {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(20);
                    make.top.equalTo(@0);
                    make.height.equalTo(contentView);
                    make.width.equalTo(@(width));
                }];
            }
            
            width += 0;
            lastView = view;
            
            [scroll.ignoreSlideViews addObjectsFromArray:view.controls];
            if (view.sliderContainer) {
                [scroll.ignoreSlideViews addObject:view.sliderContainer];
            }
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right).offset(10);
        }];
        
    }
    return self;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
