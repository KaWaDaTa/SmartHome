//
//  StretchyHeaderView.m
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "StretchyHeaderView.h"
#import "PasswordView.h"

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
                self.leftBtn.tag = ArmStyleStay;
                self.leftLabel.text = NSLocalizedString(@"Stay", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
                self.rightBtn.tag = ArmStyleAway;
                self.rightLabel.text = NSLocalizedString(@"Away", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
                break;
            case ArmStyleStay:
                self.info.image = [UIImage imageNamed:@"stay"];
                self.infoLabel.text = NSLocalizedString(@"Stay", nil);
                [self.leftBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
                self.leftBtn.tag = ArmStyleAway;
                self.leftLabel.text = NSLocalizedString(@"Away", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"disarmed-xiao"] forState:UIControlStateNormal];
                self.rightBtn.tag = ArmStyleDisarmed;
                self.rightLabel.text = NSLocalizedString(@"Disarmed", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffc658"];
                break;
            case ArmStyleAway:
                self.infoLabel.text = NSLocalizedString(@"Away", nil);
                self.info.image = [UIImage imageNamed:@"away"];
                [self.leftBtn setImage:[UIImage imageNamed:@"stay-小"] forState:UIControlStateNormal];
                self.leftBtn.tag = ArmStyleStay;
                self.leftLabel.text = NSLocalizedString(@"Stay", nil);
                [self.rightBtn setImage:[UIImage imageNamed:@"disarmed-xiao"] forState:UIControlStateNormal];
                self.rightBtn.tag = ArmStyleDisarmed;
                self.rightLabel.text = NSLocalizedString(@"Disarmed", nil);
                self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ff5a60"];
                break;
            default:
                break;
        }
        self.hideLeftRight = YES;
    }
}

- (void)setHideLeftRight:(BOOL)hideLeftRight
{
    _hideLeftRight = hideLeftRight;
    if (_hideLeftRight) {
        _leftBtn.hidden = YES;
        _leftLabel.hidden = YES;
        _rightBtn.hidden = YES;
        _rightLabel.hidden = YES;
        
    } else {
        _leftBtn.hidden = NO;
        _leftLabel.hidden = NO;
        _rightBtn.hidden = NO;
        _rightLabel.hidden = NO;
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
        self.maximumContentHeight = 336;
        
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
    self.hideLeftRight = YES;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.text = [NSString stringWithFormat:@"Hi , %@",[RCIM sharedRCIM].currentUserInfo.name];
    userLabel.font = [UIFont systemFontOfSize:55];
    userLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:userLabel];
    [userLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.equalTo(20);
    }];
    
    _info = [[UIImageView alloc] init];
    _info.userInteractionEnabled = YES;
    _info.image = [UIImage imageNamed:@"disarmed"];
    [self.contentView addSubview:_info];
    [_info makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).centerOffset(CGPointMake(0, 10));
        make.width.height.equalTo(@100);
    }];
    _info.layer.cornerRadius = 50;
    
    self.infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"Disarmed", nil);
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(_info);
            make.top.equalTo(_info.bottom).offset(22.5);
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
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [_info addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *securityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecurity:)];
    [self.contentView addGestureRecognizer:securityGesture];
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [_info addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_info addGestureRecognizer:longGesture];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn addTarget:self action:@selector(leftRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setImage:[UIImage imageNamed:@"stay-小"] forState:UIControlStateNormal];
    _leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ffc658"];
    [self.contentView addSubview:_leftBtn];
    [_leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.top.equalTo(_info.bottom).offset(-30);
        make.left.equalTo(@50);
    }];
    _leftBtn.layer.cornerRadius = 35;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.hidden = YES;
    _leftBtn.tag = ArmStyleStay;
    
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
        label.hidden = YES;
        
        label;
    });
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn addTarget:self action:@selector(leftRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setImage:[UIImage imageNamed:@"away-小"] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5a60"];
    [self.contentView addSubview:_rightBtn];
    [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.top.equalTo(_info.bottom).offset(-30);
        make.right.equalTo(@(-50));
    }];
    _rightBtn.layer.cornerRadius = 35;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.hidden = YES;
    _rightBtn.tag = ArmStyleAway;
    
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
        label.hidden = YES;
        
        label;
    });
    
    [self.contentView bringSubviewToFront:self.info];
    self.currentArmStyle = ArmStyleDisarmed;
}

- (void)leftRightClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSetArm:)]) {
        [self.delegate tapSetArm:sender];
    }
    UIColor *color;
    switch (sender.tag) {
        case ArmStyleDisarmed:
            color = [UIColor colorWithHexString:@"#00c8e3"];
            break;
        case ArmStyleStay:
            color = [UIColor colorWithHexString:@"#ffc658"];
            break;
        case ArmStyleAway:
            color = [UIColor colorWithHexString:@"#ff5a60"];
            break;
        default:
            break;
    }
//    [PasswordView showWithColor:color];
//    self.currentArmStyle = sender.tag;
//    self.hideLeftRight = YES;
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    self.hideLeftRight = !self.hideLeftRight;
}

- (void)tapSecurity:(UITapGestureRecognizer *)sender
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
    if (self.hideLeftRight) {
        return;
    }
    if (_checkPoint) {
        _startPoint = sender.view.center;
        _checkPoint = NO;
    }
    CGPoint point = [sender locationInView:self.contentView];
    sender.view.center = point;
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.view.center = _startPoint;
            if (distanceBetweenPoint(point, self.leftBtn.center) < 85) {
//                if (self.currentArmStyle == ArmStyleDisarmed) {
//                    self.currentArmStyle = ArmStyleStay;
//                } else if (self.currentArmStyle == ArmStyleStay) {
//                    self.currentArmStyle = ArmStyleAway;
//                } else if (self.currentArmStyle == ArmStyleAway) {
//                    self.currentArmStyle = ArmStyleStay;
//                }
                [self leftRightClick:self.leftBtn];
            } else if (distanceBetweenPoint(point, self.rightBtn.center) < 85) {
//                if (self.currentArmStyle == ArmStyleDisarmed) {
//                    self.currentArmStyle = ArmStyleAway;
//                } else if (self.currentArmStyle == ArmStyleStay) {
//                    self.currentArmStyle = ArmStyleDisarmed;
//                } else if (self.currentArmStyle == ArmStyleAway) {
//                    self.currentArmStyle = ArmStyleDisarmed;
//                }
                [self leftRightClick:self.rightBtn];
            }
        }];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (_checkPoint) {
        _startPoint = sender.view.center;
        _checkPoint = NO;
    }
    CGPoint point = [sender locationInView:self.contentView];
    CGPoint infoPoint = [sender locationInView:sender.view];
    CGPoint anchorPoint;
    anchorPoint.x = infoPoint.x / sender.view.bounds.size.width;
    anchorPoint.y = infoPoint.y / sender.view.bounds.size.height;
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.hideLeftRight = NO;
        [self setAnchorPoint:anchorPoint forView:sender.view];
        sender.view.center = point;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        sender.view.center = point;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (distanceBetweenPoint(point, self.leftBtn.center) < 85) {
            [self leftRightClick:self.leftBtn];
        } else if (distanceBetweenPoint(point, self.rightBtn.center) < 85) {
            [self leftRightClick:self.rightBtn];
        }
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:sender.view];
        [UIView animateWithDuration:0.25 animations:^{
            sender.view.center = _startPoint;
            self.hideLeftRight = YES;
        }];
    } else if (sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:sender.view];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
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
