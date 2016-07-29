//
//  ImageCollectionViewCell.m
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/25.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "PickerImageCollectionViewCell.h"
#import "Masonry.h"
#import "RenTool.h"
@implementation PickerImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.allImageView];
        [self.contentView addSubview:self.cellView];
        [self.cellView addSubview:self.scrollImageView];
        [self.contentView addSubview:self.selectedButton];
        [self.selectedButton addSubview:self.buttonImage];
        
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(5);
            make.size.mas_equalTo([RenTool sizeWithOriginalSize:CGSizeMake(40, 40) isFlexibleHeight:NO]);
        }];
        
        [self.buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedButton).offset(5);
            make.left.equalTo(self.selectedButton).offset(10);
            make.size.mas_equalTo([RenTool sizeWithOriginalSize:CGSizeMake(20, 20) isFlexibleHeight:NO]);
        }];
    }
    return self;
}

- (UIImageView *)allImageView{
    if (!_allImageView) {
        _allImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _allImageView;
}

- (UIImageView *)scrollImageView{
    if (!_scrollImageView) {
        _scrollImageView = [[UIImageView alloc]initWithFrame:[RenTool rectWithOriginalRect:CGRectMake(0, 80, Original_W, 300) isFlexibleHeight:NO]];
    }
    return _scrollImageView;
}

- (UIView *)cellView{
    if (!_cellView) {
        _cellView = [[UIView alloc]initWithFrame:self.bounds];
        _cellView.backgroundColor = [UIColor blackColor];
    }
    return _cellView;
}

- (UIButton *)selectedButton{
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _selectedButton;
}

- (UIImageView *)buttonImage{
    if (!_buttonImage) {
        _buttonImage = [[UIImageView alloc]init];
    }
    return _buttonImage;
}

@end
