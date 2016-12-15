//
//  VideoPlayCell.m
//  SCdemo
//
//  Created by appteam on 2016/10/31.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "VideoPlayCell.h"

@interface VideoPlayCell ()

@property (nonatomic, copy) NSMutableArray *playerViews;

@end

@implementation VideoPlayCell

- (void)setURL:(NSURL *)URL
{
    if (_URL != URL) {
        _URL = URL;
        UIView *view = (UIView *)(self.playerViews[0]);
        if ([view subviews].count > 0) {
            VideoPlayerView *playerView = (VideoPlayerView *)[view subviews][0];
            [playerView replaceWithURL:_URL];
        } else {
            VideoPlayerView *playerView = [[VideoPlayerView alloc] initWithURL:URL];
            [view addSubview:playerView];
            [playerView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            [playerView addGestureRecognizer:doubleTap];
            
            [playerView.tapGesture requireGestureRecognizerToFail:doubleTap];
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)sender
{
    return;
    if (_delegate && [_delegate respondsToSelector:@selector(doubleTapWithVideoPlayView:andSuperView:)]) {
        [_delegate doubleTapWithVideoPlayView:(VideoPlayerView *)sender.view andSuperView:(UIView *)self.playerViews[0]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.pagingEnabled = YES;
        scroll.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.equalTo(@253);
        }];
        
        UIView* contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.height.equalTo(scroll);
        }];
        
        UIView *lastView;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
        
        _playerViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.shadowOffset = CGSizeMake(0, 0);
            view.layer.shadowColor = [UIColor blackColor].CGColor;
            view.layer.shadowOpacity = 0.2;
            view.layer.shadowRadius = 2;
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
            [_playerViews addObject:view];
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

- (void)dealloc
{
    NSLog(@"dealloc:%p %@",self,[self class]);
}

@end
