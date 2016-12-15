//
//  QRCodeViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"

@interface QRCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,ScanViewDelegate>
@property (nonatomic, strong) ScanView * scanView;
@end

@implementation QRCodeViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.scanView = [ScanView scanViewShowInController: self];
    }
    return self;
}


#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.scanView];
    
    self.navigationItem.title = NSLocalizedString(@"Scan QR Code", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    UIButton *photoLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoLibraryBtn addTarget:self action:@selector(QRfromPhtoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [photoLibraryBtn setImage:[UIImage imageNamed:@"扫一扫图片"] forState:UIControlStateNormal];
    photoLibraryBtn.bounds = CGRectMake(0, 0, 20, 20);
    
    UIBarButtonItem *photoLibraryItem = [[UIBarButtonItem alloc] initWithCustomView:photoLibraryBtn];
    self.navigationItem.rightBarButtonItem = photoLibraryItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.scanView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.scanView stop];
}

- (void)dealloc
{
    [self.scanView stop];
}

- (void)scanView:(ScanView *)scanView codeInfo:(NSString *)codeInfo
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Result", nil) message:codeInfo preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)QRfromPhtoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePickVC = [[UIImagePickerController alloc] init];
        imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickVC.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePickVC.delegate = self;
        [self presentViewController:imagePickVC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self readQRCodeFromImage:image];
    }];
}

- (void)readQRCodeFromImage:(UIImage *)image{
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Result", nil) message:scannedResult preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    };
}

@end
