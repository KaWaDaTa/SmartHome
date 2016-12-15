//
//  VideoPlayerView.m
//  SCdemo
//
//  Created by appteam on 2016/10/31.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView ()

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) UIView *barView;
@property (nonatomic, retain) UIProgressView *progress;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *currentTimeLabel;
@property (nonatomic, retain) UILabel *totalTimeLabel;
@property (nonatomic, assign) CMTime totalTime;
@property (nonatomic, retain) NSURL *video_url;
@property (nonatomic, assign) BOOL didPlay;
@property (nonatomic, assign) BOOL needPlay;
@property (nonatomic, assign) float loadTime;
@property (nonatomic, retain) UIButton *playBtn;

@end

@implementation VideoPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.needPlay = NO;
        self.didPlay = NO;
        self.isFullScreen = NO;
        self.video_url = URL;
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        [self setupBar];
        [self configureLayer];
    }
    return self;
}

- (void)replaceWithURL:(NSURL *)URL
{
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    
    [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    self.needPlay = NO;
    _video_url = URL;
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:_video_url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    [self addObserverToPlayerItem:playerItem];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addProgressObserver];
    
}

- (void)configureLayer
{
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:_video_url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    if (playerItem) {
        if (!_player) {
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            if (_player) {
                [self addProgressObserver];
                [self addObserverToPlayerItem:playerItem];
            }
        }
    } else {
        NSLog(@"Fail to link");
    }
    ((AVPlayerLayer *)self.layer).player = self.player;
    //    ((AVPlayerLayer *)self.layer).videoGravity = AVLayerVideoGravityResizeAspect;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification{
//    [_player seekToTime:CMTimeMake(0, 1)];
//    [_player play];
}

- (void)addProgressObserver {
    
    UISlider *slider = _slider;
    
    __block VideoPlayerView *weakSelf = self;
    
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        
        if (current) {
            [slider setValue:current animated:YES];
            int currentTime = (int)current;
            int m = currentTime / 60;
            int s = currentTime % 60;
            NSString *strM = nil;
            NSString *strS = nil;
            if (m < 10) {
                strM = [NSString stringWithFormat:@"0%d", m];
            } else {
                strM = [NSString stringWithFormat:@"%d", m];
            }
            if (s < 10) {
                strS = [NSString stringWithFormat:@"0%d", s];
            } else {
                strS = [NSString stringWithFormat:@"%d", s];
            }
            weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%@:%@", strM, strS];
        }
        
    }];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
            self.totalTime = playerItem.duration;
            [self customVideoSlider:playerItem.duration];
            int totalTime = CMTimeGetSeconds(playerItem.duration);
            int m = totalTime / 60;
            int s = totalTime % 60;
            NSString *strM = nil;
            NSString *strS = nil;
            if (m < 10) {
                strM = [NSString stringWithFormat:@"0%d", m];
            } else {
                strM = [NSString stringWithFormat:@"%d", m];
            }
            if (s < 10) {
                strS = [NSString stringWithFormat:@"0%d", s];
            } else {
                strS = [NSString stringWithFormat:@"%d", s];
            }
            self.totalTimeLabel.text = [NSString stringWithFormat:@"%@:%@", strM, strS];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self addNotification];
        
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"totalBuffer:%f %p",totalBuffer,self);
        
        if (!isnan(CMTimeGetSeconds(self.totalTime)) && !isnan(totalBuffer)) {
            [_progress setProgress:totalBuffer/CMTimeGetSeconds(self.totalTime) animated:YES];
        }
        float currentPlayTime =  CMTimeGetSeconds([self.player currentTime]);
        if (totalBuffer - currentPlayTime > 3.0) {
            if (!self.didPlay) {
                [self configureLayer];
                if (self.needPlay) {
                    [self.player play];
                }
                self.didPlay = YES;
            }
        } else {
            [self.player pause];
            self.didPlay = NO;
        }
    }
}

- (void)setupBar
{
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    [_playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    
    _barView = [[UIView alloc] init];
    _barView.backgroundColor = [UIColor lightGrayColor];
    _barView.alpha = 0.5;
    [self addSubview:_barView];
    [_barView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    _barView.hidden = YES;
    
    _progress = [[UIProgressView alloc] init];
    [_progress setProgressTintColor:[UIColor orangeColor]];
    [_barView addSubview:_progress];
    [_progress makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_barView);
        make.width.equalTo(_barView).valueOffset(@(-100));
        make.height.equalTo(@2);
    }];
    
    _slider = [[UISlider alloc] init];
    [_slider setThumbImage:[UIImage imageNamed:@"ball_16"] forState:UIControlStateNormal];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2, 2), NO, 0);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_slider setMinimumTrackTintColor:[UIColor blueColor]];
    [_slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_barView addSubview:_slider];
    [_slider makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_barView);
        make.centerY.equalTo(_barView).offset(-0.5);
        make.width.equalTo(_barView).valueOffset(@-100);
        make.height.equalTo(@5);
    }];
    
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_barView addSubview:_currentTimeLabel];
    [_currentTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(_barView);
        make.right.equalTo(_progress.left);
    }];
    
    _totalTimeLabel = [[UILabel alloc] init];
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_barView addSubview:_totalTimeLabel];
    [_totalTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(_barView);
        make.left.equalTo(_progress.right);
    }];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:_tapGesture];
}

- (void)tap
{
    if(self.player.rate == 0){ //说明是暂停
        self.needPlay = YES;
        [_playBtn setImage:[UIImage new] forState:UIControlStateNormal];
        if (self.didPlay) {
            [self.player play];
        }
    }else if(self.player.rate == 1){//正在播放
        [self.player pause];
        [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
}

- (void)customVideoSlider:(CMTime)duration {
    
    _slider.maximumValue = CMTimeGetSeconds(duration);
    _slider.minimumValue = 0.0;
}


- (void)sliderAction:(UISlider *)slider {
    
    if (self.player.rate == 0) {
        [self.player seekToTime:CMTimeMake((int)slider.value*10, 10.0)];
        [self.player play];
//        [self.playButton setImage:[UIImage imageNamed:@"pause_64.png"] forState:UIControlStateNormal];
    } else if(self.player.rate == 1) {
        [self.player pause];
        [self.player seekToTime:CMTimeMake((int)slider.value*10, 10.0)];
        [self.player play];
//        [self.playButton setImage:[UIImage imageNamed:@"pause_64.png"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    self.layer.frame = self.bounds;
}

- (void)dealloc
{
    NSLog(@"dealloc:%p %@",self,[self class]);
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
}

@end
