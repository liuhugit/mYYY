//
//  NextButton.m
//  达人圈
//
//  Created by 刘虎 on 16/6/28.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "NextButton.h"

@implementation NextButton

- (UIButton *)sendVC:(UIViewController *)controller rect:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)titleColor buttonColor:(UIColor *)backColor borderWith:(CGFloat)width borderColor:(UIColor *)borderColor coration:(CGFloat)coration and:(void (^)())myBlock{
    _block = myBlock;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backColor;
    if (width != 0) {
        button.layer.borderWidth = width;
    }
    if (borderColor != nil) {
        button.layer.borderColor = borderColor.CGColor;
    }
    if (coration != 0) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = coration;
    }
    [button addTarget:self action:@selector(action_but) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:self];
    [controller.view addSubview:button];

    return button;
}

- (UIButton *)sendNextVC:(UIViewController *)controller rect:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)titleColor buttonColor:(UIColor *)backColor borderWith:(CGFloat)width borderColor:(UIColor *)borderColor coration:(CGFloat)coration{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backColor;
    if (width != 0) {
        button.layer.borderWidth = width;
    }
    if (borderColor != nil) {
        button.layer.borderColor = borderColor.CGColor;
    }
    if (coration != 0) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = coration;
    }
    [controller.view addSubview:self];
    [controller.view addSubview:button];
    return button;
}

- (void)action_but{
    if (_block) {
        _block();
    }
}
@end
