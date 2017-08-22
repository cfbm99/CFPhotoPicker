//
//  CFPhotoPickerBrowsePhotoView.h
//  hqlsoa
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFPhotoPickerPHAssetModel.h"

@protocol CFPhotoPickerBrowsePhotoViewDelegate <NSObject>

- (void)didSingleTapTheViewWithIndex:(NSInteger)index;

@end

@interface CFPhotoPickerBrowsePhotoView : UICollectionViewCell

@property (nonatomic, strong)CFPhotoPickerPHAssetModel *item;
@property (nonatomic, weak) id<CFPhotoPickerBrowsePhotoViewDelegate> delegate;

@end
