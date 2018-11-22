//
//  LXCMedia.h
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/26.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, MediaType)
{
    JPG,PNG,MP4,DIC,TPK,MOV,HTML,PLIST,PDF,TXT,DOC,PPT,XLS
};

@interface LXCMedia : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,   copy) NSString* title;
@property (nonatomic, assign) MediaType type;
@property (nonatomic,   copy) NSString* path;
-(LXCMedia*)initWithIndex:(NSInteger)index title:(NSString*)title type:(MediaType)type path:(NSString*)path;
+(NSString*)relativeDir2AbsDir:(NSString*)aString;
+(LXCMedia*)getMediaFromArray:(NSArray*)mediaArray WithTitle:(NSString*)title;
+(NSMutableArray*)getMediasAtDir:(NSString*)dir HasIndex:(BOOL)hasIndex;
-(NSMutableArray*)getMediaHasIndex:(BOOL)hasIndex;
@end
