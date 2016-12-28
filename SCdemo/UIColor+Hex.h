//
//  UIColor+Hex.h
//  SCdemo
//
//  Created by appteam on 2016/11/3.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (Hex)

/**
 从十六进制字符串获取颜色

 @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式

 @return color
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 从十六进制字符串获取颜色
 
 @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 @param alpha alpha

 @return color
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

@end
