//
//  NextButton.h
//  达人圈
//
//  Created by 刘虎 on 16/6/28.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextButton : UIButton

@property (nonatomic,copy)void(^block)();

- (UIButton *)sendVC:(UIViewController *)controller rect:(CGRect )rect title:(NSString *)title titleColor:(UIColor *)titleColor buttonColor:(UIColor *)backColor borderWith:(CGFloat)width borderColor:(UIColor *)borderColor coration:(CGFloat)coration and:(void(^)())myBlock;

- (UIButton *)sendNextVC:(UIViewController *)controller rect:(CGRect )rect title:(NSString *)title titleColor:(UIColor *)titleColor buttonColor:(UIColor *)backColor borderWith:(CGFloat)width borderColor:(UIColor *)borderColor coration:(CGFloat)coration;
@end
