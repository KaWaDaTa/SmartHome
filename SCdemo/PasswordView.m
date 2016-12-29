//
//  PasswordView.m
//  SCdemo
//
//  Created by appteam on 2016/12/23.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "PasswordView.h"
#import "NSArray+Sudoku.h"

@interface PasswordView ()
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UIView *keyboardView;
@property (nonatomic, strong) NSMutableArray<UITextField *> *displayTextFields;
@property (nonatomic, strong) NSMutableArray<NSString *> *inputNumers;
@end

@implementation PasswordView

- (NSArray *)numbers
{
    if (!_numbers) {
        _numbers = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"Clear",@"0",@"Delete"]];
    }
    return _numbers;
}

- (NSMutableArray *)displayTextFields
{
    if (!_displayTextFields) {
        _displayTextFields = [[NSMutableArray alloc] init];
    }
    return _displayTextFields;
}

- (NSMutableArray<NSString *> *)inputNumers
{
    if (!_inputNumers) {
        _inputNumers = [[NSMutableArray alloc] init];
    }
    return _inputNumers;
}

+ (instancetype)showWithColor:(UIColor *)color
{
    PasswordView *view = [[self alloc] initWithDisplayColor:color];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    return view;
}

+ (void)dismiss
{
    for (UIView *view in [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator]) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (instancetype)initWithDisplayColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _displayColor = color;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.mainView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.backgroundColor = _displayColor;
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(460);
            make.width.equalTo(339);
        }];
        
        view;
    });
    
    self.displayView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = _displayColor;
        [self.mainView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.mainView);
            make.height.equalTo(self.mainView).multipliedBy(0.3);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"Please input password", nil);
        [label setTextColor:[UIColor whiteColor]];
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(18);
            make.centerX.equalTo(view);
        }];
        
        view;
    });
    
    for (NSInteger i=0; i<4; i++) {
        UITextField *field = [[UITextField alloc] init];
        field.layer.cornerRadius = 22.5;
        field.layer.masksToBounds = YES;
        [field setTextAlignment:NSTextAlignmentCenter];
        [field setFont:[UIFont systemFontOfSize:40]];
        field.secureTextEntry = YES;
        field.backgroundColor = [UIColor whiteColor];
        field.userInteractionEnabled = NO;
        [self.displayView addSubview:field];
        [self.displayTextFields addObject:field];
    }
    [self.displayTextFields mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:45 leadSpacing:48 tailSpacing:48];
    [self.displayTextFields makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-32.5);
        make.height.equalTo(45);
    }];
    
    self.keyboardView = ({
        UIView *view = [[UIView alloc] init];
        view.exclusiveTouch = YES;
        view.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.mainView);
            make.height.equalTo(self.mainView).multipliedBy(0.7);
        }];
        
        view;
    });
    for (NSInteger i=0; i < self.numbers.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage ImageFromColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:self.numbers[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.keyboardView addSubview:btn];
    }
    [self.keyboardView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:0 fixedInteritemSpacing:0 warpCount:3 topSpacing:20 bottomSpacing:20 leadSpacing:20 tailSpacing:20];
}

- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Clear"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(passwordView:dismissByCancelled:)]) {
            [self.delegate passwordView:self dismissByCancelled:YES];
        }
        [[self class] dismiss];
    } else if ([sender.titleLabel.text isEqualToString:@"Delete"]) {
        [self.inputNumers removeLastObject];
        for (NSInteger i=0; i<self.displayTextFields.count; i++) {
            if (i + 1 > self.inputNumers.count) {
                self.displayTextFields[i].text = nil;
            }
        }
    } else {
        if (self.inputNumers.count < 4) {
            [self.inputNumers addObject:sender.titleLabel.text];
            for (NSInteger i=0; i<self.inputNumers.count; i++) {
                self.displayTextFields[i].text = self.inputNumers[i];
            }
        }
    }
    
    _currentValue = [NSMutableString stringWithString:@""];
    for (NSInteger i=0; i<self.inputNumers.count; i++) {
        [_currentValue appendString:self.inputNumers[i]];
    }
//    if (self.inputNumers.count == 4) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(passwordView:dismissByCancelled:)]) {
//            [self.delegate passwordView:self dismissByCancelled:NO];
//        }
//        [[self class] dismiss];
//    }
}

@end
