//
//  CFPhotoPickerPhotoAlbumChooseView.m
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPickerPhotoAlbumChooseView.h"
#import "CFPhotoPickerPhotoAlbumChooseViewTableViewCell.h"


@interface CFPhotoPickerPhotoAlbumChooseView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *photoAlbumTableView;
@property (nonatomic, strong)NSArray<CFPhotoPickerPhotoAlbumModel *> *photoAlbumModels;
@property (nonatomic, assign)CGSize thumbnailSize;

@end

@implementation CFPhotoPickerPhotoAlbumChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.photoAlbumTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellWidth = CGRectGetWidth(self.frame) * 0.25;
    CGFloat scale = [UIScreen mainScreen].scale;
    self.thumbnailSize = CGSizeMake(cellWidth * scale, cellWidth * scale);
    self.photoAlbumTableView.frame = self.bounds;
}

- (void)cfPhotoPickerPhotoAlbumChooseViewDidSelectRow:(NSInteger)row {
    self.photoAlbumModels = [CFPhotoPickerPhotoResource fetchAllPhotoAlbums];
    [self.photoAlbumTableView reloadData];
    [self tableView:self.photoAlbumTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbumModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFPhotoPickerPhotoAlbumChooseViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFPhotoPickerPhotoAlbumChooseViewTableViewCell" forIndexPath:indexPath];
    cell.titleLb.text = self.photoAlbumModels[indexPath.row].photoAlbumName;
    [[PHImageManager defaultManager]requestImageForAsset:self.photoAlbumModels[indexPath.row].phAssetModels.firstObject.phAsset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            cell.imageV.image = result;
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([self.delegate respondsToSelector:@selector(didSelectPhotoAlbumModel:)]) {
        [self.delegate didSelectPhotoAlbumModel:self.photoAlbumModels[indexPath.row]];
    }
}

#pragma mark -- lazy

- (UITableView *)photoAlbumTableView {
    if (!_photoAlbumTableView) {
        _photoAlbumTableView = [[UITableView alloc]init];
        _photoAlbumTableView.tableFooterView = [UIView new];
        _photoAlbumTableView.delegate = self;
        _photoAlbumTableView.dataSource = self;
        [_photoAlbumTableView registerClass:[CFPhotoPickerPhotoAlbumChooseViewTableViewCell class] forCellReuseIdentifier:@"CFPhotoPickerPhotoAlbumChooseViewTableViewCell"];
        _photoAlbumTableView.estimatedRowHeight = 80;
    }
    return _photoAlbumTableView;
}

@end
