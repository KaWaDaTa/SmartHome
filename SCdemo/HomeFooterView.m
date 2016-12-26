//
//  HomeFooterView.m
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "HomeFooterView.h"
#import <MarqueeLabel.h>

@interface HomeFooterView ()
@property (nonatomic, strong) MarqueeLabel *marqueeLabel;
@end

@implementation HomeFooterView

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
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *redView = [[UIView alloc] init];
        redView.backgroundColor = [UIColor colorWithHexString:@"#ff5a60"];
        [self addSubview:redView];
        [redView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(95.5);
        }];
        
        //        UILabel *label = [[UILabel alloc] init];
        //        label.font = [UIFont systemFontOfSize:18];
        //        label.text = NSLocalizedString(@"Remember to go out security!", nil);
        //        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        //        [redView addSubview:label];
        //        [label makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(40);
        //            make.centerY.equalTo(redView);
        //        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"away"] forState:UIControlStateNormal];
        [redView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(72.5);
            make.right.equalTo(-14);
            make.centerY.equalTo(redView);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.marqueeLabel) {
        self.marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(20, 65, 250, 50) duration:8 andFadeLength:10];
        self.marqueeLabel.animationDelay = 0;
        self.marqueeLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.marqueeLabel.font = [UIFont systemFontOfSize:18];
        self.marqueeLabel.text = NSLocalizedString(@"Remember to go out security!     ",nil);
        [self addSubview:self.marqueeLabel];
    }
    
}

@end
