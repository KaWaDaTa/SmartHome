//
//  SceneScorllViewContainer.m
//  SCdemo
//
//  Created by appteam on 2016/12/28.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "SceneScorllViewContainer.h"
#import "SceneView.h"

@interface SceneScorllViewContainer ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<HomeSettingModel *> *models;
@end

@implementation SceneScorllViewContainer

- (instancetype)initWithModels:(NSArray<HomeSettingModel *> *)models
{
    self = [super init];
    if (self) {
        self.models = models;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.smallScrollView = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        [self addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).offset(UIEdgeInsetsMake(0, 20, 0, kScreenWidth - 20 - kSceneWidth));
        }];
        
        UIView *content = [[UIView alloc] init];
        [scroll addSubview:content];
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.height.equalTo(scroll);
        }];
        
        UIView *lastView;
        
        for (NSInteger i=0; i<self.models.count - 1; i++) {
            UIView *view = [[UIView alloc] init];
            [content addSubview:view];
            if (i == 0) {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(7);
                    make.top.bottom.equalTo(content);
                    make.width.equalTo(kSceneContentWidth);
                    make.height.equalTo(kSceneHeight);
                }];
            } else {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(14);
                    make.top.bottom.equalTo(content);
                    make.width.equalTo(kSceneContentWidth);
                    make.height.equalTo(kSceneHeight);
                }];
            }
            lastView = view;
        }
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right).offset(7);
        }];
        
        scroll;
    });
    
    self.bigScrollView = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        [scroll addGestureRecognizer:self.smallScrollView.panGestureRecognizer];
        scroll.delegate = self;
        scroll.clipsToBounds = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).offset(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
        
        UIView *content = [[UIView alloc] init];
        [scroll addSubview:content];
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.height.equalTo(scroll);
        }];
        
        UIView *lastView;
        
        for (NSInteger i=0; i<self.models.count; i++) {
            SceneView *view = [[SceneView alloc] initWithHomeSettingModel:self.models[i]];
            [content addSubview:view];
            if (i == 0) {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(7);
                    make.top.equalTo(content);
                    make.width.equalTo(kSceneContentWidth);
                    make.height.equalTo(kSceneHeight);
                }];
            } else {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.right).offset(14);
                    make.top.equalTo(content);
                    make.width.equalTo(kSceneContentWidth);
                    make.height.equalTo(kSceneHeight);
                }];
            }
            lastView = view;
        }
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right).offset(7);
        }];
        
        scroll;
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.smallScrollView) {
        self.bigScrollView.delegate = nil;
        [self.bigScrollView setContentOffset:scrollView.contentOffset animated:NO];
        self.bigScrollView.delegate = self;
    } else if (scrollView == self.bigScrollView) {
        self.smallScrollView.delegate = nil;
        [self.smallScrollView setContentOffset:scrollView.contentOffset animated:NO];
        self.smallScrollView.delegate = self;
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if ([view isEqual:self]){
//        for (UIView *subview in self.smallScrollView.subviews){
//            CGPoint offset = CGPointMake(point.x - self.smallScrollView.frame.origin.x + self.smallScrollView.contentOffset.x - subview.frame.origin.x, point.y - self.smallScrollView.frame.origin.y + self.smallScrollView.contentOffset.y - subview.frame.origin.y);
//            
//            if ((view = [subview hitTest:offset withEvent:event])){
//                return view;
//            }
//        }
//        return self.smallScrollView;
//    }
//    return view;
//}

@end
