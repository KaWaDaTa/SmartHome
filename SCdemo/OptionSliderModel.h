//
//  OptionSliderModel.h
//  SCdemo
//
//  Created by appteam on 2016/12/9.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionSliderModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<NSString *> *options;

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options;

@end
