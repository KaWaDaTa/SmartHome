//
//  UserInfoDataSource.h
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoDataSource : NSObject<RCIMUserInfoDataSource>

@property (nonatomic, copy)NSMutableArray *userInfoList;

+ (UserInfoDataSource *)sharedInstance;
- (RCUserInfo *)getUserInfoForUserId:(NSString *)inputId;

@end
