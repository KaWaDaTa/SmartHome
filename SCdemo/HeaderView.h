//
//  HeaderView.h
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeSectionModel;

typedef void(^HeaderViewExpandCallback)(BOOL isExpanded);
typedef void(^HeaderViewLongpressCallback)(UILongPressGestureRecognizer *sender);

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) HomeSectionModel *model;
@property (nonatomic, copy) HeaderViewExpandCallback expandCallback;
@property (nonatomic, copy) HeaderViewLongpressCallback longpressCallback;

@end
