//
//  ConversationListViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "GroupChatViewController.h"
#import "AddContactViewController.h"
#import "QRCodeViewController.h"
#import "ShakeViewController.h"
#import "MomentsViewController.h"

@interface ConversationListViewController ()<YBPopupMenuDelegate>

@property (nonatomic, strong) UIButton *menuBtn;

@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.conversationListTableView.tableFooterView = [UIView new];
//    self.navigationItem.title = [[RCIM sharedRCIM] currentUserInfo].name;
    self.isShowNetworkIndicatorView = YES;
    self.showConnectingStatusOnNavigatorBar = YES;
    //    self.emptyConversationView = [UIView new];
    
//    UIBarButtonItem *discussion = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"discussion", nil) style:UIBarButtonItemStylePlain target:self action:@selector(discussion)];
    
//    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addChat)];
//    self.navigationItem.rightBarButtonItems = @[add];
    
    self.menuBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"首页添加"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateSelected];
        btn.bounds = CGRectMake(0, 0, 25, 25);
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    UIBarButtonItem *menuBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.rightBarButtonItem = menuBarBtn;
    
//    UIBarButtonItem *quit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"log out", nil) style:UIBarButtonItemStylePlain target:self action:@selector(quit)];
//    self.navigationItem.leftBarButtonItem = quit;
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)menuBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    [YBPopupMenu showRelyOnView:self.menuBtn titles:@[NSLocalizedString(@"Group chat", nil),NSLocalizedString(@"Add contacts", nil),NSLocalizedString(@"Scan QR code", nil),NSLocalizedString(@"Shake", nil),NSLocalizedString(@"Moments", nil)] icons:@[@"群聊",@"添加朋友",@"扫一扫",@"摇一摇",@"朋友圈"] menuWidth:200 delegate:self];
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 0) {
        [self addChat];
        return;
    }
    UIViewController *vc = nil;
    switch (index) {
        case 0:
            vc = [[GroupChatViewController alloc] init];
            break;
        case 1:
            vc = [[AddContactViewController alloc] init];
            break;
        case 2:
            vc = [[QRCodeViewController alloc] init];
            break;
        case 3:
            vc = [[ShakeViewController alloc] init];
            break;
        case 4:
            vc = [[MomentsViewController alloc] init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ybPopupMenuDidDismiss
{
    self.menuBtn.selected = NO;
}

- (void)discussion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"input some userIds separated by commas", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[RCIMClient sharedRCIMClient] createDiscussion:NSLocalizedString(@"discussion", nil) userIdList:[alert.textFields[0].text componentsSeparatedByString:@","] success:^(RCDiscussion *discussion) {
            NSLog(@"discussion success");
            //新建一个聊天会话View Controller对象
            ConversationViewController *chat = [[ConversationViewController alloc]init];
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
            chat.conversationType = ConversationType_DISCUSSION;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chat.targetId = discussion.discussionId;
            //设置聊天会话界面要显示的标题
            chat.title = discussion.discussionName;
            //显示聊天会话界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:chat animated:YES];
            });
        } error:^(RCErrorCode status) {
            NSLog(@"discussion fail");
        }];
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)quit
{
    [[RCIM sharedRCIM] disconnect];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addChat
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"input targetId", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ConversationViewController *chat = [[ConversationViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        chat.targetId = alert.textFields[0].text;
        chat.title = alert.textFields[0].text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:chat animated:YES];
        });
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:conversationVC animated:YES];
    });
}

- (void)didTapCellPortrait:(RCConversationModel *)model
{
    
}

- (void)didLongPressCellPortrait:(RCConversationModel *)model
{
    
}

@end
