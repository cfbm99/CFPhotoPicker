//
//  CFPhotoPicker.h
//  hqlsoa
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 hongqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFPhotoPickerDelegate <NSObject>

@optional
- (void)cfPhotoPickerDidSelectPhotoImages:(NSArray<UIImage *> *)images;

- (void)cfPhotoPickerDidSelectCameraImage:(UIImage *)image;

@end

@interface CFPhotoPicker : UIViewController

@property (nonatomic, weak) id<CFPhotoPickerDelegate> delegate;
@property (nonatomic, assign)NSInteger cfPhotoPickerMaxSelectNum;

@end
