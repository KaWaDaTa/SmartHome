//
//  ScanView.h
//  SCdemo
//
//  Created by appteam on 2016/12/8.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * const SuccessScanQRCodeNotification;
extern NSString * const ScanQRCodeMessageKey;

@class ScanView;
@protocol ScanViewDelegate <NSObject>

- (void)scanView:(ScanView *)scanView codeInfo:(NSString *)codeInfo;

@end

@interface ScanView : UIView

@property (nonatomic, weak) id<ScanViewDelegate> delegate;

+ (instancetype)scanViewShowInController:(UIViewController *)controller;

- (void)start;

- (void)stop;

@end
