//
//  LXCPhotoViewController.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXCImageScrollView.h"

@interface LXCPhotoViewController : UIViewController 
@property (nonatomic, copy)NSArray *imagePaths;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet LXCImageScrollView *scrollView;
+ (LXCPhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex withSegueName:(NSString *)segueName andImagePaths:(NSArray *)imagePaths;
- (NSInteger)pageIndex;

@end
