//
//  CFPhotoPickerPhotoAlbumChooseViewTableViewCell.m
//  FrameworkTest
//
//  Created by 曹飞 on 2017/7/29.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import "CFPhotoPickerPhotoAlbumChooseViewTableViewCell.h"

@implementation CFPhotoPickerPhotoAlbumChooseViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeInterFace];
    }
    return self;
}

- (void)initializeInterFace {
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleLb];
    //imageV constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageV]" options:0 metrics:nil views:@{@"imageV":self.imageV}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageV]-0-|" options:0 metrics:nil views:@{@"imageV":self.imageV}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    [self.imageV addConstraint:[NSLayoutConstraint constraintWithItem:self.imageV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageV attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    //label constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLb attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLb attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.imageV attribute:NSLayoutAttributeRight multiplier:1 constant:15]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- lazy

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:17];
        _titleLb.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _titleLb;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.clipsToBounds = true;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _imageV;
}

@end
