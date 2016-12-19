//
//  ZoneTableViewCell.m
//  SCdemo
//
//  Created by appteam on 2016/12/19.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ZoneTableViewCell.h"

@implementation ZoneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.image = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(5);
            make.bottom.equalTo(-5);
            make.width.equalTo(125);
            make.height.equalTo(100);
            make.right.equalTo(130 - kScreenWidth);
        }];
        
        imageView;
    });
    
    self.zoneId = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(20);
            make.top.equalTo(self.image.top).offset(20);
        }];
        
        label;
    });
    
    self.status = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(20);
            make.bottom.equalTo(self.image.bottom).offset(-20);
        }];
        
        label;
    });
    
    self.alarmStatus = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.image);
            make.right.equalTo(-5);
        }];
        
        label;
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
