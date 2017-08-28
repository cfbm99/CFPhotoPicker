//
//  CFPhotoPickerPhotoAlbumModel.h
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "CFPhotoPickerPHAssetModel.h"

@interface CFPhotoPickerPhotoAlbumModel : NSObject

@property (nonatomic, copy) NSString *photoAlbumName;
@property (nonatomic, copy) NSArray<CFPhotoPickerPHAssetModel *> *phAssetModels;

- (instancetype)initWithPhotoAlbumName:(NSString *)name phAssetCollection:(PHAssetCollection *)phAssetCollection;

@end
