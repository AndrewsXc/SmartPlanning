//
//  LXCCityOverviewViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/25.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCCityOverviewViewController.h"
#import "LXCMediaSubclasses.h"
#import "LXCBigPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>

@interface LXCCityOverviewViewController ()
@property (strong, nonatomic) NSArray* imagePaths;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak,   nonatomic) IBOutlet iCarousel *imageListView;
@property (weak,   nonatomic) IBOutlet UILabel *imageInfo;
@property (strong, nonatomic) AVPlayerViewController* avPlayer;

@end

@implementation LXCCityOverviewViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewOfCityOverView];
}

-(void)setViewOfCityOverView{
    //未采用imageNamed 因为imageName会缓存图片 不常用的大图片建议不要用imageNamed
    _backgroundImageView.image = [UIImage imageNamed:@"CityoverviewBg"];
    _imageListView.backgroundColor = [UIColor clearColor];
    _imageListView.type = iCarouselTypeLinear;
    _imageListView.dataSource = self;
    _imageListView.delegate = self;
    _imageListView.bounceDistance = 0.3;
    _imageInfo.text=((LXCMedia*)_imagePaths[_imageListView.currentItemIndex]).title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel的委托方法
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    _imagePaths = [LXCCityOverviewMedia getMediasCityOverviewSceneDir];
    return _imagePaths.count;
}
-(UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if(view == nil)//nil OC对象 Nil 自定义类对象
    {
        FXImageView* imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 250.f, 250.f) ];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = NO;//异步 若开启异步则报：应在主线程中运行警告
        imageView.reflectionScale = 0.3f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 3.0f;
        imageView.cornerRadius = 4.0f;
        
        LXCMedia*im = _imagePaths[index];
        if(im.type == MP4)
        {
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:im.path] options:opts];
            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
            generator.appliesPreferredTrackTransform = YES;
            generator.maximumSize = CGSizeMake(250, 250);
            NSError *error = nil;
            CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(60, 24) actualTime:NULL error:&error];
            
            //合成缩略图与播放按钮
            
            //底图
            UIImage *videoThumbnail = [UIImage imageWithCGImage: img];
            //将要画在底图上的图片
            UIImage *playIcon = [UIImage imageNamed:@"PlayIcon"];
            
            //创建绘图上下文
            UIGraphicsBeginImageContext(videoThumbnail.size);
            CGContextRef context=UIGraphicsGetCurrentContext();
            
            //图像坐标变换
            CGContextTranslateCTM(context, 0, videoThumbnail.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            //绘制底图
            CGContextDrawImage(context, CGRectMake(0, 0, videoThumbnail.size.width, videoThumbnail.size.height), [videoThumbnail CGImage]);
            //在底图上绘制图片
            CGContextDrawImage(context, CGRectMake((videoThumbnail.size.width-72.)/2., (videoThumbnail.size.height-72.)/2., 72, 72), [playIcon CGImage]);
            //得到所绘制的图片
            UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
            
            //关闭上下文
            UIGraphicsEndImageContext();
            
            imageView.image = newImage;
        }
        else
            imageView.image = [UIImage imageWithContentsOfFile:im.path];
        
        if (imageView.image.size.height < imageView.image.size.width)
        {
            imageView.frame = CGRectMake(0.,(250.- 250.*imageView.image.size.height/imageView.image.size.width)/2.-30, 250., 250.);
        }
        else
        {
            imageView.frame = CGRectMake(0.,-30, 250., 250.);
        }
        view = imageView;
    }

    return view;
}
-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //item gap
    switch (option) {
        case iCarouselOptionSpacing:
            return value * 1.1;
            break;
        case iCarouselOptionVisibleItems:
            return 9;
            break;
        default:
            return value;
    }
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _imageInfo.text=((LXCMedia*)_imagePaths[_imageListView.currentItemIndex]).title;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    LXCMedia *media = (LXCMedia *)_imagePaths[index];
    if(media.type == MP4)
        [self configureAvPlayer:media.path];
    else
    {
        _imageListView.currentItemIndex = index;
        
        LXCBigPhotoViewController *sgvc = [[LXCBigPhotoViewController alloc] init];
        sgvc.imagePaths = _imagePaths;
        sgvc.currentIndex = index;
        sgvc.segueName = @"toSeeImageFromCV";
        [self.navigationController pushViewController:sgvc animated:YES];
    }
}

-(void)configureAvPlayer:(NSString*) mediaPath
{
    NSURL *avPath = [NSURL fileURLWithPath:mediaPath];
    _avPlayer = [[AVPlayerViewController alloc] init];
    _avPlayer.player = [[AVPlayer alloc] initWithURL:avPath];
    // 试图的填充模式
    _avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 是否显示播放控制条
    _avPlayer.showsPlaybackControls = YES;
    // 设置显示的Frame
    _avPlayer.view.frame = self.view.bounds;

    // 将播放器控制器添加到当前页面控制器中/ 两种方法效果一致 但会出现声频早于视频的情况
    //[self presentViewController:_avPlayer animated:YES completion:nil];
    [self showDetailViewController:_avPlayer sender:self];
    // 播放
    [_avPlayer.player play];
}

@end
