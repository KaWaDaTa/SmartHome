//
//  ConversationViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "ConversationViewController.h"
#import "ChatInfoViewController.h"

@interface ConversationViewController ()
@property (nonatomic, strong) UIButton *infoItem;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    
    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE),
                                          @(ConversationType_DISCUSSION),
                                          @(ConversationType_CHATROOM),
                                          @(ConversationType_GROUP),
                                          @(ConversationType_APPSERVICE),
                                          @(ConversationType_SYSTEM)];
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    
    self.chatSessionInputBarControl = RCChatSessionInputBarInputText;
    
    self.infoItem = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, 20, 20);
        [button addTarget:self action:@selector(infoItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.infoItem];
    
    if (self.conversationType == ConversationType_PRIVATE) {
        [self.infoItem setImage:[UIImage imageNamed:@"详细信息"] forState:UIControlStateNormal];
//        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addMemberToDiscussion)];
//        UIBarButtonItem *remove = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Remove", nil) style:UIBarButtonItemStylePlain target:self action:@selector(removeMemberFromDiscussion)];
//        UIBarButtonItem *quit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Quit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(quitFromDiscussion)];
//        self.navigationItem.rightBarButtonItems = @[add,quit];
    } else if (self.conversationType == ConversationType_DISCUSSION) {
        [self.infoItem setImage:[UIImage imageNamed:@"群聊"] forState:UIControlStateNormal];
    }
}

- (void)infoItemClick:(UIButton *)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    ChatInfoViewController *chatInfoVC = [[ChatInfoViewController alloc] initWithConversationType:self.conversationType targetId:self.targetId];
    [self.navigationController pushViewController:chatInfoVC animated:YES];
}

- (void)addMemberToDiscussion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"input some userIds separated by commas", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.targetId userIdList:[alert.textFields[0].text componentsSeparatedByString:@","] success:^(RCDiscussion *discussion) {
            
        } error:^(RCErrorCode status) {
            
        }];
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)removeMemberFromDiscussion
{
    
}

- (void)quitFromDiscussion
{
    [[RCIMClient sharedRCIMClient] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } error:^(RCErrorCode status) {
        NSLog(@"Fail to quit from discussion:%@ error:%ld",self.targetId,(long)status);
    }];
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model
{
    [super didTapUrlInMessageCell:url model:model];
}

- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model
{
    [super didTapPhoneNumberInMessageCell:phoneNumber model:model];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    [super didTapCellPortrait:userId];
}

- (void)didLongPressCellPortrait:(NSString *)userId
{
    [super didLongPressCellPortrait:userId];
}

@end
