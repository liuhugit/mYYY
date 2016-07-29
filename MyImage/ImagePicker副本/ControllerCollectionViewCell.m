//
//  ControllerCollectionViewCell.m
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/25.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "ControllerCollectionViewCell.h"
#import "PrefixHeader_I.pch"
@implementation ControllerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.controllerImage];
        [self.contentView addSubview:self.controllerBigImage];
        
    }
    return self;
}

- (UIImageView *)controllerImage{
    if (!_controllerImage) {
        _controllerImage = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _controllerImage;
}


- (UIImageView *)controllerBigImage{
    if (!_controllerBigImage) {
        _controllerBigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCALE_W(100), SCREEN_W, SCALE_W(260))];
    }
    return _controllerBigImage;
}




@end
