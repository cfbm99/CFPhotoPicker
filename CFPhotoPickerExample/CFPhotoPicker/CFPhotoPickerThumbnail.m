//
//  CFPhotoPickerThumbnail.m
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPickerThumbnail.h"
#import "CFPhotoPickerPhotoResource.h"

@interface CFPhotoPickerThumbnail ()

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation CFPhotoPickerThumbnail

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.thumbnailImgV];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)setPhAssetModel:(CFPhotoPickerPHAssetModel *)phAssetModel {
    _phAssetModel = phAssetModel;
    _selectBtn.selected = phAssetModel.isSelected;
    phAssetModel.selectBtn = self.selectBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbnailImgV.frame = self.bounds;
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    self.selectBtn.frame = CGRectMake(width * 0.65, width * 0.05, width * 0.3, width * 0.3);
    self.selectBtn.layer.cornerRadius = width * 0.15;
    self.selectBtn.layer.masksToBounds = true;
}

- (void)respondsToSelectBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cfPhotoPickerThumbnail:selectedPhotoWithPHAssetModel:)] && [self.delegate respondsToSelector:@selector(theNumberOfHaveChosen)] && [self.delegate respondsToSelector:@selector(theMaximumNumberOfChoices)] && [self.delegate respondsToSelector:@selector(theMaximumNumberOfChoiceHasBeenReached)]) {
        if (btn.isSelected) {
            if ([self.delegate theNumberOfHaveChosen] < [self.delegate theMaximumNumberOfChoices]) {
                self.phAssetModel.selectedNum = [self.delegate theNumberOfHaveChosen] + 1;
                self.phAssetModel.selectBtn = btn;
            } else {
                [self.delegate theMaximumNumberOfChoiceHasBeenReached];
                btn.selected = false;
                return;
            }
        } else {
            self.phAssetModel.selectBtn = btn;
        }
        [self.delegate cfPhotoPickerThumbnail:self selectedPhotoWithPHAssetModel:self.phAssetModel];
    }
}

#pragma makr -- lazy

- (UIImageView *)thumbnailImgV {
    if (!_thumbnailImgV) {
        _thumbnailImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _thumbnailImgV.clipsToBounds = true;
        _thumbnailImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailImgV;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"CFPhotoPickerBundle.bundle/未选择"]] forState:UIControlStateNormal];
        _selectBtn.clipsToBounds = true;
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBtn addTarget:self action:@selector(respondsToSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
