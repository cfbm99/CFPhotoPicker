//
//  CFPhotoPickerThumbnail.h
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CFPhotoPickerPHAssetModel.h"

@class CFPhotoPickerThumbnail;

@protocol CFPhotoPickerThumbnailDelegate <NSObject>

- (void)cfPhotoPickerThumbnail:(CFPhotoPickerThumbnail *)cfPhotoPickerThumbnail selectedPhotoWithPHAssetModel:(CFPhotoPickerPHAssetModel *)phAssetModel;

- (void)theMaximumNumberOfChoiceHasBeenReached;

- (NSInteger)theNumberOfHaveChosen;

- (NSInteger)theMaximumNumberOfChoices;

@end

@interface CFPhotoPickerThumbnail : UICollectionViewCell

@property (nonatomic, strong)CFPhotoPickerPHAssetModel *phAssetModel;
@property (nonatomic, strong)UIImageView *thumbnailImgV;
@property (nonatomic, weak) id<CFPhotoPickerThumbnailDelegate> delegate;

@end
