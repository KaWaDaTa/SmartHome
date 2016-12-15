//
//  SegSlider.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "SegSlider.h"

@interface SegSlider ()
@property (nonatomic, strong) NSArray *numbers;
@end

@implementation SegSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithNumbers:(NSArray *)numbers
{
    self = [super init];
    if (self) {
        self.numbers = numbers;
        NSInteger numberOfSteps = (float)[self.numbers count] - 1;
        self.maximumValue = numberOfSteps;
        self.minimumValue = 0;
        self.continuous = YES;
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)valueChanged:(UISlider *)sender
{
    NSUInteger index = (NSUInteger)(self.value + 0.5);
    [self setValue:index animated:NO];
    NSNumber *number = self.numbers[index];
    _currentIndex = index;
    _currentNumber = number.unsignedIntegerValue;
    if (self.segDelegate && [self.segDelegate respondsToSelector:@selector(SegSliderSliding:)]) {
        [self.segDelegate SegSliderSliding:self];
    }
}

@end
