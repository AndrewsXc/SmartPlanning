//
//  LXCCityOverviewViewController.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/25.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCBaseViewController.h"

@interface LXCCityOverviewViewController : LXCBaseViewController<iCarouselDelegate, iCarouselDataSource>
@property (strong, nonatomic) NSArray* imagePaths;
@end
