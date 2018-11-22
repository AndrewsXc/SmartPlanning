//
//  LXCMedia.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/26.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCMedia.h"

@implementation LXCMedia

-(LXCMedia*)initWithIndex:(NSInteger) index
                    title:(NSString*) title
                     type:(MediaType) type
                     path:(NSString*) path{
    if(!(self = [super init])){
        return nil;
    }
    _index=index;
    _title=title;
    _type=type;
    _path=path;
    return self;
}

//获取文档目录"Library"
+(NSString*)getDocsDir{
   
    // Get the library directory
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * docsDir = [dirPaths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"appdata"];
}
// 相对路径转化为设备路径
+(NSString*)relativeDir2AbsDir:(NSString*)aString
{
    return  [[LXCMedia getDocsDir] stringByAppendingPathComponent:aString];
}

+(LXCMedia*)getMediaFromArray:(NSArray*)mediaArray WithTitle:(NSString*)title
{
    LXCMedia*result;
    title = [title stringByDeletingPathExtension];
    for (result in mediaArray)
    {
        if ([result.title isEqualToString:title]) {
            return result;
        }
    }
    NSLog(@"media error(getMediaFromArray):media with title:%@ dosen't exist !",title);
    return nil;
}
+(NSMutableArray*)getMediasAtDir:(NSString*)dir HasIndex:(BOOL)hasIndex{
    NSMutableArray* retArray = [[NSMutableArray alloc] init];
    NSFileManager*  fm =[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dir])
        return nil;
    
    NSArray* tmpArray = [fm contentsOfDirectoryAtPath:dir error:nil];
    for(NSString * path in tmpArray)
    {
        //跳过隐藏文件和隐藏文件夹
        if([[path lastPathComponent] hasPrefix:@"."])
            continue;
        NSInteger index;
        NSString* title;
        MediaType type;
        NSString* ext = [path pathExtension];
        if ([[ext lowercaseString] isEqualToString:@"mp4"]) {
            type=MP4;
        }
        else if([[ext lowercaseString] isEqualToString:@"jpg"]) {
            type=JPG;
        }
        else if ([[ext lowercaseString] isEqualToString:@"png"]) {
            type = PNG;
        }
        else if ([[ext lowercaseString] isEqualToString:@"tpk"]) {
            type = TPK;
        }
        else if ([[ext lowercaseString] isEqualToString:@"mov"]) {
            type = MOV;
        }
        else if ([[ext lowercaseString] isEqualToString:@"html"]) {
            type = HTML;
        }
        else if ([[ext lowercaseString] isEqualToString:@"plist"]) {
            type = PLIST;
        }
        else if ([[ext lowercaseString] isEqualToString:@"pdf"]) {
            type = PDF;
        }
        else if ([[ext lowercaseString] isEqualToString:@"txt"]){
            type = TXT;
        }
        else if ([[ext lowercaseString] isEqualToString:@"doc"]||[[ext lowercaseString] isEqualToString:@"docx"]){
            type = DOC;
        }
        else if ([[ext lowercaseString] isEqualToString:@"ppt"]||[[ext lowercaseString] isEqualToString:@"pptx"]){
            type = PPT;
        }
        else if ([[ext lowercaseString] isEqualToString:@"xls"]||[[ext lowercaseString] isEqualToString:@"xlsx"]){
            type = XLS;
        }
        else if([NSFileTypeDirectory isEqualToString:[[fm attributesOfItemAtPath: [dir stringByAppendingPathComponent:path] error: NULL] objectForKey:NSFileType]]){
            type = DIC;
        }
        else
            continue;
        
        if(hasIndex){
            //分割title 和 index
            NSArray* components = [[[path stringByDeletingPathExtension] lastPathComponent] componentsSeparatedByString:@" "];
            if(components.count < 1 || components.count > 2)
                continue;
            //确定title
            if(2 == components.count)
                title = [components objectAtIndex:1];
            else
                title = @"";
            //确定index
            index = [[components objectAtIndex:0] integerValue];
        }
        else{
            title = [[path stringByDeletingPathExtension] lastPathComponent];
            index = -1;
        }
        NSString* pathFull = [dir stringByAppendingPathComponent:path];
        [retArray addObject:[[LXCMedia alloc] initWithIndex:index title:title type:type path:pathFull] ];
        //排序
        if(hasIndex)
            [retArray sortUsingComparator:^(LXCMedia* obj1, LXCMedia* obj2) {
                // block return NSComparisonResult
                if(obj1.index > obj2.index)
                    return NSOrderedDescending;//exchange
                else if(obj1.index < obj2.index)
                    return NSOrderedAscending;//not exchange
                return NSOrderedSame;//not exchange
            }];
    }
    return retArray;
}

//获取dic media 下的文件目录array
-(NSMutableArray*)getMediaHasIndex:(BOOL)hasIndex
{
    if (self.type!=DIC) {
        NSLog(@"media error:input media is not a directory");
        return nil;
    }
    return [LXCMedia getMediasAtDir:self.path HasIndex:hasIndex];
}
@end
