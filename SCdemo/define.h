//
//  define.h
//  SCdemo
//
//  Created by appteam on 2016/12/6.
//  Copyright © 2016年 appteam. All rights reserved.
//

#ifndef define_h
#define define_h


#endif /* define_h */

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [line:%d] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

//比例
#define kSCREEN_RATE ([UIScreen mainScreen].bounds.size.width/414.0)

//x,y值
#define kORIGIN_X ([UIScreen mainScreen].bounds.origin.x)
#define kORIGIN_Y ([UIScreen mainScreen].bounds.origin.y)

//颜色
#define kRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kRGBAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define kRandRGB KRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//通知
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//宽高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenBounds ([UIScreen mainScreen].bounds)

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

typedef NS_ENUM(NSUInteger, LayoutType) {
    LayoutTypeNormal,
    LayoutTypeTV,
    LayoutTypeDouble,
    LayoutTypeVideo,
};
