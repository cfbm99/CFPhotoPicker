//
//  CFPhotoPickerPhotoAlbumModel.m
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPickerPhotoAlbumModel.h"

@implementation CFPhotoPickerPhotoAlbumModel

- (instancetype)initWithPhotoAlbumName:(NSString *)name phAssetCollection:(PHAssetCollection *)phAssetCollection
{
    self = [super init];
    if (self) {
        self.photoAlbumName = name;
        [self fetchPhAssetWithPhAssetCollection:phAssetCollection];
    }
    return self;
}

- (void)fetchPhAssetWithPhAssetCollection:(PHAssetCollection *)phAssetCollection {
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:option];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:result.count];
    for (PHAsset *asset in result) {
        CFPhotoPickerPHAssetModel *assetModel = [[CFPhotoPickerPHAssetModel alloc]initWithPhAsset:asset];
        [models addObject:assetModel];
    }
    self.phAssetModels = models;
}

@end
