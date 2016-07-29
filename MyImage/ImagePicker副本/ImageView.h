//
//  ImageView.h
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/25.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ImageView : UIView

@property (nonatomic,copy)void(^myImageBlcok)(NSMutableArray *);
+ (ALAssetsLibrary *)defauliAssetsLibrary;
@end
