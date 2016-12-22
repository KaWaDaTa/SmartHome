//
//  HomeSectionModel.h
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSettingModel.h"

typedef NS_ENUM(NSUInteger, CardType) {
    CardTypeFavorites,
    CardTypeZone,
    CardTypeDevices,
};

@interface HomeSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, assign) CardType currentType;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) NSMutableArray<HomeSettingModel *> *models;

- (instancetype)initWithSectionTitle:(NSString *)sectionTitle isExpanded:(BOOL)isExpanded models:(NSMutableArray<HomeSettingModel *> *)models;

@end
