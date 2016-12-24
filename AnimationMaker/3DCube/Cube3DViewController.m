//
//  Cube3DViewController.m
//  AnimationMaker
//
//  Created by DevinShine on 16/12/24.
//  Copyright © 2016年 DevinShine. All rights reserved.
//

#import "Cube3DViewController.h"
#import "Cube3DCell.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface Cube3DViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSArray *imageNameArray;
@end

@implementation Cube3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //init image name
    NSMutableArray *imageName = @[].mutableCopy;
    for (int i = 1;i <= 9; i++) {
        [imageName addObject:[NSString stringWithFormat:@"pic_%zd",i]];
    }
    _imageNameArray = imageName;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    _mainCollectionView.backgroundColor = [UIColor blackColor];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.scrollEnabled = YES;
    //注册Cell
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"Cube3DCell" bundle:nil] forCellWithReuseIdentifier:@"Cube3DCell"];
    
    [self.view addSubview:_mainCollectionView];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [operationQueue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.2];
        
        [NSThread sleepForTimeInterval:0.2];
        Cube3DCell *cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self startCubeAnimation:cell index:0];
        
        [NSThread sleepForTimeInterval:0.2];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [self startCubeAnimation:cell index:1];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [self startCubeAnimation:cell index:3];
        
        [NSThread sleepForTimeInterval:0.2];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [self startCubeAnimation:cell index:2];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        [self startCubeAnimation:cell index:4];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        [self startCubeAnimation:cell index:6];
        
        [NSThread sleepForTimeInterval:0.2];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        [self startCubeAnimation:cell index:5];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        [self startCubeAnimation:cell index:7];
        
        [NSThread sleepForTimeInterval:0.2];
        cell = (Cube3DCell *)[_mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        [self startCubeAnimation:cell index:8];
        
    }];
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageNameArray.count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cube3DCell";
    Cube3DCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.pictureImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%zd",indexPath.row + 1]];
    return cell;
}



#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(SCREEN_WIDTH/3-2,178);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *newImage = [UIImage imageNamed:@"pic_2"];
    CATransition *ca = [CATransition animation];
    ca.type = @"cube";
    ca.subtype =  kCATransitionFromRight;
    ca.duration = 1;
    
    Cube3DCell *cell = (Cube3DCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.pictureImageView.image = newImage;
    
    [cell.contentView.layer addAnimation:ca forKey:nil];
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)startCubeAnimation:(Cube3DCell *)cell
                     index:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *newImage = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%zd",index + 10]];
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
        ca.subtype =  kCATransitionFromRight;
        ca.duration = 1;
        
        cell.pictureImageView.image = newImage;
        
        [cell.contentView.layer addAnimation:ca forKey:nil];
    });
    
}

@end
