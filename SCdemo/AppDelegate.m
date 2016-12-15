//
//  AppDelegate.m
//  SCdemo
//
//  Created by appteam on 2016/10/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserInfoDataSource.h"

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self RCIMsetting];
    
    [self registerRemoteNotification];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].clipsToBounds = YES;
    
//    ViewController *vc = [[ViewController alloc] init];
//    vc.tabBarItem.title = @"Home";
//    
//    ChatListViewController *chatVC1 = [[ChatListViewController alloc] init];
//    chatVC1.tabBarItem.title = @"Chat1";
//    chatVC1.view.backgroundColor = [UIColor whiteColor];
//    ChatListViewController *chatVC2 = [[ChatListViewController alloc] init];
//    chatVC2.tabBarItem.title = @"Chat2";
//    chatVC2.view.backgroundColor = [UIColor blueColor];
//    ChatListViewController *chatVC3 = [[ChatListViewController alloc] init];
//    chatVC3.tabBarItem.title = @"Chat3";
//    chatVC3.view.backgroundColor = [UIColor cyanColor];
//    
//    UITabBarController *tabVC = [[UITabBarController alloc] init];
//    tabVC.viewControllers = @[vc,chatVC1,chatVC2,chatVC3];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = naVC;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    return YES;
}

- (void)RCIMsetting
{
    [[RCIM sharedRCIM] initWithAppKey:kAPPKEY];
    [RCIM sharedRCIM].disableMessageNotificaiton = NO;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //    [RCIM sharedRCIM].enableMessageMentioned = YES;
    [RCIM sharedRCIM].maxRecallDuration = 120;
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].userInfoDataSource = [UserInfoDataSource sharedInstance];
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),
                                                                 @(ConversationType_GROUP),
                                                                 @(ConversationType_DISCUSSION)];
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    [RCIM sharedRCIM].disableMessageNotificaiton = NO;
}

- (void)registerRemoteNotification
{
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

//在前台和后台活动状态时收到任何消息都会执行
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
}
//在后台活动状态时接收到消息会执行。如果返回 NO，SDK 会默认弹出本地通知（必须实现用户信息提供者和群组信息提供者，否则将不会有本地通知提示弹出）；如果返回 YES，将由 App 全权处理该通知，SDK 不会再做任何处理
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{
    return NO;
}
//在前台状态收到消息时收到消息会执行
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message
{
    return NO;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
//    NSLog(@"setDeviceToken:%@",token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to register:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"receiveRemoteNotification:%@",userInfo);
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        ViewController *loginVC = [[ViewController alloc] init];
        UINavigationController *_navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    NSInteger unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
