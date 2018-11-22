//
//  LXCMediaSubclasses.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/21.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCMediaSubclasses.h"
#import <UIKit/UIKit.h>

#pragma mark CityOverView
@implementation LXCCityOverviewMedia
//
+(NSMutableArray*)getMediasCityOverviewDir{
    //    NSString* cityOverViewPath = @"CityOverview";
    return [LXCMedia getMediasAtDir:[LXCMedia relativeDir2AbsDir:CityOverview] HasIndex:NO];
}

+(LXCMedia*)getCityOverviewVideo{
    NSArray* coutl=[LXCCityOverviewMedia getMediasCityOverviewDir];
    return [LXCMedia getMediaFromArray:coutl WithTitle:CityOverview_mainvideo];
}

+(NSMutableArray*)getMediasCityOverviewSceneDir
{
    NSArray*coutl=[LXCCityOverviewMedia getMediasCityOverviewDir];
    return [LXCMedia getMediasAtDir:[LXCMedia getMediaFromArray:coutl WithTitle:CityOverview_scenes].path HasIndex:YES];
}
@end

#pragma mark GeneralPlan
@implementation LXCGeneralPlanMedia
-(LXCGeneralPlanMedia*) initWithIndex: (NSUInteger)index
                                title: (NSString*)title
                                 type: (MediaType)type
                                 path: (NSString*)path
                        thumbnailPath: (NSString*)thumbnailPath
                     themeDescription: (NSString*)themeDescription
{
    if (!(self=[super initWithIndex:index title:title type:type path:path])) {
        return nil;
    }
    self.thumbnailPath = thumbnailPath;
    self.themeDescription = themeDescription;
    return self;
}

+(NSMutableArray*)getGeneralPlanDirWithType:(NSString *)generalType
{
    //包含了bgnd 与各个文件夹
    //文件夹中包含缩略图与常规图
    return [LXCMedia getMediasAtDir:[[LXCMedia relativeDir2AbsDir:GeneralPlan_Path] stringByAppendingPathComponent:generalType]  HasIndex:YES];
}

+(LXCMedia*) getGeneralPlanBgImageWithIndex:(NSUInteger)index
{
    NSArray *generealPlanArray;
    if(0 == index)
        generealPlanArray = [LXCGeneralPlanMedia getGeneralPlanDirWithType:GeneralPlan_001];
    else if(1 == index)
        generealPlanArray = [LXCGeneralPlanMedia getGeneralPlanDirWithType:GeneralPlan_002];
    
    if([[UIScreen mainScreen] scale]>1.5)
    {
        LXCMedia *bgImage = [LXCMedia getMediaFromArray:generealPlanArray WithTitle:[GeneralPlan_BgImage stringByAppendingString:@"@2x"]];
        if(bgImage)
            return bgImage;
        NSLog(@"media warn: don't have a %@2x themeMap bgnd image ", GeneralPlan_BgImage);
    }
    return [LXCMedia getMediaFromArray:generealPlanArray WithTitle:GeneralPlan_BgImage];
}

+(NSMutableArray*) getGeneralPlanListWithIndex:(NSUInteger)index
{
    NSMutableArray *tmpList = [NSMutableArray array];
    NSMutableArray *resultList = [NSMutableArray array];

    if(0 == index)
        tmpList = [LXCGeneralPlanMedia getGeneralPlanDirWithType:GeneralPlan_001];
    else if(1 == index)
        tmpList = [LXCGeneralPlanMedia getGeneralPlanDirWithType:GeneralPlan_002];
    for(LXCMedia *tmp in tmpList)
    {
        if (tmp.index == 0) {
            [tmpList removeObject:tmp];
            break;
        }
    }
    
    for(NSUInteger i = 0; i < tmpList.count; ++i)
    {
        LXCMedia *tmp = tmpList[i];
        NSInteger index = tmp.index;
        NSString *title = tmp.title;
        NSMutableArray *gpOneTmpList= [tmp getMediaHasIndex:NO];
        LXCMedia *themeMap = [LXCMedia getMediaFromArray:gpOneTmpList WithTitle:GeneralPlan_ThemeMap];
        LXCMedia *thumbnailImage;
        if([[UIScreen mainScreen] scale]>1.5)
        {
            thumbnailImage = [LXCMedia getMediaFromArray:gpOneTmpList WithTitle:[GeneralPlan_Thumbnail stringByAppendingString:@"@2x"]];
            if(!thumbnailImage)
            {
                NSLog(@"media warn: don't have a %@2x themeMap thumbnail image ", GeneralPlan_BgImage);
            }
        }else
            thumbnailImage =[LXCMedia getMediaFromArray:gpOneTmpList WithTitle:GeneralPlan_Thumbnail];
        LXCMedia *descrp = [LXCMedia getMediaFromArray:gpOneTmpList WithTitle:GeneralPlan_Description];
        NSString *description = [NSString stringWithContentsOfFile:descrp.path encoding:NSUTF8StringEncoding error:nil];
        LXCGeneralPlanMedia *gpMedia = [[LXCGeneralPlanMedia alloc] initWithIndex:index
                                                                            title:title
                                                                             type:themeMap.type
                                                                             path:themeMap.path
                                                                    thumbnailPath:thumbnailImage.path
                                                                 themeDescription:description];
        [resultList addObject:gpMedia];
    }
    return resultList;
}
@end
