//
//  LXCBigPhotoViewController.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXCBigPhotoViewController : UIPageViewController<UIPageViewControllerDataSource>

@property (nonatomic, copy) NSArray *imagePaths;
@property (nonatomic, copy) NSString * segueName;
@property (nonatomic, assign) NSUInteger currentIndex;

@end
