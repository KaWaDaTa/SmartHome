//
//  HomeComponentModel.h
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeComponentModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL on;

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name on:(BOOL)on;

@end
