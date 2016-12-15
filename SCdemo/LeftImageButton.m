//
//  LeftImageButton.m
//  SCdemo
//
//  Created by appteam on 2016/12/6.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "LeftImageButton.h"

@implementation LeftImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (CGRect)backgroundRectForBounds:(CGRect)bounds
//{
//    
//}
//- (CGRect)contentRectForBounds:(CGRect)bounds
//{
//    
//}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width / 2, 0, contentRect.size.width / 2, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width / 4, contentRect.size.height / 6, contentRect.size.width / 4, contentRect.size.height * 2 / 3);
}

@end
