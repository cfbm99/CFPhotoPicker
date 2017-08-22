//
//  CFPhotoPickerCameraPreview.m
//  FrameworkTest
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import "CFPhotoPickerCameraPreview.h"

@implementation CFPhotoPickerCameraPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.previewImgV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewImgV.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) / 2, CGRectGetWidth(self.contentView.frame) / 2);
    self.previewImgV.center = self.contentView.center;
}

#pragma mark -- lazy

- (UIImageView *)previewImgV {
    if (!_previewImgV) {
        _previewImgV = [[UIImageView alloc]init];
        _previewImgV.contentMode = UIViewContentModeScaleAspectFill;
        _previewImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"CFPhotoPickerBundle.bundle/相机"]];
        _previewImgV.clipsToBounds = true;
    }
    return _previewImgV;
}

@end
