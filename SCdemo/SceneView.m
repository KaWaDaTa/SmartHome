//
//  SceneView.m
//  SCdemo
//
//  Created by appteam on 2016/12/27.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "SceneView.h"

@interface SceneView ()
@property (nonatomic, strong) HomeSettingModel *model;
@end

@implementation SceneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithHomeSettingModel:(HomeSettingModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:self.model.imgName];
    [self addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.model.title;
    titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
    [self addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(48);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 25;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1b95a7"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#d4d4d4"] forState:UIControlStateSelected];
    [btn setTitle:NSLocalizedString(@"ON", nil) forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"OFF", nil) forState:UIControlStateSelected];
    [self addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(125);
        make.height.equalTo(50);
        make.bottom.equalTo(self).offset(-30);
    }];
}

- (void)btnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
@end
