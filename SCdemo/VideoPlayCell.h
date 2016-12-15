//
//  VideoPlayCell.h
//  SCdemo
//
//  Created by appteam on 2016/10/31.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerView.h"

@protocol VideoPlayDelegate <NSObject>

- (void)doubleTapWithVideoPlayView:(VideoPlayerView *)videoPlayView andSuperView:(UIView *)superView;

@end

@interface VideoPlayCell : UITableViewCell

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, assign) id<VideoPlayDelegate> delegate;

@end
