# CFPhotoPicker
CFPhotoPicker是一款基于Photos框架的照片选择器，可以方便的在项目中使用。

https://github.com/cfbm99/CFPhotoPicker/blob/master/Resource/cfPhotoPickerGIf.gif

快速集成
=====
 1、添加库
 -----
拖拽PhotoBrowser文件夹到你的项目，导入头文件#import "CFPhotoPicker.h"

2、展示相册
```
\\self是控制器
CFPhotoPicker *picker = [[CFPhotoPicker alloc]init];
picker.delegate = self;
picker.cfPhotoPickerMaxSelectNum = 9;//设置最大照片选择数
[self presentViewController:picker animated:true completion:nil];
```
3、照片选择完成使用代理方法
```
//照片选择完成后点击确认按钮后执行
- (void)cfPhotoPickerDidSelectPhotoImages:(NSArray<UIImage *> *)images {
    
}
//使用相机照相后点击确认按钮后执行
- (void)cfPhotoPickerDidSelectCameraImage:(UIImage *)image {
    
}
```



