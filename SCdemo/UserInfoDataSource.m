//
//  UserInfoDataSource.m
//  SCdemo
//
//  Created by appteam on 2016/12/5.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "UserInfoDataSource.h"

@implementation UserInfoDataSource

+ (UserInfoDataSource *)sharedInstance
{
    static UserInfoDataSource *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoDataSource alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _userInfoList = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 100 ; i++) {
            RCUserInfo *user = [[RCUserInfo alloc] init];
            user.userId = [NSString stringWithFormat:@"%ld",(long)i];
            user.name = [NSString stringWithFormat:@"%ld",i];
            user.portraitUri = @"http://touxiang.qqzhi.com/uploads/2012-11/1111010813715.jpg";
            [_userInfoList addObject:user];
        }
    }
    return self;
}

- (RCUserInfo *)getUserInfoForUserId:(NSString *)inputId
{
    for (RCUserInfo *user in _userInfoList) {
        if ([user.userId isEqualToString:inputId]) {
            return user;
        }
    }
    return nil;
}
/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    for (RCUserInfo *user in _userInfoList) {
        if ([userId isEqualToString:user.userId]) {
            completion(user);
            break;
        }
    }
}

@end
