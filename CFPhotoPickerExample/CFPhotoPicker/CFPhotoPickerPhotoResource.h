//
//  CFPhotoPickerPhotoResource.h
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "CFPhotoPickerPhotoAlbumModel.h"

@interface CFPhotoPickerPhotoResource : NSObject

//+ (NSArray *)requestForPhotoResource;

+ (NSArray<CFPhotoPickerPhotoAlbumModel *> *)fetchAllPhotoAlbums;

@end
