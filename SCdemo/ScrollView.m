//
//  ScrollView.m
//  SCdemo
//
//  Created by appteam on 2016/12/13.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray<UIView *> *)sliderContainers
{
    if (!_sliderContainers) {
        _sliderContainers = [[NSMutableArray alloc] init];
    }
    return _sliderContainers;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    self.scrollEnabled = YES;
    for (UIView *view in self.sliderContainers) {
        CGRect rect = [view.superview convertRect:view.frame toView:self];
        if (CGRectContainsPoint(rect, point)) {
            self.scrollEnabled = NO;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
