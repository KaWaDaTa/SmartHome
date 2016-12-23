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
#import "HomeSettingContainerView.h"


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
        scrollContainer.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        [self.contentView addSubview:scrollContainer];
        [scrollContainer makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.scroll = scrollContainer.scrollView;
        self.scroll.delegate = self;
        self.scroll.pagingEnabled = YES;
        self.scroll.showsHorizontalScrollIndicator = NO;
//        [self.contentView addSubview:scroll];
//        [scroll makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(10, 0, 0, 0));
//            make.height.equalTo(@200);
//        }];
        
        UIView* contentView = [[UIView alloc] init];
        [self.scroll addSubview:contentView];
        self.scroll.contentView = contentView;
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scroll);
            make.height.equalTo(self.scroll);
        }];
        
        UIView *lastView;
        CGFloat width = 258;
        
        for (int i = 0; i < models.count; i++) {
            HomeSettingContainerView *view = [HomeSettingContainerView homeSettingContainerViewWithModel:models[i]];
            [contentView addSubview:view];
            
            if (i == 0) {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@7);
                    make.top.equalTo(@0);
                    make.height.equalTo(contentView);
                    make.width.equalTo(@(width));
                }];
            } else {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(14);
                    make.top.equalTo(@0);
                    make.height.equalTo(contentView);
                    make.width.equalTo(@(width));
                }];
            }
            
            lastView = view;
            
            if (i == models.count - 1) {
                
                UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
                [back setImageEdgeInsets:UIEdgeInsetsMake(35, 15, 35, 15)];
                [back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
                [back addTarget:self action:@selector(scrollToFirst:) forControlEvents:UIControlEventTouchUpInside];
                back.backgroundColor = [UIColor colorWithHexString:@"#008ea2"];
                [contentView addSubview:back];
                [back makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(14);
                    make.top.equalTo(lastView).offset(9);
                    make.width.equalTo(50);
                    make.height.equalTo(contentView).multipliedBy(0.5).offset(-6);
                }];
                
                UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
                [add setImageEdgeInsets:UIEdgeInsetsMake(35, 15, 35, 15)];
                [add setImage:[UIImage imageNamed:@"添加卡片"] forState:UIControlStateNormal];
                add.backgroundColor = [UIColor colorWithHexString:@"#008ea2"];
                [contentView addSubview:add];
                [add makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(14);
                    make.bottom.equalTo(lastView);
                    make.width.equalTo(50);
                    make.height.equalTo(back);
                }];
                
                lastView = add;
            }
            
            if (view.homeSettingView.sliderContainer) {
                [self.scroll.ignoreSlideViews addObject:view.homeSettingView.slider];
            }
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right);
        }];
        
    }
    return self;
}

- (void)scrollToFirst:(UIButton *)sender
{
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:NO];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [((HomeSettingContainerView *)self.scroll.contentView.subviews[0]).homeSettingView setIsSelected:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (scrollView.contentOffset.x != currentPage * pageWidth) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [scrollView setContentOffset:CGPointMake(currentPage * pageWidth, 0)];
        } completion:nil];
    }
    for (NSInteger i = 0; i < self.scroll.contentView.subviews.count; i++) {
        UIView *view = self.scroll.contentView.subviews[i];
        if ([view isKindOfClass:[HomeSettingContainerView class]]) {
            if (i == currentPage) {
                [((HomeSettingContainerView *)view).homeSettingView setIsSelected:YES];
            } else {
                [((HomeSettingContainerView *)view).homeSettingView setIsSelected:NO];
            }
        }
    }
}

@end
