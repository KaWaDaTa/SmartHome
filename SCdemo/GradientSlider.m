//
//  GradientSlider.m
//  SCdemo
//
//  Created by appteam on 2016/11/3.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "GradientSlider.h"

@implementation GradientSlider

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
        self.maximumTrackTintColor = [UIColor clearColor];
        self.minimumTrackTintColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(2, 15, self.bounds.size.width, 2);
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.colors = @[(id)[UIColor redColor].CGColor
                        ,(id)[UIColor blueColor].CGColor
                        ,(id)[UIColor greenColor].CGColor
                        ,(id)[UIColor redColor].CGColor
                        ];
    gradient.locations = @[@0,@0.4,@0.8,@1];
    [self.layer addSublayer:gradient];
    [self.layer insertSublayer:gradient atIndex:0];
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, [UIScreen mainScreen].scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
