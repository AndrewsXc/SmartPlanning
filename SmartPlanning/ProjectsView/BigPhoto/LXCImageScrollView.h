//
//  LXCImageScrollView.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXCImageScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString* segueName;
@property (nonatomic, copy) NSArray* imagePaths;
@property (nonatomic) CGSize imageSize;
-(NSUInteger)imageCount;
-(void)setMaxMinZoomScaleForCurrentBounds;
@end
