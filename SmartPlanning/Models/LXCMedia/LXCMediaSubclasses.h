//
//  LXCMediaSubclasses.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/21.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCMedia.h"

#pragma mark CityOverView
static NSString* CityOverview = @"CityOverview";
static NSString* CityOverview_mainvideo = @"mainvideo";
static NSString* CityOverview_scenes = @"scenes";

@interface LXCCityOverviewMedia : LXCMedia
+(NSMutableArray*)getMediasCityOverviewDir;
+(LXCMedia*)getCityOverviewVideo;
+(NSMutableArray*)getMediasCityOverviewSceneDir;
@end

#pragma mark GeneralPlan
static NSString *GeneralPlan_Path = @"GeneralPlan";
static NSString *GeneralPlan_001 = @"comprehensiveplanning";
static NSString *GeneralPlan_002 = @"comprehensiveplanning2";
static NSString *GeneralPlan_BgImage = @"bgnd";
static NSString *GeneralPlan_ThemeMap = @"thememap";
static NSString *GeneralPlan_Thumbnail = @"thumbnail";
static NSString *GeneralPlan_Description = @"description";

@interface LXCGeneralPlanMedia : LXCMedia
@property (copy, nonatomic) NSString *thumbnailPath;
@property (copy, nonatomic) NSString *themeDescription;
-(LXCGeneralPlanMedia*) initWithIndex: (NSUInteger)index
                                title: (NSString*)title
                                 type: (MediaType)type
                                 path: (NSString*)path
                        thumbnailPath: (NSString*)thumbnailPath
                     themeDescription: (NSString*)themeDescription;
+(LXCMedia*) getGeneralPlanBgImageWithIndex: (NSUInteger)index;
+(NSMutableArray*) getGeneralPlanListWithIndex:(NSUInteger)index;
@end
