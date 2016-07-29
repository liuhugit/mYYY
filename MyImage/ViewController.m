//
//  PublishDynamicViewController.m
//  RRB
//
//  Created by 刘虎 on 16/6/29.
//  Copyright © 2016年 钟翠云. All rights reserved.
//

#import "ViewController.h"
#import "ImageView.h"
#import "ImagespickerCollectionViewCell.h"
#import "Masonry.h"
#import "NextButton.h"
#import "PrefixHeader_I.pch"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    NSMutableArray *_allImageArray;
    int a;
}

@property (strong, nonatomic) NSMutableArray *photos;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)UICollectionView *scrollCollectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *scrollFlowLayout;

@property (nonatomic,strong)UIView *backGroundView;//背景view

@property (nonatomic,strong)UILabel *topLabel;//顶部数字

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    a  = 0;
    _allImageArray = [NSMutableArray array];
    [self initializeUserinterface];
    
}


//退出
- (void)action_tui{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initializeUserinterface{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.top.equalTo(self.view).offset(74);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W - 10, SCALE_W(320)));
    }];
    
    //外框
    UIView *borderView = [[UIView alloc]init];
    borderView.layer.borderColor = [UIColor orangeColor].CGColor;
    borderView.layer.borderWidth = 1;
    borderView.layer.masksToBounds = YES;
    borderView.layer.cornerRadius = 5;
    [view addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(5);
        make.top.equalTo(view).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W - SCALE_W(20), SCALE_W(250)));
    }];
    //输入框
    UITextView *text = [[UITextView alloc]init];
    //    text.backgroundColor = [UIColor yellowColor];
    text.tag = 12389;
    [view addSubview:text];
    
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.top.equalTo(view).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W - SCALE_W(30), SCALE_W(140)));
    }];
    
    //添加照片
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pictureButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [pictureButton addTarget:self action:@selector(action_addPictBt) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pictureButton];
    
    [pictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(SCALE_W(25));
        make.top.equalTo(view).offset(SCALE_W(160));
        make.size.mas_equalTo(CGSizeMake(SCALE_W(60), SCALE_W(60)));
    }];
    
    //添加照片文字
    UILabel *addLabel = [[UILabel alloc]init];
    addLabel.font = [UIFont systemFontOfSize:SCALE_W(18)];
    addLabel.text = @"添加照片";
    addLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [view addSubview:addLabel];
    
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(SCALE_W(20));
        make.top.equalTo(view).offset(SCALE_W(220));
        make.size.mas_equalTo(CGSizeMake(SCALE_W(200), SCALE_W(30)));
    }];
    //确认发布
    UIButton *sureButton = [[NextButton new]sendVC:self rect:CGRectMake(0, 0, 0, 0) title:@"确认发布" titleColor:[UIColor whiteColor] buttonColor:[UIColor orangeColor] borderWith:0 borderColor:nil coration:5 and:^{
        NSLog(@"发布");
    }];
    [view addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(5);
        make.top.equalTo(view).offset(SCALE_W(270));
        make.size.mas_equalTo(CGSizeMake(SCREEN_W - SCALE_W(20), SCALE_W(40)));
    }];
    
    [view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(SCALE_W(93));
        make.top.equalTo(view).offset(SCALE_W(160));
        make.size.mas_equalTo(CGSizeMake(SCREEN_W - SCALE_W(112), SCALE_W(60)));
    }];
    
    //背景view添加
    _backGroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backGroundView.backgroundColor = [UIColor blackColor];
    _backGroundView.hidden = YES;
    [self.view addSubview:_backGroundView];
    
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_W, 30)];
    _topLabel.font = [UIFont systemFontOfSize:17];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = [UIColor whiteColor];
    [_backGroundView addSubview:_topLabel];
    
    [_backGroundView addSubview:self.scrollCollectionView];
    
}

//图片
- (void)action_addPictBt{
    ImageView *image = [[ImageView alloc]initWithFrame:self.view.bounds];
    image.myImageBlcok = ^(NSMutableArray *array){//返回选择了的图片数组
        if (array.count > 0) {
            [_allImageArray addObjectsFromArray:array];
            [self.collectionView reloadData];
        }
    };
    [self.view addSubview:image];
}




#pragma mark -- collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 83459384) {
        ImagespickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"publishCell" forIndexPath:indexPath];
        ALAsset *result = _allImageArray[indexPath.row];
        cell.smallImage.image = [UIImage imageWithCGImage:result.thumbnail];
        return cell;
    }else{
        ImagespickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"publishScrollCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ImagespickerCollectionViewCell alloc]init];
        }
        ALAsset *result = _allImageArray[indexPath.row];
        cell.bigImage.image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 83459384) {
        _topLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1,_allImageArray.count];
        _backGroundView.hidden = NO;
        [self.scrollCollectionView setContentOffset:CGPointMake(indexPath.row * SCREEN_W, 0) animated:NO];
        [self.scrollCollectionView reloadData];
    }else{
        _backGroundView.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger scrX = scrollView.contentOffset.x/SCREEN_W;
    _topLabel.text = [NSString stringWithFormat:@"%ld/%ld",scrX + 1,_allImageArray.count];
}


- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(SCALE_W(350/4), SCALE_W(350/4));
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tag = 83459384;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ImagespickerCollectionViewCell class] forCellWithReuseIdentifier:@"publishCell"];
    }
    return _collectionView;
}


- (UICollectionViewFlowLayout *)scrollFlowLayout{
    if (!_scrollFlowLayout) {
        _scrollFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _scrollFlowLayout.minimumLineSpacing = 0;
        _scrollFlowLayout.minimumInteritemSpacing = 0;
        _scrollFlowLayout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H - 64);
        _scrollFlowLayout.sectionInset = UIEdgeInsetsZero;
        _scrollFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _scrollFlowLayout;
}

- (UICollectionView *)scrollCollectionView{
    if (!_scrollCollectionView) {
        _scrollCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64) collectionViewLayout:self.scrollFlowLayout];
        _scrollCollectionView.delegate = self;
        _scrollCollectionView.dataSource = self;
        _scrollCollectionView.backgroundColor = [UIColor blackColor];
        [_scrollCollectionView registerClass:[ImagespickerCollectionViewCell class] forCellWithReuseIdentifier:@"publishScrollCell"];
        _scrollCollectionView.pagingEnabled = YES;
    }
    return _scrollCollectionView;
}


@end
