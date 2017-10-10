//
//  CFPhotoPickerPhotoAlbumChooseView.h
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFPhotoPickerPhotoAlbumModel.h"
#import "CFPhotoPickerPhotoResource.h"

@protocol CFPhotoPickerPhotoAlbumChooseViewDelegate <NSObject>

- (void)didSelectPhotoAlbumModel:(CFPhotoPickerPhotoAlbumModel *)photoAlbumModel;

@end

@interface CFPhotoPickerPhotoAlbumChooseView : UIView

@property (nonatomic, copy)NSArray<CFPhotoPickerPhotoAlbumModel *> *photoAlbumModels;
@property (nonatomic, weak)id<CFPhotoPickerPhotoAlbumChooseViewDelegate> delegate;

@end
