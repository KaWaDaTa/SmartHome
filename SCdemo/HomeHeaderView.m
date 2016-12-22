//
//  HomeHeaderView.m
//  SCdemo
//
//  Created by appteam on 2016/12/22.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeHeaderView.h"


@implementation HomeHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [label setTextColor:[UIColor colorWithHexString:@"#3d3d3d"]];
            [label setFont:[UIFont boldSystemFontOfSize:24]];
            [self.contentView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(44);
                make.left.equalTo(28);
            }];
            
            label;
        });
        
        self.typeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [label setTextColor:[UIColor whiteColor]];
            [self.contentView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel).offset(9);
                make.top.equalTo(self.titleLabel.bottom).offset(4);
                make.height.equalTo(12.5);
            }];
            
            label;
        });
        
        UIView *labelBg = [[UIView alloc] init];
        labelBg.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
        labelBg.layer.cornerRadius = 9;
        labelBg.layer.masksToBounds = YES;
        [self.contentView addSubview:labelBg];
        [labelBg makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.typeLabel).offset(-2.75);
            make.bottom.equalTo(self.typeLabel).offset(2.75);
            make.width.equalTo(self.typeLabel).offset(18);
        }];
        [self.contentView insertSubview:labelBg belowSubview:self.typeLabel];
        
        self.timer = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"定时.gif"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(250);
                make.width.height.equalTo(29);
                make.bottom.equalTo(labelBg);
            }];
            
            btn;
        });
    }
    return self;
}

- (void)setModel:(HomeSectionModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.titleLabel.text = model.sectionTitle;
    switch (model.currentType) {
        case CardTypeFavorites:
            self.typeLabel.text = NSLocalizedString(@"Favorites", nil);
            break;
        case CardTypeZone:
            self.typeLabel.text = NSLocalizedString(@"Zone", nil);
            break;
        case CardTypeDevices:
            self.typeLabel.text = NSLocalizedString(@"Devices", nil);
            break;
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end