//
//  ViewController.m
//  CFPhotoPickerExample
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 cf. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import "CFPhotoPicker.h"

@interface ViewController ()<UICollectionViewDataSource, CFPhotoPickerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<UIImage *> *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = (CGRectGetWidth(self.view.frame) - 51) / 4;
    self.layout.itemSize = CGSizeMake(width, width);
    self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 10;
}

#pragma mark -- data source 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageV.image = [UIImage imageNamed:@"ic_添加"];
    } else {
        cell.imageV.image = self.images[indexPath.row - 1];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CFPhotoPicker *picker = [[CFPhotoPicker alloc]init];
        picker.delegate = self;
        picker.cfPhotoPickerMaxSelectNum = 9;
        [self presentViewController:picker animated:true completion:nil];
    }
}

#pragma mark -- cfphotopickerdelegate

- (void)cfPhotoPickerDidSelectPhotoImages:(NSArray<UIImage *> *)images {
    self.images = images;
    [self.collectionV reloadData];
}

- (void)cfPhotoPickerDidSelectCameraImage:(UIImage *)image {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
