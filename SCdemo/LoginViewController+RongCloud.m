//
//  LoginViewController+RongCloud.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "LoginViewController+RongCloud.h"
#import <CommonCrypto/CommonDigest.h>
#import "ConversationListViewController.h"
#import "UserInfoDataSource.h"
#import "ContactViewController.h"
#import "MineViewController.h"

@implementation LoginViewController (RongCloud)

- (void)RCIMregister
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *urlstr =@"http://api.cn.ronghub.com/user/getToken.json";
    NSDictionary *dic =@{@"userId":self.userNameField.text,
                         @"name": [NSString stringWithFormat:@"UserName_%@",self.userNameField.text],
                         @"portraitUri": @"http://touxiang.qqzhi.com/uploads/2012-11/1111010813715.jpg"
                         };
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(long)[NSDate timeIntervalSinceReferenceDate]];
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString * Signature = [self sha1:[NSString stringWithFormat:@"%@%@%@",kAPPKEY,nonce,timestamp]];
    //以下拼接请求内容
    [manager.requestSerializer setValue:kAPPKEY forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:kAPPSECRET forHTTPHeaderField:@"appSecret"];
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //开始请求
    [manager POST:urlstr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self connectWithToken:[(NSDictionary *)responseObject objectForKey:@"token"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

- (void)connectWithToken:(NSString *)token
{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [RCIM sharedRCIM].currentUserInfo = [[UserInfoDataSource sharedInstance] getUserInfoForUserId:self.userNameField.text];
        NSLog(@"Login successfully,current ID:%@",userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ViewController *vc = [[ViewController alloc] init];
            UINavigationController *homeNavc = [[UINavigationController alloc] initWithRootViewController:vc];
            homeNavc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"首页-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [homeNavc.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
            
            ConversationListViewController *chatVC1 = [[ConversationListViewController alloc] init];
            UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:chatVC1];
            naVC1.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"消息-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [naVC1.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];

            ContactViewController *contactVC = [[ContactViewController alloc] init];
            UINavigationController *contactNavc = [[UINavigationController alloc] initWithRootViewController:contactVC];
            contactNavc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"通讯"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"通讯-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [contactNavc.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
            
            MineViewController *mineVC = [[MineViewController alloc] init];
            UINavigationController *mineNavc = [[UINavigationController alloc] initWithRootViewController:mineVC];
            mineNavc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"我的-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [mineNavc.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
            
            UITabBarController *tabVC = [[UITabBarController alloc] init];
            tabVC.tabBar.backgroundColor = [UIColor whiteColor];
            tabVC.viewControllers = @[homeNavc,naVC1,contactNavc,mineNavc];
            
            [self.navigationController presentViewController:tabVC animated:NO completion:nil];
            
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登录的错误码为:%ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
}

- (NSString*)sha1:(NSString *)inputStr
{
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
