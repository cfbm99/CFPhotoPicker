//
//  CFPhotoPickerPhotoResource.m
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import "CFPhotoPickerPhotoResource.h"
#import "CFPhotoPickerPhotoAlbumModel.h"

@implementation CFPhotoPickerPhotoResource

+ (NSArray *)requestForPhotoResource {
    /*
     case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
     case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
     case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
     case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
     case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
     case AlbumMyPhotoStream //用户的 iCloud 照片流
     case AlbumCloudShared //用户使用 iCloud 共享的相册
     case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
     case SmartAlbumPanoramas //相机拍摄的全景照片
     case SmartAlbumVideos //相机拍摄的视频
     case SmartAlbumFavorites //收藏文件夹
     case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
     case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
     case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
     case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
     case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
     case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
     case Any //包含所有类型
     */
    NSMutableArray *photosCollectionArray = [NSMutableArray array];
    
    PHFetchResult *roll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:@"相机胶卷" phAssetCollection:roll.lastObject];
    PHFetchResult *quanjing = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas options:nil];
    [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:@"全景照片" phAssetCollection:quanjing.lastObject];
    PHFetchResult *shoucang = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:@"个人收藏" phAssetCollection:shoucang.lastObject];
    PHFetchResult *zuijintianjia = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:@"最近添加" phAssetCollection:zuijintianjia.lastObject];
    PHFetchResult *screenshots = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:@"屏幕截图" phAssetCollection:screenshots.lastObject];
    PHFetchResult *customAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *assets in customAlbum) {
        [self photoAlbumModelArray:photosCollectionArray addCFPhotoPickerPhotoAlbumModelWithTitle:assets.localizedTitle phAssetCollection:assets];
    }
    return photosCollectionArray;
}

+ (void)photoAlbumModelArray:(NSMutableArray *)array addCFPhotoPickerPhotoAlbumModelWithTitle:(NSString *)title phAssetCollection:(PHAssetCollection *)phAssetCollection {
    if (phAssetCollection) {
        [array addObject:[[CFPhotoPickerPhotoAlbumModel alloc]initWithPhotoAlbumName:title phAssetCollection:phAssetCollection]];
    }
}

+ (NSArray *)fetchAllPhotoAlbums {
    PHFetchResult  *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *phAlbumModels = [NSMutableArray array];
    for (PHAssetCollection *phCollection in smartAlbums) {
        NSString *title = phCollection.localizedTitle;
        if ([title isEqualToString:@"相机胶卷"] || [title isEqualToString:@"全景照片"] || [title isEqualToString:@"个人收藏"] || [title isEqualToString:@"最近添加"] || [title isEqualToString:@"屏幕快照"]) {
            [phAlbumModels addObject:[[CFPhotoPickerPhotoAlbumModel alloc]initWithPhotoAlbumName:title phAssetCollection:phCollection]];
        }
    }
    [phAlbumModels sortUsingComparator:^NSComparisonResult(CFPhotoPickerPhotoAlbumModel * _Nonnull obj1, CFPhotoPickerPhotoAlbumModel *  _Nonnull obj2) {
        return [@(obj2.phAssetModels.count) compare:@(obj1.phAssetModels.count)];
    }];
    for (PHAssetCollection *phCollection in userAlbums) {
        NSString *title = phCollection.localizedTitle;
        [phAlbumModels addObject:[[CFPhotoPickerPhotoAlbumModel alloc]initWithPhotoAlbumName:title phAssetCollection:phCollection]];
    }
    return phAlbumModels;
}


@end
