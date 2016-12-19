//
//  StretchyHeaderView.m
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "StretchyHeaderView.h"

@implementation StretchyHeaderView
{
    CGPoint _startPoint;
    BOOL _checkPoint;
}

- (void)setCurrentArmStyle:(ArmStyle)currentArmStyle
{
    if (_currentArmStyle != currentArmStyle) {
        _currentArmStyle = currentArmStyle;
        switch (_currentArmStyle) {
            case ArmStyleDisarmed:
                self.info.image = [UIImage imageNamed:@"disarmed"];
                self.infoLabel.text = NSLocalizedString(@"Disarmed", nil);
                [self.leftBtn setImage:[UIImage imageNamed:@"stay-小"] forState:UIControlStateNormal];
                self.leftLabel.text = NSLocalizedString(@"Stay", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
                self.rightLabel.text = NSLocalizedString(@"Away", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
                break;
            case ArmStyleStay:
                self.info.image = [UIImage imageNamed:@"stay"];
                self.infoLabel.text = NSLocalizedString(@"Stay", nil);
                [self.leftBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
                self.leftLabel.text = NSLocalizedString(@"Away", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"disarmed-xiao"] forState:UIControlStateNormal];
                self.rightLabel.text = NSLocalizedString(@"Disarmed", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffc658"];
                break;
            case ArmStyleAway:
                self.infoLabel.text = NSLocalizedString(@"Away", nil);
                self.info.image = [UIImage imageNamed:@"away"];
                [self.leftBtn setImage:[UIImage imageNamed:@"stay-小"] forState:UIControlStateNormal];
                self.leftLabel.text = NSLocalizedString(@"Stay", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"disarmed-xiao"] forState:UIControlStateNormal];
                self.rightLabel.text = NSLocalizedString(@"Disarmed", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ff5a60"];
                break;
            default:
                break;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _checkPoint = YES;
        
        // you can change wether it expands at the top or as soon as you scroll down
        self.expansionMode = GSKStretchyHeaderViewExpansionModeTopOnly;
        
        // You can change the minimum and maximum content heights
        self.minimumContentHeight = 64; // you can replace the navigation bar with a stretchy header view
        self.maximumContentHeight = 436;
        
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
    
//    UILabel *timeLabel = [[UILabel alloc] init];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
//    NSString *dateNowStr = [dateFormatter stringFromDate:[NSDate date]];
//    timeLabel.text = dateNowStr;
//    [self.contentView addSubview:timeLabel];
//    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//    }];
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
    
    UILabel *userLabel = [[UILabel alloc] init];
//    userLabel.text = NSLocalizedString(@"Hi , Will!", nil);
    userLabel.text = [NSString stringWithFormat:@"Hi , %@",[RCIM sharedRCIM].currentUserInfo.name];
    userLabel.adjustsFontSizeToFitWidth = YES;
    userLabel.font = [UIFont systemFontOfSize:55];
    userLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:userLabel];
    [userLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@95);
        make.left.equalTo(@15);
        make.height.equalTo(@48);
        make.width.equalTo(@300);
    }];
    userLabel.preferredMaxLayoutWidth = 300;
    
    _info = [[UIImageView alloc] init];
    _info.userInteractionEnabled = YES;
//    _info.backgroundColor = [UIColor whiteColor];
    _info.image = [UIImage imageNamed:@"disarmed"];
    [self.contentView addSubview:_info];
    [_info makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).centerOffset(CGPointMake(0, 10));
        make.width.height.equalTo(@115);
    }];
    _info.layer.cornerRadius = 57.5;
    
    self.infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"Disarmed", nil);
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(_info);
            make.top.equalTo(_info.bottom).offset(20);
            make.height.equalTo(30);
        }];
        
        label;
    });
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
    [maskPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, self.contentView.bounds.size.height)];
    [maskPath addArcWithCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -50) radius:self.contentView.bounds.size.height + 50
                    startAngle:DEGREES_TO_RADIANS(45) endAngle:DEGREES_TO_RADIANS(135) clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(0, 0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_info addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_info addGestureRecognizer:panGesture];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@"stay-小"] forState:UIControlStateNormal];
    _leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ffc658"];
    [self.contentView addSubview:_leftBtn];
    [_leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.top.equalTo(_info.bottom);
        make.left.equalTo(@39);
    }];
    _leftBtn.layer.cornerRadius = 35;
    _leftBtn.layer.masksToBounds = YES;
    
    self.leftLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"Stay", nil);
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.leftBtn);
            make.width.equalTo(self.leftBtn);
            make.top.equalTo(self.leftBtn.bottom).offset(5);
            make.height.equalTo(30);
        }];
        
        label;
    });
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5a60"];
    [self.contentView addSubview:_rightBtn];
    [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.top.equalTo(_info.bottom);
        make.right.equalTo(@(-39));
    }];
    _rightBtn.layer.cornerRadius = 35;
    _rightBtn.layer.masksToBounds = YES;
    
    self.rightLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"Away", nil);
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.rightBtn);
            make.width.equalTo(self.rightBtn);
            make.top.equalTo(self.rightBtn.bottom).offset(5);
            make.height.equalTo(30);
        }];
        
        label;
    });
    
    [self.contentView bringSubviewToFront:self.info];
    self.currentArmStyle = ArmStyleDisarmed;
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSecurity)]) {
        [self.delegate tapSecurity];
    }
}

CGFloat distanceBetweenPoint(CGPoint point0,CGPoint point1)
{
    return sqrt((point0.x - point1.x) * (point0.x - point1.x) + (point0.y - point1.y) * (point0.y - point1.y));
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    if (_checkPoint) {
        _startPoint = sender.view.center;
        _checkPoint = NO;
    }
    CGPoint point = [sender locationInView:self.contentView];
    sender.view.center = point;
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.view.center = _startPoint;
            if (distanceBetweenPoint(point, self.leftBtn.center) < 92.5) {
                if (self.currentArmStyle == ArmStyleDisarmed) {
                    self.currentArmStyle = ArmStyleStay;
                } else if (self.currentArmStyle == ArmStyleStay) {
                    self.currentArmStyle = ArmStyleAway;
                } else if (self.currentArmStyle == ArmStyleAway) {
                    self.currentArmStyle = ArmStyleStay;
                }
            } else if (distanceBetweenPoint(point, self.rightBtn.center) < 92.5) {
                if (self.currentArmStyle == ArmStyleDisarmed) {
                    self.currentArmStyle = ArmStyleAway;
                } else if (self.currentArmStyle == ArmStyleStay) {
                    self.currentArmStyle = ArmStyleDisarmed;
                } else if (self.currentArmStyle == ArmStyleAway) {
                    self.currentArmStyle = ArmStyleDisarmed;
                }
            }
        }];
    }
}

//- (void)updateConstraints
//{
//    [_info remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@30);
//        make.width.equalTo(@100);
//        make.top.equalTo(self.contentView).offset(10);
//        make.right.equalTo(self.contentView).offset(-10);
//    }];
//    [super updateConstraints];
//}
//
//- (void)updateLayout
//{
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self layoutIfNeeded];
//    }];
//}
//
//+ (BOOL)requiresConstraintBasedLayout
//{
//    return YES;
//}

@end
