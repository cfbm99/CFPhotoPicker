//
//  CFPhotoPicker.m
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPicker.h"
#import "CFPhotoPickerThumbnail.h"
#import "CFPhotoPickerCameraPreview.h"
#import "CFPhotoPickerPhotoAlbumChooseView.h"
#import "CFPhotoPickerBrowse.h"

@interface CFPhotoPicker ()<UICollectionViewDelegate, UICollectionViewDataSource, CFPhotoPickerPhotoAlbumChooseViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CFPhotoPickerThumbnailDelegate>

@property (nonatomic, strong) UICollectionView *photosCollectionView;
@property (nonatomic, strong) CFPhotoPickerPhotoAlbumChooseView *albumChooseView;
@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, strong) UIButton *titleSelectBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *maskBtn;
@property (nonatomic, strong) CFPhotoPickerPhotoAlbumModel *albumModel;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, strong) NSMutableArray<CFPhotoPickerPHAssetModel *> *selectedPHAssets;
@property (nonatomic, assign) BOOL hasInit;

@end

@implementation CFPhotoPicker

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeInterface];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateSubViewFrame];
}

#pragma mark -- initialize ui

- (void)initializeInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNav];
    [self addSubViews];
    [self requestForAuthorization];
}

- (void)requestForAuthorization {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.albumChooseView cfPhotoPickerPhotoAlbumChooseViewDidSelectRow:0];
                });
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self.albumChooseView cfPhotoPickerPhotoAlbumChooseViewDidSelectRow:0];
    }
}

- (void)addSubViews {
    [self.view insertSubview:self.albumChooseView belowSubview:self.customNav];
    [self.view insertSubview:self.photosCollectionView atIndex:0];
}

- (void)updateSubViewFrame {
    if (self.hasInit) {
        return;
    }
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat itemWidth = (width - 7) / 4;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    self.albumChooseView.frame = CGRectMake(0, 64 - width * 0.6 , width, width * 0.6);
    self.photosCollectionView.frame = CGRectMake(0, 64, width, height - 64);
    self.thumbnailSize = CGSizeMake(itemWidth * scale, itemWidth * scale);
    ((UICollectionViewFlowLayout *)self.photosCollectionView.collectionViewLayout).itemSize = CGSizeMake(itemWidth, itemWidth);
    self.hasInit = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"cfPicker dealloc");
}

#pragma mark -- creatNav {
- (void)createCustomNav {
    UIView *nav = [[UIView alloc]init];
    nav.backgroundColor = [UIColor whiteColor];
    nav.translatesAutoresizingMaskIntoConstraints = false;
    //shadow
    UIView *shadow = [[UIView alloc]init];
    shadow.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    shadow.translatesAutoresizingMaskIntoConstraints = false;
    //cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    cancelBtn.translatesAutoresizingMaskIntoConstraints =false;
    [cancelBtn addTarget:self action:@selector(respondsToCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    //sureBtn
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.enabled = false;
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [sureBtn addTarget:self action:@selector(respondsToSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.sureBtn = sureBtn;
    [self setSureBtnDisPlay];
    //selectedBtn
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [selectBtn addTarget:self action:@selector(respondsToSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.titleSelectBtn = selectBtn;
    //add subviews
    [self.view addSubview:nav];
    [nav addSubview:shadow];
    [nav addSubview:cancelBtn];
    [nav addSubview:sureBtn];
    [nav addSubview:selectBtn];
    self.customNav = nav;
    //add constraints
    //nav
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[nav]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nav)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[nav(==64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nav)]];
    //shadow
    [nav addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shadow]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shadow)]];
    [nav addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[shadow(==1)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shadow)]];
    //cancelBtn
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    //selectBtn
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:selectBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:selectBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    //sureBtn
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    [nav addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:nav attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
}

- (void)setSureBtnDisPlay {
    if (self.selectedPHAssets.count > 0) {
        [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",self.selectedPHAssets.count] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.sureBtn.enabled = true;
    } else {
        [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(0)"] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sureBtn.enabled = false;
    }
}

- (void)respondsToCancelBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)respondsToSureBtn:(UIButton *)btn {
    NSMutableArray *images = [NSMutableArray array];
    for (CFPhotoPickerPHAssetModel *model in self.selectedPHAssets) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.synchronous = true;
        [[PHImageManager defaultManager]requestImageDataForAsset:model.phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (![info[PHImageResultIsDegradedKey] boolValue] && imageData) {
                UIImage *fetchImg = [UIImage imageWithData:imageData];
                [images addObject:fetchImg];
            }
        }];
    }
    if ([self.delegate respondsToSelector:@selector(cfPhotoPickerDidSelectPhotoImages:)]) {
        [self.delegate cfPhotoPickerDidSelectPhotoImages:images];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)respondsToSelectBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        self.albumChooseView.hidden = false;
        [self.view insertSubview:self.maskBtn aboveSubview:self.photosCollectionView];
        [UIView animateWithDuration:0.3 animations:^{
            self.albumChooseView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.albumChooseView.frame));
        }];
    } else {
        [self.maskBtn removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            self.albumChooseView.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.albumChooseView.hidden = true;
        }];
    }
}

- (void)respondsToMaskBtn:(UIButton *)btn {
    [self.maskBtn removeFromSuperview];
    [self.titleSelectBtn setSelected:false];
    [UIView animateWithDuration:0.3 animations:^{
        self.albumChooseView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.albumChooseView.hidden = true;
    }];
}

#pragma mark -- CFPhotoPickerPhotoAlbumChooseViewDelegate

- (void)didSelectPhotoAlbumModel:(CFPhotoPickerPhotoAlbumModel *)photoAlbumModel {
    [self.maskBtn removeFromSuperview];
    [self.titleSelectBtn setTitle:photoAlbumModel.photoAlbumName forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.albumChooseView.transform = CGAffineTransformIdentity;
    }];
    self.albumModel = photoAlbumModel;
    NSMutableArray *phAssets = [NSMutableArray array];
    [self.imageManager stopCachingImagesForAllAssets];
    for (CFPhotoPickerPHAssetModel *model in self.albumModel.phAssetModels) {
        [phAssets addObject:model.phAsset];
    }
    [self.imageManager startCachingImagesForAssets:phAssets targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    //[self.imageManager stopCachingImagesForAssets:phAssets targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    [self.photosCollectionView reloadData];
}

#pragma mark -- <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModel.phAssetModels.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CFPhotoPickerCameraPreview *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFPhotoPickerCameraPreview" forIndexPath:indexPath];
        return cell;
    }
    CFPhotoPickerThumbnail *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFPhotoPickerThumbnail" forIndexPath:indexPath];
    cell.phAssetModel = self.albumModel.phAssetModels[indexPath.row - 1];
    cell.delegate = self;
    [self.imageManager requestImageForAsset:cell.phAssetModel.phAsset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            cell.thumbnailImgV.image = result;
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showCamera];
        return;
    }
    CFPhotoPickerBrowse *browse = [CFPhotoPickerBrowse cfPhotoPickerBrowseWithItems:self.albumModel.phAssetModels scrollToIndex:indexPath.row - 1 maxSelectNum:self.maximumSelectedNum selectedItems:self.selectedPHAssets];
    browse.vcDismissBlock = ^(NSMutableArray *selectedItems){
        self.selectedPHAssets = selectedItems;
        [self.photosCollectionView reloadData];
        [self setSureBtnDisPlay];
    };
    [self presentViewController:browse animated:false completion:nil];
}

#pragma mark -- CFPhotoPickerThumbnailDelegate

- (void)cfPhotoPickerThumbnail:(CFPhotoPickerThumbnail *)cfPhotoPickerThumbnail selectedPhotoWithPHAssetModel:(CFPhotoPickerPHAssetModel *)phAssetModel {
    if (phAssetModel.isSelected) {
        [self.selectedPHAssets addObject:phAssetModel];
    } else {
        [self.selectedPHAssets removeObject:phAssetModel];
        [self updateSelectedBtnsTitle];
    }
    [self setSureBtnDisPlay];
}

- (void)theMaximumNumberOfChoiceHasBeenReached {
    [self showReachedMaximumAlertView];
}

- (NSInteger)theNumberOfHaveChosen {
    return self.selectedPHAssets.count;
}

- (NSInteger)theMaximumNumberOfChoices {
    return self.maximumSelectedNum;
}

- (void)updateSelectedBtnsTitle {
    [self.selectedPHAssets enumerateObjectsUsingBlock:^(CFPhotoPickerPHAssetModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selectedNum = idx + 1;
        model.selectBtn = model.selectBtn;
    }];
}

- (void)showReachedMaximumAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%ld张照片",self.maximumSelectedNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -- show camera 

- (void)showCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:true completion:nil];
    } else {
        NSLog(@"no camera");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:false completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cfPhotoPickerDidSelectCameraImage:)]) {
            [self.delegate cfPhotoPickerDidSelectCameraImage:image];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"image save success");
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

#pragma mark -- lazy

- (UICollectionView *)photosCollectionView {
    if (!_photosCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        _photosCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosCollectionView.backgroundColor = [UIColor whiteColor];
        _photosCollectionView.alwaysBounceVertical = true;
        [_photosCollectionView registerClass:[CFPhotoPickerThumbnail class] forCellWithReuseIdentifier:@"CFPhotoPickerThumbnail"];
        [_photosCollectionView registerClass:[CFPhotoPickerCameraPreview class] forCellWithReuseIdentifier:@"CFPhotoPickerCameraPreview"];
        _photosCollectionView.delegate = self;
        _photosCollectionView.dataSource = self;
    }
    return _photosCollectionView;
}

- (CFPhotoPickerPhotoAlbumChooseView *)albumChooseView {
    if (!_albumChooseView) {
        _albumChooseView = [[CFPhotoPickerPhotoAlbumChooseView alloc]initWithFrame:CGRectZero];
        [_albumChooseView setHidden:true];
        _albumChooseView.delegate = self;
    }
    return _albumChooseView;
}

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskBtn.frame = self.view.bounds;
        _maskBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [_maskBtn addTarget:self action:@selector(respondsToMaskBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}

- (NSMutableArray<CFPhotoPickerPHAssetModel *> *)selectedPHAssets {
    if (!_selectedPHAssets) {
        _selectedPHAssets = [NSMutableArray array];
    }
    return _selectedPHAssets;
}

@end
