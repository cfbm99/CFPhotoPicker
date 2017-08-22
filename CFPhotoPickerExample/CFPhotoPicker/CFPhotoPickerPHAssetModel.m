//
//  CFPhotoPickerPHAssetModel.m
//  FrameworkTest
//
//  Created by 曹飞 on 2017/7/29.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import "CFPhotoPickerPHAssetModel.h"

@implementation CFPhotoPickerPHAssetModel

- (instancetype)initWithPhAsset:(PHAsset *)phAsset
{
    self = [super init];
    if (self) {
        self.phAsset = phAsset;
    }
    return self;
}

- (void)setSelectBtn:(UIButton *)selectBtn {
    _selected = selectBtn.isSelected;
    if (selectBtn.isSelected) {
        selectBtn.backgroundColor = [UIColor colorWithRed:32.0 / 256 green:203.0 / 256 blue:106.0 / 256 alpha:1];
        [selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [selectBtn setTitle:[NSString stringWithFormat:@"%ld",_selectedNum] forState:UIControlStateNormal];
        _selectBtn = selectBtn;
        [self btnAniamtion];
    } else {
        _selectedNum = 0;
        [selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"CFPhotoPickerBundle.bundle/未选择"]] forState:UIControlStateNormal];
        [selectBtn setTitle:nil forState:UIControlStateNormal];
        selectBtn.backgroundColor = nil;
        _selectBtn = nil;
    }
}

- (void)btnAniamtion {
    [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            _selectBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
            _selectBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2 animations:^{
            _selectBtn.transform = CGAffineTransformIdentity;
        }];
    } completion:nil];
}



@end
