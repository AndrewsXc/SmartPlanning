//
//  LXCPhotoViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCPhotoViewController.h"
#import "LXCMedia.h"
#import <AVKit/AVPlayerViewController.h>
@interface LXCPhotoViewController ()
{
    NSUInteger _pageIndex;
    NSString *_segueName;
}
@property (strong, nonatomic)AVPlayerViewController* avPlayer;
@end

@implementation LXCPhotoViewController
+ (LXCPhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex withSegueName:(NSString *)segueName andImagePaths:(NSArray *)imagePaths
{
    if (pageIndex < imagePaths.count)
    {
        return [[self alloc] initWithPageIndex:pageIndex andSegueName:segueName andImagePaths:imagePaths];
    }
    return nil;
}
- (id)initWithPageIndex:(NSInteger)pageIndex andSegueName:(NSString *)segueName andImagePaths:(NSArray *)imagePaths
{
    self = [super init];
    if (self)
    {
        _pageIndex = pageIndex;
        _segueName = segueName;
        _imagePaths = imagePaths;
    }
    return self;
}

- (NSInteger)pageIndex
{
    return _pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView.segueName = _segueName;
    _scrollView.imagePaths = _imagePaths;
    _scrollView.index = _pageIndex;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bouncesZoom = YES;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = _scrollView;
    [_scrollView setMaxMinZoomScaleForCurrentBounds];
    _scrollView.contentSize = _scrollView.imageSize;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale];
    
    LXCMedia *media = (LXCMedia *)_imagePaths[_pageIndex];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(330., 42., 364., 42.)];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    label.text = media.title;
    [self.view addSubview:label];
    
    if(media.type == MP4 && !_avPlayer)
        [self configureAvPlayer];
}



-(void)configureAvPlayer
{
    LXCMedia *media = (LXCMedia *)_imagePaths[_pageIndex];
    
    NSURL *avPath = [NSURL fileURLWithPath:media.path];
    _avPlayer = [[AVPlayerViewController alloc] init];
    _avPlayer.player = [[AVPlayer alloc] initWithURL:avPath];
    // 试图的填充模式
    _avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 是否显示播放控制条
    _avPlayer.showsPlaybackControls = YES;
    // 设置显示的Frame
    _avPlayer.view.frame = self.view.bounds;
    // 将播放器控制器添加到当前页面控制器中
    [self addChildViewController:_avPlayer];
    // view一定要添加，否则将不显示
    [self.view addSubview:_avPlayer.view];
    // 播放
    [_avPlayer.player play];
    
}

@end
