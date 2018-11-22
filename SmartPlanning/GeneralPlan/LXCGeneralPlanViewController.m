//
//  LXCGeneralPlanViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/21.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCGeneralPlanViewController.h"
#import "LXCMediaSubclasses.h"
#import "LXCBigPhotoViewController.h"
#import <PPiFlatSegmentedControl.h>
#import <NSString+FontAwesome.h>
@interface LXCGeneralPlanViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet iCarousel *mainView;
@property (weak, nonatomic) IBOutlet UILabel *imageInfo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitSignal;

@property (strong, nonatomic) NSMutableArray *images;
@property (copy, nonatomic) NSArray *imagePaths;
@property (assign, nonatomic) NSUInteger currentIndex;

@end

@implementation LXCGeneralPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;

    [self initViewWithIndex:0];
    [self initSegment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViewWithIndex:(NSUInteger)index
{
    _backgroundImageView.image = [UIImage imageWithContentsOfFile:[LXCGeneralPlanMedia getGeneralPlanBgImageWithIndex:index].path];
    
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.type = iCarouselTypeLinear;
    _mainView.centerItemWhenSelected = NO;
    _mainView.contentOffset = CGSizeMake(0, -5.0f);
    _mainView.backgroundColor = [UIColor clearColor];

    _imagePaths = [LXCGeneralPlanMedia getGeneralPlanListWithIndex:index];
    _images = [NSMutableArray array];
    [_waitSignal startAnimating];
    dispatch_queue_t queue = dispatch_queue_create("GeneralPlan Image getter", NULL);
    dispatch_async(queue, ^{
        for (LXCGeneralPlanMedia *gpMedia in _imagePaths) {
            [_images addObject:[UIImage imageWithContentsOfFile:gpMedia.thumbnailPath]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainView reloadData];
            [_mainView scrollToItemAtIndex:0 animated:NO];
            _imageInfo.text = ((LXCGeneralPlanMedia*)_imagePaths[0]).title;
            [_waitSignal stopAnimating];
        });
    });
}

-(void)initSegment
{
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(452, 58, 570, 40)
                                                                             andItems:@[@"2002-2020总规",
                                                                                        @"2002-2020总规(16修订)"]
                                                                    andSelectionBlock:^(NSUInteger segmentIndex) {
        if (segmentIndex != _currentIndex)
            [self initViewWithIndex:segmentIndex];
        _currentIndex = segmentIndex;
    }];
    
    segment.color = [UIColor colorWithRed:125.0f/255.0 green:125.0f/255.0 blue:125.0f/255.0 alpha:1];
    segment.borderWidth = 1.0;
    segment.borderColor = [UIColor whiteColor];
    segment.selectedColor = [UIColor colorWithRed:46.0f/255.0 green:111.0f/255.0 blue:195.0f/255.0 alpha:1];
    segment.textFont = [UIFont fontWithName:@"FontAwesome" size:20];
    segment.textColor = [UIColor whiteColor];
    segment.selectedTextColor = [UIColor whiteColor];
    [self.view addSubview:segment];
}

#pragma mark carousel delegate
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _images.count;
}
-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _imageInfo.text = ((LXCMedia*)_imagePaths[_mainView.currentItemIndex]).title;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(view == nil)//nil OC对象 Nil 自定义类对象
    {
        FXImageView* imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 372.f, 263.f) ];
        imageView.asynchronous = NO;//异步 若开启异步则报：应在主线程中运行警告
        imageView.reflectionScale = 0.1f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.cornerRadius = 4.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = _images[index];
        view = imageView;
    }
    return view;
}
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    LXCMedia *media = (LXCMedia *)_imagePaths[index];
    if(media.type != MP4)
    {
        LXCBigPhotoViewController *sgvc = [[LXCBigPhotoViewController alloc] init];
        sgvc.imagePaths = _imagePaths;
        sgvc.currentIndex = index;
        sgvc.segueName = @"toSeeImageFromGP";
        [self.navigationController pushViewController:sgvc animated:YES];
    }
}

-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //item gap
    switch (option) {
        case iCarouselOptionSpacing:
            //add a bit of spacing between the item views
            return value * 1.1;
            break;
        default:
            return value;
    }
}


@end
