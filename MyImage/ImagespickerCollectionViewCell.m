//
//  ImagespickerCollectionViewCell.m
//  RRB
//
//  Created by 刘虎 on 16/7/26.
//  Copyright © 2016年 钟翠云. All rights reserved.
//

#import "ImagespickerCollectionViewCell.h"
#import "RenTool.h"
@implementation ImagespickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.smallImage];
        [self.contentView addSubview:self.bigImage];
    }
    return self;
}


- (UIImageView *)smallImage{
    if (!_smallImage) {
        _smallImage = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _smallImage;
}

- (UIImageView *)bigImage{
    if (!_bigImage) {
        _bigImage = [[UIImageView alloc]initWithFrame:[RenTool rectWithOriginalRect:CGRectMake(0, 50, Original_W, 460) isFlexibleHeight:NO]];
    }
    return _bigImage;
}

@end
