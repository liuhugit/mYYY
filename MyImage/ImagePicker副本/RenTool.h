//
//  RenTool.h
//  RRB
//
//  Created by 刘虎 on 16/6/27.
//  Copyright © 2016年 钟翠云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PrefixHeader_I.pch"
@interface RenTool : NSObject
+ (CGRect)rectWithOriginalRect:(CGRect)rect isFlexibleHeight:(BOOL)isHeight;

+ (CGFloat)floatWithOriginalFloat:(CGFloat)originalFloat isFlexibleHeight:(BOOL)isHeight;
+ (CGSize)sizeWithOriginalSize:(CGSize)size isFlexibleHeight:(BOOL)isHeight;
+ (void)topView:(UIView *)topview backButton:(UIButton *)backButton nameLabel:(UILabel *)nameLabel;

+ (UIAlertController *)warmingString:(NSString *)string contentString:(NSString *)contentString sureString:(NSString *)sureString andTwo:(NSString *)two andblock:(void(^)())myblock;

+ (UIView *)getActivityMethod;


- (void)sendController:(UIView *)controll sendTitle:(NSString *)title andTitleColor:(UIColor *)color andX:(CGFloat)X andY:(CGFloat)Y andW:(CGFloat)W andH:(CGFloat)H andButtonBackColor:(UIColor *)backColor andblock:(void(^)())myBlock;
@end
