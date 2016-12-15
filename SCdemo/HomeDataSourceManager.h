//
//  HomeDataSourceManager.h
//  SCdemo
//
//  Created by appteam on 2016/12/14.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSectionModel.h"

@interface HomeDataSourceManager : NSObject

@property (nonatomic, strong) NSMutableArray<HomeSectionModel *> *dataSource;

+ (HomeDataSourceManager *)sharedInstance;

@end
