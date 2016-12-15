//
//  ScanView.m
//  SCdemo
//
//  Created by appteam on 2016/12/8.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>

NSString * const SuccessScanQRCodeNotification = @"SuccessScanQRCodeNotification";
NSString * const ScanQRCodeMessageKey = @"ScanQRCodeMessageKey";

#define SCANSPACEOFFSET 0.15f
#define REMINDTEXT NSLocalizedString(@"Align QR code/barcode within frame to scan", nil);

@interface ScanView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * scanView;

@property (nonatomic, strong) CAShapeLayer * maskLayer;
@property (nonatomic, strong) CAShapeLayer * shadowLayer;
@property (nonatomic, strong) CAShapeLayer * scanRectLayer;

@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, strong) UILabel * remind;

@end

@implementation ScanView

+ (instancetype)scanViewShowInController:(UIViewController *)controller
{
    if (!controller) { return nil; }
    ScanView * scanView = [[ScanView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([controller conformsToProtocol: @protocol(ScanViewDelegate)]) {
        scanView.delegate = (UIViewController<ScanViewDelegate> *)controller;
    }
    return scanView;
}

- (instancetype)initWithFrame: (CGRect)frame
{
    frame = kScreenBounds;
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor colorWithWhite: 0.f alpha: 0.2f];
        [self.layer addSublayer: self.scanView];
        [self setupScanRect];
        [self addSubview: self.remind];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)start
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}

- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [AVCaptureSession new];
        [_session setSessionPreset: AVCaptureSessionPresetHigh];
        [self setupIODevice];
    }
    return _session;
}

- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice: device error: nil];
    }
    return _input;
}

- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [AVCaptureMetadataOutput new];
        [_output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)scanView
{
    if (!_scanView) {
        _scanView = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
        _scanView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _scanView.frame = self.bounds;
    }
    return _scanView;
}

- (CGRect)scanRect
{
    if (CGRectEqualToRect(_scanRect, CGRectZero)) {
        CGRect rectOfInterest = self.output.rectOfInterest;
        CGFloat yOffset = rectOfInterest.size.width - rectOfInterest.origin.x;
        CGFloat xOffset = 1 - 2 * SCANSPACEOFFSET;
        _scanRect = CGRectMake(rectOfInterest.origin.y * kScreenWidth, rectOfInterest.origin.x * kScreenHeight, xOffset * kScreenWidth, yOffset * kScreenHeight);
    }
    return _scanRect;
}

- (UILabel *)remind
{
    if (!_remind) {
        CGRect textRect = self.scanRect;
        textRect.origin.y = kScreenHeight - 50;
        textRect.size.height = 25.f;
        
        _remind = [[UILabel alloc] initWithFrame: textRect];
        _remind.adjustsFontSizeToFitWidth = YES;
        _remind.textColor = [UIColor whiteColor];
        _remind.textAlignment = NSTextAlignmentCenter;
        _remind.text = REMINDTEXT;
        _remind.backgroundColor = [UIColor clearColor];
    }
    return _remind;
}

- (CAShapeLayer *)scanRectLayer
{
    if (!_scanRectLayer) {
        CGRect scanRect = self.scanRect;
        scanRect.origin.x -= 1;
        scanRect.origin.y -= 1;
        scanRect.size.width += 2;
        scanRect.size.height += 2;
        
        _scanRectLayer = [CAShapeLayer layer];
        _scanRectLayer.path = [UIBezierPath bezierPathWithRect: scanRect].CGPath;
        _scanRectLayer.fillColor = [UIColor clearColor].CGColor;
        _scanRectLayer.strokeColor = [UIColor colorWithHexString:@"#00c8e3"].CGColor;
    }
    return _scanRectLayer;
}

- (CAShapeLayer *)shadowLayer
{
    if (!_shadowLayer) {
        _shadowLayer = [CAShapeLayer layer];
        _shadowLayer.path = [UIBezierPath bezierPathWithRect: self.bounds].CGPath;
        _shadowLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.75].CGColor;
        _shadowLayer.mask = self.maskLayer;
    }
    return _shadowLayer;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer = [self generateMaskLayerWithRect:kScreenBounds exceptRect: self.scanRect];
    }
    return _maskLayer;
}


#pragma mark - generate
/**
 *  生成空缺部分rect的layer
 */
- (CAShapeLayer *)generateMaskLayerWithRect: (CGRect)rect exceptRect: (CGRect)exceptRect
{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    if (!CGRectContainsRect(rect, exceptRect)) {
        return nil;
    }
    else if (CGRectEqualToRect(rect, CGRectZero)) {
        maskLayer.path = [UIBezierPath bezierPathWithRect: rect].CGPath;
        return maskLayer;
    }
    
    CGFloat boundsInitX = CGRectGetMinX(rect);
    CGFloat boundsInitY = CGRectGetMinY(rect);
    CGFloat boundsWidth = CGRectGetWidth(rect);
    CGFloat boundsHeight = CGRectGetHeight(rect);
    
    CGFloat minX = CGRectGetMinX(exceptRect);
    CGFloat maxX = CGRectGetMaxX(exceptRect);
    CGFloat minY = CGRectGetMinY(exceptRect);
    CGFloat maxY = CGRectGetMaxY(exceptRect);
    CGFloat width = CGRectGetWidth(exceptRect);
    
    /** 添加路径*/
    UIBezierPath * path = [UIBezierPath bezierPathWithRect: CGRectMake(boundsInitX, boundsInitY, minX, boundsHeight)];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, boundsInitY, width, minY)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(maxX, boundsInitY, boundsWidth - maxX, boundsHeight)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, maxY, width, boundsHeight - maxY)]];
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

- (void)setupIODevice
{
    if ([self.session canAddInput: self.input]) {
        [_session addInput: _input];
    }
    if ([self.session canAddOutput: self.output]) {
        [_session addOutput: _output];
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
}

- (void)setupScanRect
{
    CGFloat size = kScreenWidth * (1 - 2 * SCANSPACEOFFSET);
    CGFloat minY = (kScreenHeight - size) * 0.5 / kScreenHeight;
    CGFloat maxY = (kScreenHeight + size) * 0.5 / kScreenHeight;
    self.output.rectOfInterest = CGRectMake(minY, SCANSPACEOFFSET, maxY, 1 - SCANSPACEOFFSET * 2);
    
    [self.layer addSublayer: self.shadowLayer];
    [self.layer addSublayer: self.scanRectLayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
//        [self stop];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        if ([self.delegate respondsToSelector: @selector(scanView:codeInfo:)]) {
            [self.delegate scanView:self codeInfo:metadataObject.stringValue];
//            [self removeFromSuperview];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName: SuccessScanQRCodeNotification object: self userInfo: @{ ScanQRCodeMessageKey: metadataObject.stringValue }];
        }
    }
}

@end
