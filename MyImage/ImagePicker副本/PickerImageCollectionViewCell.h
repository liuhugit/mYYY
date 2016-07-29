//
//  ImageCollectionViewCell.h
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/25.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *allImageView;

@property (nonatomic,strong)UIImageView *scrollImageView;

@property (nonatomic,strong)UIView      *cellView;

@property (nonatomic,strong)UIButton    *selectedButton;

@property (nonatomic,strong)UIImageView *buttonImage;
@end
