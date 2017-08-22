//
//  CFPhotoPickerBrowse.m
//  FrameworkTest
//
//  Created by 曹飞 on 2017/7/30.
//  Copyright © 2017年 caofei. All rights reserved.
//

#define CFPhotoPickerBrowse_Width CGRectGetWidth(self.view.frame)
#define CFPhotoPickerBrowse_Height CGRectGetHeight(self.view.frame)

#import "CFPhotoPickerBrowse.h"

@interface CFPhotoPickerBrowse ()<UICollectionViewDataSource, CFPhotoPickerBrowsePhotoViewDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSInteger maxSelectNum;
@property (nonatomic, strong) UICollectionView *photoCollectionV;
@property (nonatomic, copy) NSArray<CFPhotoPickerPHAssetModel *> *items;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) CFPhotoPickerPHAssetModel *currentModel;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation CFPhotoPickerBrowse

+ (instancetype)cfPhotoPickerBrowseWithItems:(NSArray<CFPhotoPickerPHAssetModel *> *)items scrollToIndex:(NSInteger)index maxSelectNum:(NSInteger)maxSelectNum selectedItems:(NSMutableArray<CFPhotoPickerPHAssetModel *> *)selectedItems
{
    CFPhotoPickerBrowse *browse = [[CFPhotoPickerBrowse alloc]init];
    browse.items = items;
    browse.selectIndex = index;
    browse.selectedItems = [NSMutableArray arrayWithArray:selectedItems];
    browse.maxSelectNum = maxSelectNum;
    return browse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeInterFace];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateSubViewsFrame];
}

- (void)initializeInterFace {
    [self.view addSubview:self.photoCollectionV];
    [self createCustomNav];
    self.currentModel = self.items[self.selectIndex];
}

- (void)updateSubViewsFrame {
    self.photoCollectionV.frame = CGRectMake(0, 0, CFPhotoPickerBrowse_Width + 20, CFPhotoPickerBrowse_Height);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.photoCollectionV.collectionViewLayout;
    layout.itemSize = CGSizeMake(CFPhotoPickerBrowse_Width, CFPhotoPickerBrowse_Height);
    [self.photoCollectionV setContentOffset:CGPointMake((CFPhotoPickerBrowse_Width + 20) * self.selectIndex, 0) animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- createCustomNav {
- (void)createCustomNav {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CFPhotoPickerBundle" ofType:@"bundle"]];
    UIView *nav = [[UIView alloc]init];
    nav.frame = CGRectMake(0, 0, CFPhotoPickerBrowse_Width, 64);
    nav.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    //selectBtn
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"CFPhotoPickerBundle.bundle/导航栏未选择"] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(respondsToSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame = CGRectMake(CFPhotoPickerBrowse_Width - 30, 30, 22, 22);
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    selectBtn.layer.cornerRadius = 11;
    selectBtn.layer.masksToBounds = true;
    self.selectedBtn = selectBtn;
    [nav addSubview:selectBtn];
    //returnBtn
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"返回@2x" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(respondsToReturnBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.frame = CGRectMake(10, 30, 22, 22);
    [nav addSubview:returnBtn];
    [self.view addSubview:nav];
}

#pragma mark -- nav Btns events

- (void)respondsToSelectBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.selectedItems.count == self.maxSelectNum && btn.isSelected) {
        btn.selected = false;
        [self showReachedMaximumAlertView];
        return;
    }
    self.currentModel.selected = btn.isSelected;
    NSInteger selectNum = self.selectedItems.count + 1;
    self.currentModel.selectedNum = btn.isSelected ? selectNum : 0;
    if (btn.isSelected) {
         [self.selectedItems addObject:self.currentModel];
    } else {
         [self.selectedItems removeObject:self.currentModel];
    }
    [self setSelectedBtnWithIsSelected:btn.isSelected];
}

- (void)setSelectedBtnWithIsSelected:(BOOL)isSelected {
    self.selectedBtn.selected = isSelected;
    if (isSelected) {
        self.selectedBtn.backgroundColor = [UIColor colorWithRed:32.0 / 256 green:203.0 / 256 blue:106.0 / 256 alpha:1];
        [self.selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.selectedBtn setTitle:[NSString stringWithFormat:@"%ld",self.currentModel.selectedNum] forState:UIControlStateNormal];
    } else {
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"CFPhotoPickerBundle.bundle/导航栏未选择"] forState:UIControlStateNormal];
        [self.selectedBtn setTitle:nil forState:UIControlStateNormal];
        self.selectedBtn.backgroundColor = nil;
        [self updateSelectedModelsNum];
    }
}

- (void)updateSelectedModelsNum {
    [self.selectedItems enumerateObjectsUsingBlock:^(CFPhotoPickerPHAssetModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selectedNum = idx + 1;
    }];
}

- (void)respondsToReturnBtnBtn:(UIButton *)btn {
    if (self.vcDismissBlock) {
        self.vcDismissBlock(self.selectedItems);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)showReachedMaximumAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%ld张照片",self.maxSelectNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CFPhotoPickerBrowsePhotoView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFPhotoPickerBrowsePhotoView" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = self.items[indexPath.row];
    return cell;
}

#pragma mark -- scrollviewdelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x + CGRectGetWidth(self.photoCollectionV.frame) / 2;
    NSInteger index = (NSInteger)(offsetX / CGRectGetWidth(self.photoCollectionV.frame));
    self.currentModel = self.items[index];
    [self setSelectedBtnWithIsSelected:self.currentModel.isSelected];
}

#pragma mark -- CFPhotoPickerBrowseCollectionViewCellDelegate

- (void)didSingleTapTheViewWithIndex:(NSInteger)index {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -- lazy get - set

- (UICollectionView *)photoCollectionV {
    if (!_photoCollectionV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoCollectionV.alwaysBounceHorizontal = true;
        _photoCollectionV.pagingEnabled = true;
        [_photoCollectionV registerClass:[CFPhotoPickerBrowsePhotoView class] forCellWithReuseIdentifier:@"CFPhotoPickerBrowsePhotoView"];
        _photoCollectionV.dataSource = self;
        _photoCollectionV.delegate = self;
    }
    return _photoCollectionV;
}

@end
