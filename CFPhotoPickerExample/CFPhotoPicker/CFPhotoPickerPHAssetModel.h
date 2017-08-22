//
//  CFPhotoPickerPHAssetModel.h
//  FrameworkTest
//
//  Created by 曹飞 on 2017/7/29.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface CFPhotoPickerPHAssetModel : NSObject

@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic, strong) UIButton *selectBtn;

- (instancetype)initWithPhAsset:(PHAsset *)phAsset;

@end
