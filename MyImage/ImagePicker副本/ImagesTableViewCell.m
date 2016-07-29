//
//  ImagesTableViewCell.m
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/26.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "ImagesTableViewCell.h"
#import "RenTool.h"
@implementation ImagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.firstImage];
        [self.contentView addSubview:self.imageLabel];
    }
    return self;
}

- (UIImageView *)firstImage{
    if (!_firstImage) {
        _firstImage = [[UIImageView alloc]initWithFrame:[RenTool rectWithOriginalRect:CGRectMake(10, 5, 60, 60) isFlexibleHeight:NO]];
    }
    return _firstImage;
}

- (UILabel *)imageLabel{
    if (!_imageLabel) {
        _imageLabel = [[UILabel alloc]initWithFrame:[RenTool rectWithOriginalRect:CGRectMake(75, 20, 200, 30) isFlexibleHeight:NO]];
        _imageLabel.font = [UIFont systemFontOfSize:[RenTool floatWithOriginalFloat:15 isFlexibleHeight:NO]];
    }
    return _imageLabel;
}

@end
