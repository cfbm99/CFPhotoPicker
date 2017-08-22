//
//  CFPhotoPickerBrowse.h
//  FrameworkTest
//
//  Created by 曹飞 on 2017/7/30.
//  Copyright © 2017年 caofei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFPhotoPickerBrowsePhotoView.h"

typedef void(^CFPhotoPickerBrowseBlock)(NSMutableArray *selectedItems);

@interface CFPhotoPickerBrowse : UIViewController

@property (nonatomic, copy) CFPhotoPickerBrowseBlock vcDismissBlock;

+ (instancetype)cfPhotoPickerBrowseWithItems:(NSArray<CFPhotoPickerPHAssetModel *> *)items  scrollToIndex:(NSInteger)index maxSelectNum:(NSInteger)maxSelectNum selectedItems:(NSArray<CFPhotoPickerPHAssetModel *> *)selectedItems;

@end
