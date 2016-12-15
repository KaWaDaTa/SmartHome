//
//  VideoPlayerView.h
//  SCdemo
//
//  Created by appteam on 2016/10/31.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayerView : UIView

@property (nonatomic, retain, readonly) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL isFullScreen;

- (instancetype)initWithURL:(NSURL *)URL;
- (void)replaceWithURL:(NSURL *)URL;

@end
