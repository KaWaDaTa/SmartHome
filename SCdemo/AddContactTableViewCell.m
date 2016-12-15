//
//  AddContactTableViewCell.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "AddContactTableViewCell.h"

@implementation AddContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    _iconImgView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(10);
            make.bottom.equalTo(-10);
            make.width.height.equalTo(kScreenHeight / 8 - 20);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        
        label;
    });
    
    _subtitleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        
        label;
    });
    
    NSArray *labels = @[_titleLabel,_subtitleLabel];
    [labels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    [labels makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImgView.right).offset(5);
        make.width.equalTo(kScreenWidth - 15 - kScreenHeight / 8 + 20);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
