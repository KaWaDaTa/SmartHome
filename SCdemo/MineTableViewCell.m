//
//  MineTableViewCell.m
//  SCdemo
//
//  Created by appteam on 2016/12/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.width.height.equalTo(20);
                make.top.equalTo(30);
                make.bottom.equalTo(-30);
                make.right.equalTo(-(kScreenWidth - 20 - 20));
            }];
            
            imageView;
        });
        
        self.label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            [self.contentView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(-20);
            }];
            
            label;
        });
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
