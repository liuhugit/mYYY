//
//  RenTool.m
//  RRB
//
//  Created by 刘虎 on 16/6/27.
//  Copyright © 2016年 钟翠云. All rights reserved.
//

#import "RenTool.h"

@implementation RenTool
+ (CGRect)rectWithOriginalRect:(CGRect)rect isFlexibleHeight:(BOOL)isHeight {
    CGRect currentRect = CGRectMake(0, 0, 0, 0);
    currentRect.origin = [self pointWithOriginalPoint:rect.origin isFlexibleHeight:isHeight];
    currentRect.size = [self sizeWithOriginalSize:rect.size isFlexibleHeight:isHeight];
    
    return currentRect;
}


+ (CGPoint)pointWithOriginalPoint:(CGPoint)point isFlexibleHeight:(BOOL)isHeight {
    CGPoint currentPoint = CGPointZero;
    currentPoint.x = point.x * Flexible_W;
    
    if (isHeight) {
        currentPoint.y = point.y * Flexible_H;
    } else {
        currentPoint.y = point.y * Flexible_W;
    }
    return currentPoint;
}

+ (CGSize)sizeWithOriginalSize:(CGSize)size isFlexibleHeight:(BOOL)isHeight {
    CGSize currentSize = CGSizeZero;
    currentSize.width = size.width * Flexible_W;
    
    if (isHeight) {
        currentSize.height = size.height * Flexible_H;
    } else {
        currentSize.height = size.height * Flexible_W;
    }
    return currentSize;
}

//文字
+ (CGFloat)floatWithOriginalFloat:(CGFloat)originalFloat isFlexibleHeight:(BOOL)isHeight {
    if (isHeight) {
        return originalFloat * Flexible_H;
    } else {
        return originalFloat * Flexible_W;
    }
}

+ (void)topView:(UIView *)topview backButton:(UIButton *)backButton nameLabel:(UILabel *)nameLabel{
    if (SCREEN_H < 500 ) {
        topview.frame = [RenTool rectWithOriginalRect:CGRectMake(0, 20, Original_W, 44) isFlexibleHeight:NO];
    }else{
        topview.frame = CGRectMake(0, 20, SCREEN_W, 44);
    }
    topview.backgroundColor = RGBA(45, 174, 251, 1);
    
    //返回键
    backButton.frame = [RenTool rectWithOriginalRect:CGRectMake(0, 0, 60, 44) isFlexibleHeight:NO];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [topview addSubview:backButton];
    //名称
    nameLabel.frame = CGRectMake(SCREEN_W/2 - [RenTool floatWithOriginalFloat:50 isFlexibleHeight:NO]/2, 27, [RenTool floatWithOriginalFloat:100 isFlexibleHeight:NO], 30);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:[RenTool floatWithOriginalFloat:15 isFlexibleHeight:YES]];
}

+ (UIAlertController *)warmingString:(NSString *)string contentString:(NSString *)contentString sureString:(NSString *)sureString andTwo:(NSString *)two andblock:(void(^)())myblock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:contentString preferredStyle:UIAlertControllerStyleAlert];

    // 1  无  0两个 其它一个

    if ([two isEqualToString:@"1"]) {
        if (sureString.length != 0) {
            UIAlertAction  *action = [UIAlertAction actionWithTitle:sureString style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }else if ([two isEqualToString:@"0"]){
        UIAlertAction  *action = [UIAlertAction actionWithTitle:sureString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (myblock) {
                myblock();
            }
        }];
        [alert addAction:action];
        UIAlertAction  *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionTwo];
    }else{
        if (sureString.length == 0) {
            sureString = @"";
        }
        UIAlertAction  *action = [UIAlertAction actionWithTitle:sureString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (myblock) {
                myblock();
            }
        }];
        [alert addAction:action];
    }
    
    return alert;
}

+ (UIView *)getActivityMethod{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 50, SCREEN_H/2 - 50, 100, 100)];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(50, 50);
    [view addSubview:activity];
    activity.color = [UIColor whiteColor];
    [activity startAnimating];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 20)];
    label.text = @"正在加载";
    label.font = [UIFont systemFontOfSize:[RenTool floatWithOriginalFloat:15 isFlexibleHeight:NO]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}


@end
