//
//  ChatInfoViewController.h
//  SCdemo
//
//  Created by appteam on 2016/12/7.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatInfoViewController : UIViewController
- (instancetype)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId;
@end
