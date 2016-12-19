//
//  ScrollViewContainer.m
//  SCdemo
//
//  Created by appteam on 2016/12/19.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.scrollView = ({
        ScrollView *scroll = [[ScrollView alloc] init];
        scroll.clipsToBounds = NO;
        [self addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.bottom.equalTo(self);
            make.width.equalTo(self).offset(-20);
        }];
        
        scroll;
    });
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]){
        for (UIView *subview in self.scrollView.subviews){
            CGPoint offset = CGPointMake(point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subview.frame.origin.x, point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return self.scrollView;
    }
    return view;
}

@end
