//
//  CFPhotoPickerBrowsePhotoView.m
//  hqlsoa
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPickerBrowsePhotoView.h"

@interface CFPhotoPickerBrowsePhotoView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, assign) CGFloat zoomScale;

@end

@implementation CFPhotoPickerBrowsePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterFace];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)initializeInterFace {
    [self addGestures];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageV];
}

- (void)setItem:(CFPhotoPickerPHAssetModel *)item {
    _item = item;
    [self.scrollView setZoomScale:1 animated:false];
    if (!item.phAsset) {
        return;
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager]requestImageForAsset:item.phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            [self resizeImageViewWithImage:result];
            self.imageV.image = result;
        }
    }];
}

- (void)resizeImageViewWithImage:(UIImage *)image {
    if (!image) { return; }
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat scale = image.size.width / image.size.height;
    CGFloat height = width / scale;
    CGFloat originY = (CGRectGetHeight(self.scrollView.frame) - height) / 2;
    if (originY < 0) {
        originY = 0;
    }
    self.imageV.frame = CGRectMake(0, originY, width, height);
    if (width > height) {
        self.scrollView.maximumZoomScale = CGRectGetHeight(self.scrollView.frame) / height + 1;
    }
}

#pragma mark -- gesture

- (void)addGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.contentView addGestureRecognizer:singleTap];
    [self.contentView addGestureRecognizer:doubleTap];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSingleTapTheViewWithIndex:)]) {
        NSIndexPath *indexPath = [((UICollectionView *)self.superview) indexPathForCell:self];
        [self.delegate didSingleTapTheViewWithIndex:indexPath.row];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.zoomScale <= 1) {
            CGFloat scale = self.scrollView.maximumZoomScale;
            if (CGRectGetHeight(self.scrollView.frame) / CGRectGetHeight(self.imageV.frame) > 2) {
                scale = CGRectGetHeight(self.scrollView.frame) / CGRectGetHeight(self.imageV.frame);
            }
            CGFloat width = CGRectGetWidth(self.scrollView.frame) / scale;
            CGFloat height = CGRectGetHeight(self.scrollView.frame) / scale;
            CGPoint tapPt = [tap locationInView:tap.view];
            [self.scrollView zoomToRect:CGRectMake(tapPt.x - (width / scale), tapPt.y - (height / scale), width, height) animated:true];
        } else {
            [self.scrollView setZoomScale:1 animated:true];
        }
    }
}

#pragma mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat centerX = scrollView.contentSize.width / 2;
    CGFloat centerY = scrollView.contentSize.height > CGRectGetHeight(scrollView.frame) ? scrollView.contentSize.height / 2 : CGRectGetHeight(scrollView.frame) / 2;
    self.imageV.center = CGPointMake(centerX, centerY);
}

#pragma mark -- lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.maximumZoomScale = 3;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = true;
        _imageV.userInteractionEnabled = true;
    }
    return _imageV;
}

@end
