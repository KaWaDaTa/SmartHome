//
//  StretchyHeaderView.h
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <GSKStretchyHeaderView/GSKStretchyHeaderView.h>

@protocol  StretchyHeaderDelegate <NSObject>

- (void)tapSecurity;
- (void)tapSetArm:(UIButton *)sender;

@end

typedef NS_ENUM(NSUInteger, ArmStyle) {
    ArmStyleStay = 100,
    ArmStyleAway,
    ArmStyleDisarmed,
};

@interface StretchyHeaderView : GSKStretchyHeaderView

@property (nonatomic, assign) ArmStyle currentArmStyle;
@property (nonatomic, retain) UIImageView *info;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, retain) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, weak) id<StretchyHeaderDelegate> delegate;
@property (nonatomic, assign) BOOL hideLeftRight;

@end
