//
//  SegSlider.h
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegSlider;
@protocol SegSliderDelegate <NSObject>

- (void)SegSliderSliding:(SegSlider *)slider;

@end

@interface SegSlider : UISlider
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@property (nonatomic, assign, readonly) NSUInteger currentNumber;
@property (nonatomic, weak) id<SegSliderDelegate> segDelegate;

- (instancetype)initWithNumbers:(NSArray *)numbers;
@end
