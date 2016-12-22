//
//  ScrollView.h
//  SCdemo
//
//  Created by appteam on 2016/12/13.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView

@property (nonatomic, copy) NSMutableArray<UIView *> *ignoreSlideViews;
@property (nonatomic, strong) UIView *contentView;

@end
