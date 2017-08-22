//
//  CFPhotoPickerBrowseThumbnailView.m
//  FrameworkTest
//
//  Created by Apple on 2017/8/4.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import "CFPhotoPickerBrowseThumbnailView.h"

@implementation CFPhotoPickerBrowseThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.thumbnailImgV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbnailImgV.frame = self.contentView.bounds;
}

#pragma mark -- lazy

- (UIImageView *)thumbnailImgV {
    if (!_thumbnailImgV) {
        _thumbnailImgV = [[UIImageView alloc]init];
        _thumbnailImgV.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImgV.clipsToBounds = true;
    }
    return _thumbnailImgV;
}

@end
