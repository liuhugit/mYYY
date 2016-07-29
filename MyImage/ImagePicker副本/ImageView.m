//
//  ImageView.m
//  ihadhgsdkffsgdf
//
//  Created by 刘虎 on 16/7/25.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "ImageView.h"
#import "ImagesTableViewCell.h"
#import "PickerImageCollectionViewCell.h"
#import "Masonry.h"

#import "PrefixHeader_I.pch"

static ALAssetsLibrary *library = nil;

@interface ImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSMutableArray *_allArray;//所有
    NSMutableArray *_scrollArray;//选中
    int a;//预览判断
    
    NSMutableDictionary *dic;
    
    NSMutableArray *_nameArray;//图片的组数名称
    NSMutableArray *_groupArray;//图片的组数
}

@property (nonatomic,strong)UICollectionView *allImageCollectionView;

@property (nonatomic,strong)UICollectionView *scrollCollectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *allflowLayout;

@property (nonatomic,strong)UICollectionViewFlowLayout *scrollFlowLayout;

@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UILabel *numLabel;//上方图片数量

@property (nonatomic,strong)UIButton *nameLabel;//上方名称

@property (nonatomic,strong)UIButton *backButton;//返回

@property (nonatomic,strong)UITableView *imagesNameTableView;

@property (nonatomic,strong)UIView *tableBackgroundView;//tableview的背景

@end

@implementation ImageView

+ (ALAssetsLibrary *)defauliAssetsLibrary{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc]init];
    });
    return library;
}

-(void)drawRect:(CGRect)rect{
    a = 0;
    _allArray = [NSMutableArray array];
    dic = [NSMutableDictionary dictionary];
    _scrollArray = [NSMutableArray array];
    _groupArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    [self addSubview:self.scrollCollectionView];
    [self addSubview:self.allImageCollectionView];
    [self.allImageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_H - 64 - SCALE_W(44)));
    }];
    [self.scrollCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_H - 64 - SCALE_W(44)));
    }];
    [self initializeUserInterface];
}

- (void)initializeUserInterface{
    
    __weak typeof (self) weaks = self;
    ALAssetsLibrary *sets = [ImageView defauliAssetsLibrary];
    [sets enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [_groupArray addObject:group];
            [_nameArray addObject:[group valueForProperty:ALAssetsGroupPropertyName]];
            [_nameLabel setTitle:_nameArray[0] forState:UIControlStateNormal];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //通过这个可以知道相册的名字，从而也可以知道安装的部分应用
                //例如 Name:QQ, Type:Album, Assets count:1
                [_groupArray[0] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        [_allArray addObject:result];
                        if (_allArray.count > 0) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [weaks.allImageCollectionView reloadData];
                            });
                        }
                    }
                }];

            });
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found!");
    }];
    
    NSArray *titleArray = @[@"预览",@"完成"];
    NSArray *colorArray = @[[UIColor colorWithWhite:0.7 alpha:1],RGBA(70, 172, 68, 1)];
    //下方button
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    bottomView.layer.borderWidth = 1;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCREEN_H - SCALE_W(44));
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCALE_W(44)));
    }];
    
    
    
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:colorArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:SCALE_W(15)];
        button.tag = 3453463 + i;
        [button addTarget:self action:@selector(action_complented:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView).offset(0);
            make.left.equalTo(bottomView).offset(10 + i * (SCREEN_W - SCALE_W(60)));
            make.size.mas_equalTo(CGSizeMake(SCALE_W(50),SCALE_W(44)));
        }];
    }
    
    //完成左边数字
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.backgroundColor = RGBA(70, 172, 68, 1);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.layer.cornerRadius = SCALE_W(10);
    self.numberLabel.font = [UIFont systemFontOfSize:13];
    self.numberLabel.hidden = YES;
    [bottomView addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(11);
        make.left.equalTo(bottomView).offset(SCREEN_W - SCALE_W(80));
        make.size.mas_equalTo(CGSizeMake(SCALE_W(20), SCALE_W(20)));
    }];
    
    
    //上方图片数量
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:SCALE_W(17)];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.hidden = YES;
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCALE_W(30)));
    }];
    
    //名称button
    _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nameLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nameLabel setImage:[UIImage imageNamed:@"shang.png"] forState:UIControlStateNormal];
    [_nameLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    _nameLabel.selected = NO;
    [_nameLabel addTarget:self action:@selector(action_chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCALE_W(30)));
    }];
    
    //返回
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(action_backButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    //tableview的背景
    
    _tableBackgroundView = [[UIView alloc]init];
    _tableBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    _tableBackgroundView.hidden = YES;
    [self addSubview:_tableBackgroundView];
    [_tableBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_H - 64));
    }];
    //添加tableview
    [_tableBackgroundView addSubview:self.imagesNameTableView];
    
    [self.imagesNameTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableBackgroundView).offset(0);
        make.left.equalTo(_tableBackgroundView).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCALE_W(300)));
    }];
    
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_removeView)];
    backgroundTap.delegate = self;
    [_tableBackgroundView addGestureRecognizer:backgroundTap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

//背景隐藏
- (void)action_removeView{
    [_nameLabel setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
    _tableBackgroundView.hidden = YES;
    __weak typeof (self) weaks = self;
    if (_allArray.count == 0) {
        [_groupArray[0] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [_allArray addObject:result];
                [weaks.allImageCollectionView reloadData];
            }
        }];
    }
}

//返回
- (void)action_backButton{
    [self removeFromSuperview];
}

//选择相册
- (void)action_chooseButton:(UIButton *)sender{
//    sender.selected = !sender.selected;
    if (!sender.selected) {
        [_nameLabel setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
        _allArray = [NSMutableArray array];
        _tableBackgroundView.hidden = NO;
        [self.imagesNameTableView reloadData];
        sender.selected = YES;
    }else{
        _allArray = [NSMutableArray array];
        sender.selected = YES;
        _tableBackgroundView.hidden = NO;
        [self.imagesNameTableView reloadData];
    }
    
}


- (void)action_complented:(UIButton *)sender{
    switch (sender.tag) {
        case 3453463:{//预览
            if (_scrollArray.count > 0) {
                a = 1;
                _backButton.hidden = YES;
                _nameLabel.hidden = YES;
                _numLabel.hidden = NO;
                [self insertSubview:self.allImageCollectionView belowSubview:self.scrollCollectionView];
                [self.scrollCollectionView reloadData];
            }
        }break;
        case 3453463 + 1:{//完成
            if (_myImageBlcok) {
                _myImageBlcok(_scrollArray);
            }
            if (_scrollArray.count > 0) {
                [self removeFromSuperview];
            }
        }break;
        default:
            break;
    }
}

#pragma  mark -- collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (a == 1) {
        return _scrollArray.count;
    }else{
        return _allArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 87834) {
        PickerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"allCell" forIndexPath:indexPath];
        ALAsset *result = _allArray[indexPath.row];
        cell.allImageView.image = [UIImage imageWithCGImage:result.thumbnail];
        cell.allImageView.hidden = NO;
        cell.scrollImageView.hidden = YES;
        cell.cellView.hidden = YES;
        cell.selectedButton.hidden = NO;
        NSString *cellString = [NSString stringWithFormat:@"%ld",indexPath.row];
        if ([dic[cellString]integerValue] == 0) {
            cell.buttonImage.image = [UIImage imageNamed:@"bai"];
            cell.selectedButton.selected = NO;
        }else{
            cell.buttonImage.image = [UIImage imageNamed:@"lv"];
            cell.selectedButton.selected = YES;
        }
        cell.selectedButton.tag = 3895296 + indexPath.row;
        [cell.selectedButton addTarget:self action:@selector(action_imageButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        PickerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scrollCell" forIndexPath:indexPath];
        cell.allImageView.hidden = YES;
        cell.selectedButton.hidden = YES;
        cell.scrollImageView.hidden = NO;
        cell.cellView.hidden = NO;
        if (a == 1) {
            ALAsset *result = _scrollArray[indexPath.row];
            cell.scrollImageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.scrollImageView.image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
            _numLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1,_scrollArray.count];
        }else{
            ALAsset *result = _allArray[indexPath.row];
            cell.scrollImageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.scrollImageView.image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
            
            _numLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1,_allArray.count];
        }
        return cell;
    }
}


- (void)action_imageButton:(UIButton *)sender{
    UIButton *yulanButton = [self viewWithTag:3453463];
    UIView *view = sender.superview;
    ALAsset *result = _allArray[sender.tag - 3895296];
    PickerImageCollectionViewCell *cell = (PickerImageCollectionViewCell *)view.superview;
    cell.selectedButton.selected = !cell.selectedButton.selected;
    if (cell.selectedButton.selected) {
        cell.buttonImage.image = [UIImage imageNamed:@"lv"];
        [dic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",sender.tag - 3895296]];
        [_scrollArray addObject:result];
    }else{
        cell.buttonImage.image = [UIImage imageNamed:@"bai"];
        [dic setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",sender.tag - 3895296]];
        [_scrollArray removeObject:result];
    }
    if (_scrollArray.count > 0) {
        self.numberLabel.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",_scrollArray.count];
        [yulanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [yulanButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        self.numberLabel.hidden = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 87834) {
        _backButton.hidden = YES;
        _nameLabel.hidden = YES;
        [self insertSubview:self.allImageCollectionView belowSubview:self.scrollCollectionView];
        [self.scrollCollectionView reloadData];
        [self.scrollCollectionView setContentOffset:CGPointMake(indexPath.row * SCREEN_W, 0) animated:NO];
        _numLabel.hidden = NO;
    }else{
        _backButton.hidden = NO;
        _nameLabel.hidden = NO;
        _numLabel.hidden = YES;
        [self insertSubview:self.scrollCollectionView belowSubview:self.allImageCollectionView];
        [self.scrollCollectionView setContentOffset:CGPointMake(0, 64) animated:NO];
        a = 0;
        [self.allImageCollectionView reloadData];
    }
}

- (UICollectionViewFlowLayout *)allflowLayout{
    if (!_allflowLayout) {
        _allflowLayout = [[UICollectionViewFlowLayout alloc]init];
        _allflowLayout = [[UICollectionViewFlowLayout alloc]init];
        _allflowLayout.minimumInteritemSpacing = 5;
        _allflowLayout.minimumLineSpacing = 5;
        _allflowLayout.itemSize = CGSizeMake(350/4, 350/4);
        _allflowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    }
    return _allflowLayout;
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


- (UICollectionView *)allImageCollectionView{
    if (!_allImageCollectionView) {
        _allImageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64 - 44) collectionViewLayout:self.allflowLayout];
        [_allImageCollectionView registerClass:[PickerImageCollectionViewCell class] forCellWithReuseIdentifier:@"allCell"];
        _allImageCollectionView.delegate = self;
        _allImageCollectionView.dataSource = self;
        _allImageCollectionView.tag = 87834;
        _allImageCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _allImageCollectionView;
}

- (UICollectionView *)scrollCollectionView{
    if (!_scrollCollectionView) {
        _scrollCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64 - 44) collectionViewLayout:self.scrollFlowLayout];
        _scrollCollectionView.delegate = self;
        _scrollCollectionView.dataSource = self;
        _scrollCollectionView.showsVerticalScrollIndicator = YES;
        _scrollCollectionView.showsHorizontalScrollIndicator = NO;
        _scrollCollectionView.pagingEnabled = YES;
        [_scrollCollectionView registerClass:[PickerImageCollectionViewCell class] forCellWithReuseIdentifier:@"scrollCell"];
    }
    return _scrollCollectionView;
}

#pragma mark -- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALE_W(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableBackgroundView.hidden = YES;
    __weak typeof (self) weaks = self;
    [_groupArray[indexPath.row] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [_allArray addObject:result];
            [weaks.allImageCollectionView reloadData];
        }
    }];
    [_nameLabel setTitle:_nameArray[indexPath.row] forState:UIControlStateNormal];
    [_nameLabel setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (!cell) {
        cell = [[ImagesTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableCell"];
    }
    [_groupArray[indexPath.row] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            cell.firstImage.image = [UIImage imageWithCGImage:result.thumbnail];
        }
    }];
    ALAssetsGroup *group = _groupArray[indexPath.row];
    cell.imageLabel.text = [NSString stringWithFormat:@"%@(%ld)",_nameArray[indexPath.row],(long)group.numberOfAssets];
    return cell;
}


- (UITableView *)imagesNameTableView{
    if (!_imagesNameTableView) {
        _imagesNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 300) style:UITableViewStylePlain];
        _imagesNameTableView.delegate = self;
        _imagesNameTableView.dataSource = self;
        _imagesNameTableView.backgroundColor = [UIColor whiteColor];
    }
    return _imagesNameTableView;
}

@end
